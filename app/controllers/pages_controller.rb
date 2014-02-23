class PagesController < ApplicationController
  before_filter :signed_in_user, except: [:about, :mobile]
  before_filter :signed_in_admin, except: [:about,  :mobile, :shop, :create_admin, :authenticate]
  before_filter :admin_user,     only: :destroy

  def control
  	t = true
    f = false
    
    @user = current_user
  	@pins = Pin.find(:all)
    @menpins = Pin.find(:all, :conditions => ["sex = 'Male'"], :order => "created_at desc")
    @womenpins = Pin.find(:all, :conditions => ["sex = 'Female'"], :order => "created_at desc")

    @users = User.find(:all, :conditions => ["admin = ?", f], :order => "last_sign_in_at desc")
    @admins = User.find(:all, :conditions => ["admin = ?", t], :order => "last_sign_in_at desc")
    @active_pins = Pin.active_pins.count
    @active_menpins = Pin.find(:all, :conditions => ["active = ? AND sex = 'Male'", t]).count
    @active_womenpins = Pin.find(:all, :conditions => ["active = ? AND sex = 'Female'", t]).count
    
    admin_ids = @admins.map(&:id)
    @views = View.real_user_views(admin_ids)


    yes = View.real_user_yes(admin_ids).count.to_f
    @percent_yes = yes / @views.count.to_f * 100

    @clicks = Click.real_user_clicks(admin_ids)
    shop = Click.real_user_shops(admin_ids).count.to_f
    @percent_shop = shop / @clicks.count.to_f * 100


  end

  def create_admin

  end

  def authenticate
  	adminpass = params[:adminpass]

  	if adminpass == 'FleurAdminNow1'
  		current_user.update_attribute :admin, true
  		redirect_to control_path, notice: 'User was made admin successfully.'
  	else	
  		redirect_to control_path, notice: 'Make admin failed. Enter correct password.'
  	end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to control_user }
      format.json { head :no_content }
    end
  end
  
  def allpins
    @user = current_user
    @allheader = "All"
    @pins = Pin.find(:all, :order => "created_at desc")

  end  

  def menpins
    @allheader = "Active Male"
    @pins = Pin.find(:all, :conditions => ["sex = 'Male'"], :order => "created_at desc")

  end

  def womenpins
    @allheader = "Active Female"
    @pins = Pin.find(:all, :conditions => ["sex = 'Female'"], :order => "created_at desc")

  end

  def allusers
    t = true
    f = false
     @users = User.find(:all, :conditions => ["admin = ?", f], :order => "last_sign_in_at desc")
    @admins = User.find(:all, :conditions => ["admin = ?", t], :order => "last_sign_in_at desc")
  end

  def mobile

  end

  def shop
   views = View.user_liked(current_user)
    seen = views.map(&:pin_id)
    @pins = Pin.user_pins(seen)

    if params[:pricetop]
      max_price = params[:pricetop].gsub(/[$]/, '$' => '').to_f
      if max_price > 0
        @pins = @pins.select { |pin| pin.price < max_price } 
        @price_placeholder = "Items under $" + max_price.round(0).to_s
      else
        @price_placeholder = "Enter Price"
      end 
    else
      @price_placeholder = "Enter Price"
    end
     @pins = @pins.paginate(:page => params[:page], :per_page => 5)
end

  private

      def signed_in_user
        unless user_signed_in?
          redirect_to new_user_session_path, notice: "Please sign in to view this page."
        end
      end

      def signed_in_admin
        unless current_user.try(:admin?)
          redirect_to pages_create_admin_path, notice: "User must be an Admin to access this page."
        end
      end

      def admin_user
        redirect_to(root_path) unless current_user.admin?
      end

end

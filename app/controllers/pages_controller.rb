class PagesController < ApplicationController
  def home
  end
  def action
  end

  def control
  	t = true
    f = false
    if current_user
    @user = current_user
  	@pins = Pin.find(:all)

    @users = User.find(:all, :conditions => ["admin = ?", f], :order => "last_sign_in_at desc")
    @admins = User.find(:all, :conditions => ["admin = ?", t], :order => "last_sign_in_at desc")
    @active_pins = Pin.active_pins.count
    
    admin_ids = @admins.map(&:id)
    @views = View.real_user_views(admin_ids)


    yes = View.real_user_yes(admin_ids).count.to_f
    @percent_yes = yes / @views.count.to_f * 100

    @clicks = Click.real_user_clicks(admin_ids)
    shop = Click.real_user_shops(admin_ids).count.to_f
    @percent_shop = shop / @clicks.count.to_f * 100

  
    end

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
    @pins = Pin.find(:all, :order => "created_at desc")

  end  

  def allusers
    t = true
    f = false
     @users = User.find(:all, :conditions => ["admin = ?", f], :order => "last_sign_in_at desc")
    @admins = User.find(:all, :conditions => ["admin = ?", t], :order => "last_sign_in_at desc")
  end

  def mobile

  end

end

class PagesController < ApplicationController
  before_filter :signed_in_user, except: [:about, :mobile, :test]
  before_filter :signed_in_admin, except: [:about,  :mobile, :shop, :create_admin, :authenticate, :test]
  before_filter :admin_user, only: :destroy

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
     @pins = @pins.paginate(:page => params[:page], :per_page => 20)
  end

  def test
    #@pins = Pin.joins(:views => :user).where("views.sex = ? and views.active = ? and users.id not in (?)", current_user.sex, true, [current_user.id])
    @user = "chrisjfin"

    @all_friends = fetch_all_friends("chrisjfin")
  end
 
def fetch_all_friends(twitter_username, max_attempts = 100)
  # in theory, one failed attempt will occur every 15 minutes, so this could be long-running
  # with a long list of friends
  num_attempts = 0
  client = twitter_client
  myfile = File.new("#{twitter_username}_friends_list.txt", "w")
  running_count = 0
  cursor = -1
  while (cursor != 0) do
    begin
      num_attempts += 1
      # 200 is max, see https://dev.twitter.com/docs/api/1.1/get/friends/list
      friends = client.friends(twitter_username, {:cursor => cursor, :count => 200} )
      friends.each do |f|
        running_count += 1
        myfile.puts "\"#{running_count}\",\"#{f.name.gsub('"','\"')}\",\"#{f.screen_name}\",\"#{f.url}\",\"#{f.followers_count}\",\"#{f.location.gsub('"','\"').gsub(/[\n\r]/," ")}\",\"#{f.created_at}\",\"#{f.description.gsub('"','\"').gsub(/[\n\r]/," ")}\",\"#{f.lang}\",\"#{f.time_zone}\",\"#{f.verified}\",\"#{f.profile_image_url}\",\"#{f.website}\",\"#{f.statuses_count}\",\"#{f.profile_background_image_url}\",\"#{f.profile_banner_url}\""
      end
      puts "#{running_count} done"
      cursor = friends.next_cursor
      break if cursor == 0
    rescue Twitter::Error::TooManyRequests => error
      if num_attempts <= max_attempts
        cursor = friends.next_cursor if friends && friends.next_cursor
        puts "#{running_count} done from rescue block..."
        puts "Hit rate limit, sleeping for #{error.rate_limit.reset_in}..."
        sleep error.rate_limit.reset_in
        retry
      else
        raise
      end
    end
  end
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

    def twitter_client
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = "1195067634-B7v3vQwKrrjanVsfWhYUJAaEKUtMhngind2b3DO"
        config.access_token_secret = "OrdjE8HjvCkAYIl2ySptFN7sjO3UKWBGbmLLjEUV51Bw4"
      end
    end

end

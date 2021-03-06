class RegistrationsController < Devise::RegistrationsController
after_filter :send_welcome, :only => :create
after_filter :views_create, :only => :create

def create
    build_resource(sign_up_params)
    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
    session[:omniauth] = nil unless @user.new_record?
  end

  def build_resource(*args)
  super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def send_welcome	
	 UserMailer.welcome_email(@user).deliver unless @user.invalid?
  end

  def views_create
    user = session[:ranks] 
    if user.class == Hash
      user.each do |pin, rank|
        view = View.new
        view.user_id = User.last.id
        view.pin_id = pin.to_i
        view.rank = rank.to_i
        view.save
      end
    end
     session.delete(:ranks)
  end

end
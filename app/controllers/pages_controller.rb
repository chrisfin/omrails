class PagesController < ApplicationController
  def home
  end
  def action
  end

  def control
  	@user = current_user
  	@pins = @user.pins
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
   
end

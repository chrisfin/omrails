class PagesController < ApplicationController
  def home
  end
  def action
  end

  def control
  	if current_user
    @user = current_user
  	@pins = Pin.find(:all)
    @views = View.find(:all)
    @users = User.find(:all)
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

end

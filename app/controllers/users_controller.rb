class UsersController < ApplicationController
  
  def show
 	@user = User.find(params[:id])
 	@pins = @user.pins.order("created_at desc").page(params[:page]).per_page(20)
  UserMailer.welcome_email(@user).deliver
  end

  def edit
    @pin = current_user.pins.find(params[:id])

  end


def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to control_path }
      format.json { head :no_content }
    end
 end

end

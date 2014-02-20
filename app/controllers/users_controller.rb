class UsersController < ApplicationController
 before_filter :signed_in_admin

  def show
 	@user = User.find(params[:id])
 	@pins = @user.pins.order("created_at desc").page(params[:page]).per_page(20)
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

private

  def signed_in_admin
        unless current_user.try(:admin?)
          redirect_to pages_create_admin_path, notice: "User must be an Admin to access this page."
        end
      end
end

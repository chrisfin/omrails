class UsersController < ApplicationController
  def show
 	@user = User.find(params[:id])
 	@pins = @user.pins.order("created_at desc").page(params[:page]).per_page(20)

  end

  def edit
    @pin = current_user.pins.find(params[:id])

  end


end

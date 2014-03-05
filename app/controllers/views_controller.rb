class ViewsController < ApplicationController
  before_filter :signed_in_user, only: [:show, :allviews]
  before_filter :signed_in_admin, only: [:destroy, :show]

def show
	@views = View.order("created_at desc")
	
end

def create
	@view = View.new
	@view.user_id = params[:user_id]
	@view.pin_id = params[:pin_id]
	@view.rank = params[:rank]

	if @view.save
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  else
    render action: "new"
  end
end

def new_user_save
    store_rank(params[:pin_id], params[:rank])
    @pin = Pin.find(params[:pin_id])
    redirect_to root_path(item: @pin.item_type, brand: @pin.brand_id)
end

def destroy
    @view = View.find(params[:id])
    @view.destroy

    respond_to do |format|
      format.html { redirect_to views_show_path }
      format.json { head :no_content }
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

      def store_rank(pin, rank)
        if  session[:ranks] == nil
            session[:ranks] = Hash.new
            session[:ranks].merge!(pin => rank)
        else
            session[:ranks].merge!(pin => rank)
        end
      end

end

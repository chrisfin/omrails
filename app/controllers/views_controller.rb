class ViewsController < ApplicationController
  before_filter :signed_in_user, only: [:show, :allviews]
  before_filter :signed_in_admin, only: [:destroy, :show]

def show
	@views = View.order("created_at desc")
	
end

def create
	@view = View.new
	@view.user_id = params[:user_id]
	@view.pin_id =  params[:pin_id]
	@view.rank =  params[:rank]

	if @view.save
        redirect_to root_path
    else
        render action: "new"
    end
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

end

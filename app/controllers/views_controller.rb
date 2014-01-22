class ViewsController < ApplicationController

def show
	@views = View.order("created_at desc")
end

def create
	@view = View.new
	@view.user_id = params[:user_id]
	@view.pin_id =  params[:pin_id]


	if @view.save
        redirect_to root_path
    else
        format.html { render action: "new" }
    end
end

end

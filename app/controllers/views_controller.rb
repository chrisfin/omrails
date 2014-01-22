class ViewsController < ApplicationController

def show
	@views = View.order("created_at desc")
	@user_views = View.user_views(current_user)
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

def shop
	views = View.user_liked(current_user)
    seen = views.map(&:pin_id)
    @pins = Pin.user_pins(seen)
end

end

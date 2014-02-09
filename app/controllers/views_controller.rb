class ViewsController < ApplicationController

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

def shop
	 views = View.user_liked(current_user)
    seen = views.map(&:pin_id)
    @pins = Pin.user_pins(seen)

    if params[:pricetop]
      max_price = params[:pricetop].gsub(/[$]/, '$' => '').to_f
      if max_price > 0
        @pins = @pins.select { |pin| pin.price < max_price } 
        @price_placeholder = "Items under $" + max_price.round(0).to_s
      else
        @price_placeholder = "Enter Price"
      end 
    else
      @price_placeholder = "Enter Price"
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

end

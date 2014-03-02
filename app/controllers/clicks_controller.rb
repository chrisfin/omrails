class ClicksController < ApplicationController

def create
	@click = current_user.clicks.build(pin_id: params[:pin_id], place: params[:place])
	@pin = Pin.find(:first, :conditions => ["id = ?", @click.pin_id])

	if @click.save
        redirect_to @pin.product_url
    else
        render root_path 
        flash[:error] = "That click did not save"
    end
end

def show
	@clicks = Click.order("created_at desc")
	
end

def destroy
    @click = Click.find(params[:id])
    @click.destroy

    respond_to do |format|
      format.html { redirect_to clicks_show_path }
      format.json { head :no_content }
    end
  end


end

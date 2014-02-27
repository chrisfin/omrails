class PinsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  before_filter :signed_in_user, only: [:new, :edit, :create, :update, :destroy]
  before_filter :signed_in_admin, only: [:new, :edit, :create, :update, :destroy]


ITEM_TYPE_LIST = ["Shoes", "Accessories", "Tops", "Shirts", "Sweaters", "Sweatshirts", "Dresses", "Jeans", "Pants", "Leggings", "Shorts", "Skirts", "Blazers", "Suits", "Jackets", "Swim"]

  # GET /pins
  # GET /pins.json
  def index

# Establish daly counter to limmit user views to perdetermined number or make @pins == nil
    seen = Array.new
    max_pins = 20
    
    if current_user 
      # Get new pins for a signed in user   
      sex = current_user.sex
      views = View.user_views(current_user)
      seen = views.map(&:pin_id)
      @pins = Pin.new_pin(seen, sex)
         
      views_today = View.views_today(current_user)
      unseen = Pin.all_new_pins(seen, sex).count
      @daily_counter = [max_pins - views_today.count, unseen ].min
    
    # Get new pins for a non-registered user who has ranked an item.  
    elsif session[:ranks].class == Hash
      sex = "Female"
      session[:ranks].each {|key, value| seen << key.to_i }
      @pins = Pin.new_pin(seen, sex)
      
      views_today = seen
      unseen = Pin.all_new_pins(seen, sex).count
      @daily_counter = [20 - views_today.count, unseen ].min
    else 
      sex = "Female"
      @pins = Pin.new_pin(seen, sex)
      unseen = Pin.all_new_pins(seen, sex).count
      @daily_counter = [max_pins, unseen ].min
    end

  # Resets @pins if user has seen more than 20 items in a day
    if @daily_counter <= 0
      @pins = nil
    end

  # Catalog of all pins user has Viewed and ranked Yes
    yes = Array.new
    
    if current_user
      yes_views = View.user_liked(current_user)
      yes = yes_views.map(&:pin_id)
      @user_pins = Pin.user_pins(yes)
        # Paginates catalog
    elsif session[:ranks].class == Hash
      session[:ranks].each do |key, value| 
        if value == "1"
          yes << key.to_i
        end
      end
      @user_pins = Pin.user_pins(yes)
    else
      @user_pins = Array.new
    end
 
    @user_pins = @user_pins.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pins }
      format.js
    end
  end 

  # GET /pins/1
  # GET /pins/1.json
  def show
    @pin = Pin.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pin }
    end
  end

  # GET /pins/new
  # GET /pins/new.json
  def new
    @pin = current_user.pins.new
    @items_types = ITEM_TYPE_LIST
    @brands = Brand.find(:all, :order => "name")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pin }
    end
  end

  # GET /pins/1/edit
  def edit
    @edit_return = params[:page]
    @pin = Pin.find(params[:id])
    @items_types = ITEM_TYPE_LIST
    @brands = Brand.find(:all, :order => "name")

  end

  # POST /pins
  # POST /pins.json
  def create
    @pin = current_user.pins.new(params[:pin])
    @pin.user_id = current_user.id
    @items_types = ITEM_TYPE_LIST

    respond_to do |format|
      if @pin.save
        format.html { redirect_to @pin, notice: 'Pin was successfully created.' }
        format.json { render json: @pin, status: :created, location: @pin }
      else
        format.html { render action: "new" }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pins/1
  # PUT /pins/1.json
  def update
    @pin = Pin.find(params[:id])
    @user = current_user

    respond_to do |format|
      if @pin.update_attributes(params[:pin])
        format.html { redirect_to allpins_path, notice: 'Pin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pins/1
  # DELETE /pins/1.json
  def destroy
    @pin = Pin.find(params[:id])
    @pin.destroy

    respond_to do |format|
      format.html { redirect_to allpins_path }
      format.json { head :no_content }
    end
  end

  def test

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

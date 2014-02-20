class PinsController < ApplicationController
  before_filter :authenticate_user!, except: [:index]
  before_filter :signed_in_user, only: [:new, :edit, :create, :update, :destroy]
  before_filter :signed_in_admin, only: [:new, :edit, :create, :update, :destroy]


ITEM_TYPE_LIST = ["Shoes", "Accessories", "Tops", "Shirts", "Sweaters", "Sweatshirts", "Dresses", "Jeans", "Pants", "Leggings", "Shorts", "Skirts", "Blazers", "Suits", "Jackets", "Swim"]

  # GET /pins
  # GET /pins.json
  def index
    @newpin = Pin.last(:conditions => ["sex = 'Female'"], :order => "created_at desc", :limit => 1)
    
    if current_user
    sex = current_user.sex
    else
    sex = "Female"
    end 

    views = View.user_views(current_user)
    seen = views.map(&:pin_id) << -1
    unseen = Pin.all_new_pins(seen, sex).count
    
    views_today = View.views_today(current_user)

    @daily_counter = [20 - views_today.count, unseen ].min

    if @daily_counter > 0
      @pins = Pin.new_pin(seen, sex)
    else
      @pins = nil
    end
    
    yes_views_today = View.yes_views_today(current_user)
    seen_today = yes_views_today.map(&:pin_id)
    @pins_today = Pin.user_pins(seen_today).last(3).reverse

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

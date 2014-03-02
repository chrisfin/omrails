module PinsHelper
def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def pin_percent_views(pin, rank)
    rank_pins = pin.views.count(:conditions => ["rank = ?", rank]).to_f
    all_pins = pin.views.count.to_f
    return (rank_pins / all_pins) * 100
  end

  def pin_percent_clicks(pin, place)
    click_pins = pin.clicks.count(:conditions => ["place = ?", place]).to_f
    all_pins = pin.clicks.count.to_f
    return (rank_pins / all_pins) * 100
  end
end

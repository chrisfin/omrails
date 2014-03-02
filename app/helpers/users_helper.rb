module UsersHelper

	def user_percent_views(user, rank)
    rank_pins = user.views.count(:conditions => ["rank = ?", rank]).to_f
    all_pins = user.views.count.to_f
    return (rank_pins / all_pins) * 100
  end

	def user_percent_clicks(user, place)
    rank_pins = user.clicks.count(:conditions => ["place = ?", place]).to_f
    all_pins = user.clicks.count.to_f
    return (rank_pins / all_pins) * 100
  end  

end

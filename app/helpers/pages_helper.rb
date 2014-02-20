module PagesHelper

  def store_location
    session[:return_to] = request.url if request.get?
  end

end

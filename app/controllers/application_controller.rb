class ApplicationController < ActionController::Base
  protect_from_forgery

  @sex = ["Female", "Male"]
end

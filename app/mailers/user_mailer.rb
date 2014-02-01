class UserMailer < ActionMailer::Base
  default from: 'Fleur <chris@shopfleur.co>',
  		reply_to: 'chris@shopfleur.co'

  def welcome_email(user)
  	@user = user
    mail(to: @user.email, subject: 'Welcome to Fleur')
  end

end

class MessageMailer < ActionMailer::Base
  default from: "noreply@ewataryma.com"
  
  def notify(message)
    @message  = message
    mail(:to => 'jan.florjanczyk@gmail.com, piotr.myslinski@comcast.net', :subject => "New message on ewataryma.com")
  end
end

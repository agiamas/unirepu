class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    session[:account_token] = auth['credentials']['token']
    session[:account_token_secret] = auth['credentials']['secret']

    redirect_to '/dashboard/index', :notice => "Signed in!"
  end
end

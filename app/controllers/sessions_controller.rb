class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)

    if user.persisted?
      sign_in user, event: :authentication
      session[:user_id] = user.id
      session[:account_token] = auth['credentials']['token']
      session[:account_token_secret] = auth['credentials']['secret']
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: auth["provider"] if is_navigational_format?

      return redirect_to '/dashboard/index', :notice => "Signed in!"
    else
      session["devise.provider_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end


  end
end

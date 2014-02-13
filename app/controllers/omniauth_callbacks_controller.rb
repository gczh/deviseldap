class OmniauthCallbacksController < ApplicationController
	def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @request = request.env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(@request.provider, @request.uid, @request.extra.raw_info.name, @request.info.email, current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      redirect_to stores_path, :event => :authentication, :current_user => @user
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        if current_user.nil? # user is unauthorized because he/she is not logged in
          session[:next] = request.fullpath
          redirect_to new_user_session_path, :flash => { :info => "Please log in to continue." }
        else
          if request.env["HTTP_REFERER"].present?
            redirect_to :back, :flash => { :info => exception.message }
          else
            render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
          end
        end
      end

      format.json do
        # Show authorization error using JSON format
        render json: { status: 403, message: exception.message } , status: :forbidden
      end
    end
  end

  # the following code for redirecting users back to previous page/activity references the following url
  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update

  before_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        request.fullpath != "/users/sign_out" &&
        request.fullpath != "/users/password" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end

end

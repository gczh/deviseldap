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
end

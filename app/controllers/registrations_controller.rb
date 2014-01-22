class RegistrationsController < Devise::RegistrationsController
  def destroy
  	@user = User.find(current_user.id)
  	@user.is_active = 0
  	if @user.save
  		sign_out @user
  		redirect_to root_path
  	else
  		render "edit"
  	end
  end
end

#./app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController

  def create
    if verify_recaptcha
      flash.delete :recaptcha_error
      super
    else
      flash.delete :recaptcha_error
      build_resource
      resource.valid?
      resource.errors.add(:base, "There was an error with the recaptcha code below. Please re-enter the code.")
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render :new }
    end
  end

end


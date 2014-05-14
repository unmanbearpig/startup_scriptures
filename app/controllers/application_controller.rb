class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  helper CategoriesHelper
  helper AuthHelper
  helper FlashHelper

  include FlashHelper
  include AuthHelper

  protected

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  def redirect_to_resource_if_valid instance
    if instance.valid?
      redirect_to instance
    else
      flash_messages_from_errors(instance.errors)
      redirect_to :back
    end
  end
end

module AuthHelper
  def admin_signed_in?
    user_signed_in? && current_user.is_admin
  end

  # returns true if user is admin, false otherwise
  def make_sure_admin_signed_in
    if admin_signed_in?
      true
    else
      if user_signed_in?
        not_permitted!
      else
        redirect_to new_user_session_path
      end
      false
    end
  end

  def not_permitted!
    flash[:alert] = "You don't have access to that page"
    redirect_to root_path
  end
end

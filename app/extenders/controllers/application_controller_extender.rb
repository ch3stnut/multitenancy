::ApplicationController.class_eval do
  def current_account
    @current_account ||= Subscribem::Account.find_by_subdomain(request.subdomain)
  end

  def current_user
    if user_signed_in?
      @current_user ||= begin
        user_id = env['warden'].user(scope: :user)
        Subscribem::User.find(user_id)
      end
    end
  end

  def user_signed_in?
    env['warden'].authenticated?(:user)
  end

  def authenticate_user!
    unless user_signed_in?
      flash[:info] = "Please sign in."
      redirect_to '/sign_in'
    end
  end

  def force_authentication!(user)
    env['warden'].set_user(user.id, scope: :user)
  end

  helper_method :current_account, :current_user, :user_signed_in?
end
module SessionsHelper

  def sign_in(admin)
    cookies.permanent.signed[:remember_token] = [admin.id, admin.salt]
    self.current_admin = admin
  end
  
  def current_admin=(admin)
    @current_admin = admin
  end

  def current_admin
    @current_admin ||= admin_from_remember_token
  end

  def sign_in(admin)
    cookies.permanent.signed[:remember_token] = [admin.id, admin.salt]
    self.current_admin = admin
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_admin = nil
  end

  def signed_in?
    !current_admin.nil?
  end

  def current_admin?(admin)
    admin == current_admin
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

    def admin_from_remember_token
      Admin.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end

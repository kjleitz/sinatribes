module Helper

  def logged_in?
    !!current_user
  end

  def current_user
    # the "if session[:id]" portion seems redundant, but it prevents an
    # unnecessary database query. BITCHIN'.
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

end

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # ビューでも current_user や logged_in? が使えるようにする宣言
  helper_method :current_user, :logged_in?

  private

  # ログイン中のユーザーを返すメソッド
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ログインしているかどうか（true/false）を返すメソッド
  def logged_in?
    current_user.present?
  end
end
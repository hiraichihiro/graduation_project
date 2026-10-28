class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 登録成功時の処理（あとでログイン状態の保持
      session[:user_id] = @user.id
      flash[:success] = "ユーザー登録が完了しました！"
      redirect_to root_path # いったんトップページに飛ばす設定にする
    else
      # 登録失敗時は新規登録画面を再表示
      render :new, status: :unprocessable_entity
    end
  end

  def guest_sign_in
    # ゲスト用の固定ユーザーを探す。いなければ作成する
    user = User.find_or_create_by!(email: 'guest@example.com') do |u|
      u.name = 'ゲストユーザー'
      u.password = SecureRandom.urlsafe_base64 # ランダムなパスワードを設定
    end

    # ログイン処理（セッションにユーザーIDを保存する等）
    session[:user_id] = user.id
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
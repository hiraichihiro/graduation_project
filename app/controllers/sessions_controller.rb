class SessionsController < ApplicationController
  def new
    # ログイン画面を表示するアクション（中身は空っぽでOKです）
  end

  def create
    # 1. フォームから送られてきたメールアドレスでユーザーを検索する
    user = User.find_by(email: params[:session][:email].downcase)

    # 2. ユーザーが存在し、かつパスワードが正しいか認証する
    if user && user.authenticate(params[:session][:password])
      # 3. ログイン成功：セッションにユーザーIDを保存してマイページ等にリダイレクト
      session[:user_id] = user.id
      flash[:notice] = "ログインしました"
      redirect_to root_path # 後でマイページなどに変更してもOKです
    else
      # 4. ログイン失敗：エラーメッセージを出してログイン画面を再表示
      flash.now[:alert] = "メールアドレスまたはパスワードが違います"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # ログアウト処理：セッションのユーザーIDを削除してトップページへ
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to root_path, status: :see_other
  end
end
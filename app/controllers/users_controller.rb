class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # 登録成功時の処理（あとでログイン状態の保持などを追加します）
      flash[:success] = "ユーザー登録が完了しました！"
      redirect_to root_path # いいったんトップページに飛ばす設定にします
    else
      # 登録失敗時は新規登録画面を再表示
      render :new, status: :unprocessable_entity
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
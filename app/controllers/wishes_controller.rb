class WishesController < ApplicationController

  before_action :logged_in_user

  def new
    @wish = Wish.new
  end

  def create
    @wish = current_user.wishes.build(wish_params)
    if @wish.save
      redirect_to wishes_path, notice: '叶えたいこと・欲しいものを登録しました！' # 一覧画面などの遷移先
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @wishes = current_user.wishes.order(created_at: :desc)
  end

  def show
    @wish = current_user.wishes.find(params[:id])
    
    # 💡 追加：このWishに紐づく過去の金額とメモの一覧（重複なし）を取得する
    @existing_amounts = @wish.savings.distinct.pluck(:amount).compact
    @existing_memos = @wish.savings.distinct.pluck(:memo).reject(&:blank?)
    
    @saving = Saving.new unless @saving
  end

  def edit
    @wish = current_user.wishes.find(params[:id])
  end

  def update
    @wish = current_user.wishes.find(params[:id])
    if @wish.update(wish_params)
      redirect_to wish_path(@wish), notice: '叶えたいこと・欲しいものを更新しました！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @wish = current_user.wishes.find(params[:id])
    @wish.destroy
    redirect_to wishes_path, notice: '叶えたいこと・欲しいものを削除しました。', status: :see_other
  end

  def fulfilled
    @wishes = current_user.wishes.where.not(fulfilled_at: nil).order(fulfilled_at: :desc)
  end

  # ✨ 達成 / 未達成を切り替えるアクション
  def toggle_fulfillment
    @wish = current_user.wishes.find(params[:id])
    if @wish.fulfilled_at.present?
      @wish.update(fulfilled_at: nil)
      redirect_to wishes_path, notice: "未達成に戻しました🌱"
    else
      @wish.update(fulfilled_at: Time.current)
      redirect_to fulfilled_wishes_path, notice: "おめでとうございます！🎉 叶ったことリストに移動しました✨"
    end
  end

  private

  def wish_params
    params.require(:wish).permit(:title, :target_amount, :deadline, :link_url, :memo, :image)
  end

  def logged_in_user
    unless current_user
      flash[:alert] = 'ログインしてください'
      redirect_to login_path # ログイン画面のパス（routes.rbのルーティングに合わせて変更してね）
    end
  end
end
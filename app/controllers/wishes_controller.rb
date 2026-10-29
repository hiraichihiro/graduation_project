class WishesController < ApplicationController
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

  private

  def wish_params
    params.require(:wish).permit(:title, :target_amount, :deadline, :link_url, :memo, :image)
  end
end
class WishesController < ApplicationController
  def new
    @wish = Wish.new
  end

  def create
    @wish = current_user.wishes.build(wish_params)
    if @wish.save
      redirect_to wishes_path, notice: '叶えたいことを登録しました！' # 一覧画面などの遷移先
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @wishes = current_user.wishes.order(created_at: :desc)
  end

  def show
    @wish = current_user.wishes.find(params[:id])
  end

  private

  def wish_params
    params.require(:wish).permit(:title, :target_amount, :deadline, :link_url, :memo, :image)
  end
end
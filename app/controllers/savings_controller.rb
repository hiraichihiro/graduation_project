class SavingsController < ApplicationController
  def create
    @wish = Wish.find(params[:wish_id])
    @saving = @wish.savings.build(saving_params)
    
    if @saving.save
      redirect_to wish_path(@wish), notice: '貯金記録を保存しました！'
    else
      # 万が一保存に失敗した場合の処理（詳細ページや一覧へ戻すなど）
      redirect_to wish_path(@wish), alert: '貯金記録の保存に失敗しました。'
    end
  end

  def edit
    @wish = Wish.find(params[:wish_id])
    @saving = @wish.savings.find(params[:id])
  end

  def update
    @wish = Wish.find(params[:wish_id])
    @saving = @wish.savings.find(params[:id])
    
    if @saving.update(saving_params)
      redirect_to wish_path(@wish), notice: '貯金記録を更新しました！'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def saving_params
    params.require(:saving).permit(:amount, :saved_at, :memo)
  end
end
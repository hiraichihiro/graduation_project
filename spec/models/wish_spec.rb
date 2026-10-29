require 'rails_helper'

RSpec.describe Wish, type: :model do
  describe 'バリデーションのテスト' do
    it 'タイトルがあれば有効であること' do
      user = FactoryBot.create(:user)
      wish = user.wishes.build(title: 'お気に入りのバッグ', target_amount: 30000)
      expect(wish).to be_valid
    end

    it 'タイトルが空では無効であること' do
      wish = Wish.new(title: '')
      expect(wish).not_to be_valid
      expect(wish.errors[:title]).to include('を入力してください')
    end
  end

  describe '計算メソッドのテスト' do
    let(:user) { FactoryBot.create(:user) }
    let(:wish) { user.wishes.create(title: 'カメラ', target_amount: 10000, deadline: Date.today + 10) }

    it 'total_savedが貯金額の合計を返すこと' do
      wish.savings.create(amount: 2000, saved_at: Date.today) # ← saved_atに変更！
      wish.savings.create(amount: 3000, saved_at: Date.today) # ← saved_atに変更！
      expect(wish.total_saved).to eq(5000)
    end

    it 'remaining_amountが残り必要な金額を正しく計算すること' do
      wish.savings.create(amount: 4000, saved_at: Date.today) # ← saved_atに変更！
      expect(wish.remaining_amount).to eq(6000)
    end

    it 'progress_percentageが進捗率のパーセンテージを正しく計算すること' do
      wish.savings.create(amount: 5000, saved_at: Date.today) # ← saved_atに変更！
      expect(wish.progress_percentage).to eq(50)
    end
  end
end
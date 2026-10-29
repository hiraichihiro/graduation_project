require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    # 1. 有効なデータのときはテストが通る（有効性）
    it '名前、メールアドレス、パスワードが存在すれば登録できること' do
      user = User.new(
        name: 'テストユーザー',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user).to be_valid
    end

    # 2. 名前のバリデーション
    it '名前が空では登録できないこと' do
      user = User.new(name: '', email: 'test@example.com', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include('を入力してください') # エラーメッセージはアプリの設定に合わせて調整してね
    end

    # 3. メールアドレスのバリデーション
    it 'メールアドレスが空では登録できないこと' do
      user = User.new(name: 'テストユーザー', email: '', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('を入力してください')
    end

    # 4. パスワードの長さのバリデーション
    it 'パスワードが6文字未満では登録できないこと' do
      user = User.new(name: 'テストユーザー', email: 'test@example.com', password: '12345', password_confirmation: '12345')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('は6文字以上で入力してください')
    end
  end
end
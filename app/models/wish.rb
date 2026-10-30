class Wish < ApplicationRecord
  belongs_to :user
  has_many :savings, dependent: :destroy
  # Active Storageで1枚の画像を紐付ける設定
  has_one_attached :image

  # バリデーション（タイトルは必須）
  validates :title, presence: true

  # 目標金額が空でないこと、かつ0以上の数値であること
  validates :target_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # 1. 現在の貯金額の合計
  def total_saved
    savings.sum(:amount)
  end

  # 2. 残り必要な金額（目標金額 - 現在の貯金額。マイナスにはならないように0以上にする）
  def remaining_amount
    return 0 unless target_amount.present?
    amount = target_amount - total_saved
    amount > 0 ? amount : 0
  end

  # 3. 進捗率（パーセンテージ）
  def progress_percentage
    return 0 unless target_amount.present? && target_amount > 0
    ((total_saved.to_f / target_amount) * 100).floor
  end

  # 4. 残り日数（期限 - 今日）
  def remaining_days
    return nil unless deadline.present?
    (deadline - Date.today).to_i
  end

  # 5. 1日あたりの必要貯金額
  def daily_savings_target
    return nil unless deadline.present? && target_amount.present?
    days = remaining_days
    return nil if days.nil? || days <= 0

    # 残り金額を残り日数で割る（切り上げ）
    (remaining_amount.to_f / days).ceil
  end
end
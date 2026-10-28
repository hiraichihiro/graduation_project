class Wish < ApplicationRecord
  belongs_to :user

  # Active Storageで1枚の画像を紐付ける設定
  has_one_attached :image

  # バリデーション（タイトルは必須）
  validates :title, presence: true
end
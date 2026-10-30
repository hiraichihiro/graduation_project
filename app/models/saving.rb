class Saving < ApplicationRecord
  belongs_to :wish
  # 金額が空でないこと、かつ0より大きい数値であること（マイナスや0を防ぐ場合）
  validates :amount, presence: true, numericality: { greater_than: 0 }
end

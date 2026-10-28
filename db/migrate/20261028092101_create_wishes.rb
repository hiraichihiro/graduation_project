class CreateWishes < ActiveRecord::Migration[7.2]
  def change
    create_table :wishes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.integer :target_amount
      t.date :deadline
      t.string :link_url
      t.text :memo
      t.datetime :fulfilled_at

      t.timestamps
    end
  end
end

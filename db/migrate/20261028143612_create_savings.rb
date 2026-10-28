class CreateSavings < ActiveRecord::Migration[7.2]
  def change
    create_table :savings do |t|
      t.references :wish, null: false, foreign_key: true
      t.integer :amount
      t.date :saved_at
      t.text :memo

      t.timestamps
    end
  end
end

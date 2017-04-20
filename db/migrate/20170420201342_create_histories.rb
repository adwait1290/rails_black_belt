class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :lender, index: true, foreign_key: true
      t.references :borrower, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

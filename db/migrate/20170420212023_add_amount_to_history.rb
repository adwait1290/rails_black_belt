class AddAmountToHistory < ActiveRecord::Migration
  def change
    add_column :histories, :amount, :integer
  end
end

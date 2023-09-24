class AddDebitAndCreditToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :debit, :decimal
    add_column :expenses, :credit, :decimal
  end
end

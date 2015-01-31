class AddPaymentInformationToEvents < ActiveRecord::Migration
  def change
    add_column :events, :payment_iban, :string
    add_column :events, :payment_bic, :string
  end
end

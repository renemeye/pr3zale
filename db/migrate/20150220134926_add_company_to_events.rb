class AddCompanyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :company_name, :string
    add_column :events, :company_address, :text
  end
end

class AddAttachmentBillLogoToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :bill_logo
    end
  end

  def self.down
    remove_attachment :events, :bill_logo
  end
end

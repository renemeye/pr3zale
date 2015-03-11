class AddAttachmentPassbookBackground2xToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :passbook_background_2x
    end
  end

  def self.down
    remove_attachment :events, :passbook_background_2x
  end
end

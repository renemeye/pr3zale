class AddAttachmentPassbookIcon2xToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :passbook_icon_2x
    end
  end

  def self.down
    remove_attachment :events, :passbook_icon_2x
  end
end

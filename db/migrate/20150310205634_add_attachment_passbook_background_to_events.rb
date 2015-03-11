class AddAttachmentPassbookBackgroundToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :passbook_background
    end
  end

  def self.down
    remove_attachment :events, :passbook_background
  end
end

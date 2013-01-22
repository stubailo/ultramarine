class AddFacebookUploadedBitToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :facebook_bit, :integer
  end
end

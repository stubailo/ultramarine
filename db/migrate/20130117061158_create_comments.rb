class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.references :picture
      t.belongs_to :parent
      t.text :body

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :picture_id
    add_index :comments, :parent_id
  end
end

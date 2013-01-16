class RemoveParentFromLocation < ActiveRecord::Migration
  def up
    remove_column :locations, :parent
  end

  def down
    add_column :locations, :parent, :integer
  end
end

class AddDurationUnitToChallenge < ActiveRecord::Migration
  def change
    add_column :challenges, :duration_unit, :string
  end
end

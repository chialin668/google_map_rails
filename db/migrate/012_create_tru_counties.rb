class CreateTruCounties < ActiveRecord::Migration
  def self.up
    create_table :tru_counties do |t|
    end
  end

  def self.down
    drop_table :tru_counties
  end
end

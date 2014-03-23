class CreateIfsCounties < ActiveRecord::Migration
  def self.up
    create_table :ifs_counties do |t|
    end
  end

  def self.down
    drop_table :ifs_counties
  end
end

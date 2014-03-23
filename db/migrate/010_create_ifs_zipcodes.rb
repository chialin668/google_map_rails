class CreateIfsZipcodes < ActiveRecord::Migration
  def self.up
    create_table :ifs_zipcodes do |t|
    end
  end

  def self.down
    drop_table :ifs_zipcodes
  end
end

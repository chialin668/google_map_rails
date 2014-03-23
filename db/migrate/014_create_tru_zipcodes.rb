class CreateTruZipcodes < ActiveRecord::Migration
  def self.up
    create_table :tru_zipcodes do |t|
    end
  end

  def self.down
    drop_table :tru_zipcodes
  end
end

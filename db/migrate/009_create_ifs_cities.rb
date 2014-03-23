class CreateIfsCities < ActiveRecord::Migration
  def self.up
    create_table :ifs_cities do |t|
    end
  end

  def self.down
    drop_table :ifs_cities
  end
end

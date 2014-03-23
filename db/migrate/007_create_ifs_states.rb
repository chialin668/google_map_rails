class CreateIfsStates < ActiveRecord::Migration
  def self.up
    create_table :ifs_states do |t|
    end
  end

  def self.down
    drop_table :ifs_states
  end
end

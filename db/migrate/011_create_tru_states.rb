class CreateTruStates < ActiveRecord::Migration
  def self.up
    create_table :tru_states do |t|
    end
  end

  def self.down
    drop_table :tru_states
  end
end

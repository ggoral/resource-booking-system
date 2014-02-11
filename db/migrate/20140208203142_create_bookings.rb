class CreateBookings < ActiveRecord::Migration
  def self.up
    create_table :bookings do |t|
      t.references :resource
      t.datetime :start
      t.datetime :end
      t.string :status
      t.string :user

      t.timestamps
    end
  end
 
  def self.down
    drop_table :bookings
  end
end

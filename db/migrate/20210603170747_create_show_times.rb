class CreateShowTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :show_times do |t|
      t.integer :price
      t.belongs_to :film, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end

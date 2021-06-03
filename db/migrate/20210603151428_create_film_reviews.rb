class CreateFilmReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :film_reviews do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :film, null: false, foreign_key: true
      t.integer :stars
      t.text :comment

      t.timestamps
    end
  end
end

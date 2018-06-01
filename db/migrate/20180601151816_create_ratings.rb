class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.boolean :like, null: false
      t.references :user, foreign_key: true
      t.references :ratingable, index: false
      t.string :ratingable_type

      t.timestamps
    end
    add_index :ratings, [:ratingable_id, :ratingable_type]
  end
end

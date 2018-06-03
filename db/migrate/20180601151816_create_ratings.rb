class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :rating_count, default: 0
      t.references :ratingable, index: false
      t.string :ratingable_type

      t.timestamps
    end
    add_index :ratings, [:ratingable_id, :ratingable_type]
  end
end

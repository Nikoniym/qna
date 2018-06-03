class CreateRatingUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :rating_users do |t|
      t.references :user, foreign_key: true
      t.references :rating, foreign_key: true
      t.boolean :like, null: false

      t.timestamps
    end
  end
end

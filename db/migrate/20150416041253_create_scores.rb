class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.string :title
      t.string :artist
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end

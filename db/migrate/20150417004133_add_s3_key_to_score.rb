class AddS3KeyToScore < ActiveRecord::Migration
  def change
    add_column :scores, :s3key, :string
  end
end

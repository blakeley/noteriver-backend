class ChangeScoreS3KeyName < ActiveRecord::Migration
  def change
    rename_column :scores, :s3key, :s3_key
  end
end

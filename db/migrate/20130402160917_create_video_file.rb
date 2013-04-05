class CreateVideoFile < ActiveRecord::Migration
  def up
    create_table :video_files do |t|
      t.string :name
      t.string :filename
    end
  end

  def down
    drop_table :video_files
  end
end
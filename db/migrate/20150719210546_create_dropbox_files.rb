class CreateDropboxFiles < ActiveRecord::Migration
  def change
    create_table :dropbox_files do |t|
      t.attachment :document
      t.string :url
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps null: false
    end
  end
end

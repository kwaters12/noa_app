class AddDocusignUrlToNoaApplication < ActiveRecord::Migration
  def change
    add_column :noa_applications, :docusign_url, :string
  end
end

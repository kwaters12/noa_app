class AddPdfPathToClients < ActiveRecord::Migration
  def change
    add_column :clients, :pdf_path, :string
  end
end

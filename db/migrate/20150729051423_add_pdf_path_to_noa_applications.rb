class AddPdfPathToNoaApplications < ActiveRecord::Migration
  def change
    add_column :noa_applications, :pdf_path, :string
  end
end

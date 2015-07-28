# class DropboxFile < ActiveRecord::Base

#   attr_accessible :url , :created_at ,:updated_at, :document
 
#    has_attached_file :document ,
 
#     :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
#     :path => "#{Rails.root}/public/system/:class/:attachment/:id/:style/:basename.:extension",
#     :storage => ((Rails.env.production? || Rails.env.staging?) ? :s3 : :filesystem)
  
# end

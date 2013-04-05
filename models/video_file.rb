class VideoFile < ActiveRecord::Base
  validates :name, :presence => true
  validates :filename, :presence => true
  validates_format_of :filename, :with => /.\.[ogg|mp4]/, :message => "File must be video .ogg or .mp4"
end
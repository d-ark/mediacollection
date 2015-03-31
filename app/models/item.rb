class Item < ActiveRecord::Base
  ALLOWED_MEDIA_TYPES = %w(video image)

  validates :title, :link, :kind, presence: true
  validates :kind, inclusion: {in: ALLOWED_MEDIA_TYPES}
end

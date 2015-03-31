class Item < ActiveRecord::Base
  ALLOWED_MEDIA_TYPES = %w(video image)
  belongs_to :user

  validates :title, :link, :kind, :user, presence: true
  validates :kind, inclusion: {in: ALLOWED_MEDIA_TYPES}
end

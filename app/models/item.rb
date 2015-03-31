class Item < ActiveRecord::Base
  ALLOWED_MEDIA_TYPES = %w(video image)
  belongs_to :user

  validates :title, :link, :kind, :user, presence: true
  validates :kind, inclusion: {in: ALLOWED_MEDIA_TYPES}

  scope :published, -> { where public: true }
  scope :owned_by, -> (user) { where(user_id: user.id) }
  scope :opened_for, -> (user) { where("user_id = ? or public = ?", user.id, true) }

  def can_edit? _user
    _user.id == user_id
  end

  def can_view? _user
    can_edit?(_user) || public
  end

end

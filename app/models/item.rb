class Item < ActiveRecord::Base
  ALLOWED_MEDIA_TYPES = %w(video image)
  belongs_to :user

  validates :title, :link, :kind, :user, presence: true
  validates :kind, inclusion: {in: ALLOWED_MEDIA_TYPES}

  scope :published, -> { where public: true }
  scope :owned_by, -> (_user) { where(user_id: _user.try(:id)) }
  scope :foreign_for, -> (_user) { where.not(user_id: _user.try(:id)) }
  scope :opened_for, -> (_user) { where("user_id = ? or public = ?", _user.try(:id), true) }

  scope :search, -> (q) { where("lower(title) like ? or lower(description) like ?", "%#{q}%", "%#{q}%") }

  def can_edit? _user
    _user.try(:id) == user_id
  end

  def can_view? _user
    can_edit?(_user) || public
  end

end

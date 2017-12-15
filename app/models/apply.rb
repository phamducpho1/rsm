class Apply < ApplicationRecord
  belongs_to :job
  belongs_to :user, optional: true
  has_one :company, through: :job
  validates :cv, presence: true
  validates :information, presence: true
  enum status: {waitting: 0, reviewing: 1, approve: 2, rejected: 3, hired: 4}
  serialize :information, Hash
  enum status: {Not_receive: 0, Received: 1}
  scope :newest_apply, ->{order :created_at}
  mount_uploader :cv, CvUploader

  validates_hash_keys :information do
    validates :name, presence: true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}
    validates :phone, presence: true
    validates :introducing, presence: true
  end

  def of_user? user
    false if user.blank?
    user.id == self.user_id
  end
end

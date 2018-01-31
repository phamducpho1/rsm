class Template < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  validates :title, presence: true
  enum type_of: [:template_member, :template_user]
end

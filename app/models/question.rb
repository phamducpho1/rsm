class Question < ApplicationRecord
  has_many :answers
  belongs_to :job, required: true

  validates :name, presence: true

  accepts_nested_attributes_for :answers, allow_destroy: true
end

class Answer < ApplicationRecord
  belongs_to :apply, required: true
  belongs_to :question, required: true

  validates :name, presence: true, if: Proc.new { |answer|
    answer.question_job.compulsory?
  }

  delegate :job, to: :question, prefix: true, allow_nil: true
end

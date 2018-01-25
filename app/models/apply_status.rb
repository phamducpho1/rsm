class ApplyStatus < ApplicationRecord
  belongs_to :apply
  belongs_to :status_step

  has_one :step, through: :status_step
  has_one :appointment, dependent: :destroy

  delegate :id, to: :appointment, allow_nil: true, prefix: true

  accepts_nested_attributes_for :appointment, allow_destroy: true

  enum is_current: {current: 0, not_current: 1}

  scope :get_by, -> apply_ids do
    where apply_id: apply_ids
  end
end

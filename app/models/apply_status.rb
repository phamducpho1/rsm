class ApplyStatus < ApplicationRecord
  belongs_to :apply
  belongs_to :status_step

  has_one :step, through: :status_step
  has_one :job, through: :apply
  has_one :appointment, dependent: :destroy

  delegate :id, to: :appointment, allow_nil: true, prefix: true
  delegate :name, to: :status_step, allow_nil: true, prefix: true
  delegate :name, to: :step, allow_nil: true, prefix: true
  delegate :id, to: :apply, allow_nil: true, prefix: true

  accepts_nested_attributes_for :appointment, allow_destroy: true

  enum is_current: {current: 0, not_current: 1}

  include PublicActivity::Model

  scope :get_by, -> apply_ids do
    where apply_id: apply_ids
  end
  scope :lastest_apply_status, ->{order created_at: :desc}

  def save_activity key, user
    self.transaction do
      self.create_activity key, owner: user
    end
  end
end

class StatusStep < ApplicationRecord
  belongs_to :step

  scope :load_by, -> code_text do
    where "code LIKE ?", "%#{code_text}%"
  end

  def is_status? code
    self.code.include? code
  end
end

class CompanyStep < ApplicationRecord
  belongs_to :company
  belongs_to :step

  def next_step company
    company_step = company.company_steps.includes(:step).find_by priority: self.priority + 1
    return if company_step.blank?
    company_step.step
  end
end

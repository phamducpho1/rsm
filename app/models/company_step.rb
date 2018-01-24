class CompanyStep < ApplicationRecord
  belongs_to :company
  belongs_to :step

  def load_step company, plus_number
    company_step = company.company_steps.includes(:step).find_by priority: self.priority + plus_number
    return if company_step.blank?
    company_step.step
  end
end

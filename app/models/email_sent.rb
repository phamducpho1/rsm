class EmailSent < ApplicationRecord
  belongs_to :apply_status, class_name: ApplyStatus.name, foreign_key: :type_id, optional: true
  self.inheritance_column = nil
end

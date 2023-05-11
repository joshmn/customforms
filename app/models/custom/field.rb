class Custom::Field < ApplicationRecord
  belongs_to :form, class_name: 'Custom::Form'

  acts_as_list scope: :form_id

  with_options presence: true do
    validates :label
    validates :name
  end

  before_validation on: :create do
    self.name = "field_#{SecureRandom.hex.first(8)}"
  end
end

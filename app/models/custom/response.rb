class Custom::Response < ApplicationRecord
  belongs_to :form, class_name: 'Custom::Form', foreign_key: :custom_form_id
  has_many :response_fields, class_name: 'Custom::ResponseField', foreign_key: :custom_response_id
end

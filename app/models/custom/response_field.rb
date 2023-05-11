class Custom::ResponseField < ApplicationRecord
  belongs_to :form, class_name: 'Custom::Form', foreign_key: :custom_form_id
  belongs_to :field, class_name: 'Custom::Field', foreign_key: :custom_field_id
  belongs_to :response, class_name: 'Custom::Response', foreign_key: :custom_response_id
end

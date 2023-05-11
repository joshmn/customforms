class Custom::Form < ApplicationRecord
  has_many :fields, -> { order(position: :asc) }, class_name: '::Custom::Field'
  has_many :responses, class_name: '::Custom::Response', foreign_key: :custom_form_id
end

module CustomForms
  module Responses
    class CreateCommand < Rectify::Command
      def initialize(form)
        @form = form
      end

      def call
        return broadcast(:invalid, @form) unless @form.valid?

        transaction do
          @response = Custom::Response.new(uuid: SecureRandom.hex, form: @form.context.custom_form)
          @response.save!
          @form.attributes.each do |attr, value|
            field = @form.class.field_map[attr]
            response_field = @response.response_fields.new(custom_form_id: @response.form.id, custom_field_id: field.id)
            response_field.value = value
            response_field.save!
          end
        end


        broadcast(:ok, @response)
      end
    end
  end
end

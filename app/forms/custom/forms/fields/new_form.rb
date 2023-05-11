module Custom
  module Forms
    module Fields
      class NewForm < ::Form
        acts_like_model :field

        attribute :type
        attribute :label
        attribute :required, :boolean
        attribute :options, array: true, default: []
        attribute :collection, array: true, default: {}

        with_options presence: true do
          validates :type
          validates :label
        end

        validate :check_options!
        def type_options
          [Custom::StringField, Custom::BooleanField, Custom::SelectField].map.with_object({}) do |type, obj|
            obj[type.model_name.human] = type.name
          end
        end

        private

        def check_options!
          if type == 'Custom::SelectField'
            unsafe = collection.values.map(&:to_unsafe_h)
            self.collection = unsafe

            if collection.size == 0
              self.errors.add(:collection, "you need to have options for this select")
            else
              if unsafe.map { |item| item[:key] }.all?(&:present?) && unsafe.map { |item| item[:value] }.all?(&:present?)
                # yay
              else
                self.errors.add(:collection, "you need at least one of each label and value")
              end
            end
          end
        end

      end
    end
  end
end

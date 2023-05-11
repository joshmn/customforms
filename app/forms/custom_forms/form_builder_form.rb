module CustomForms
  class FormBuilderForm < Form
    acts_like_model :response
    class_attribute :field_map, default: {}
    def self.build(custom_form)
      klass = Class.new(FormBuilderForm)

      custom_form.fields.each do |field|
        klass.add_field(field)
      end

      klass.new.tap do |instance|
        instance.with_context(custom_form: custom_form)
      end
    end

    def self.add_field(field)
      type = field.class.name.demodulize.underscore
      public_send("add_#{type}", field)
      field_map[field.name] = field
    end

    def self.add_string_field(field)
      attribute field.name, :string

      if field.required?
        validates field.name, presence: { message: "must be present" }
      end
    end

    def self.add_boolean_field(field)
      attribute field.name, :boolean

      if field.required?
        validates field.name, presence: true
      end
    end

    def self.add_select_field(field)
      attribute field.name, :string

      if field.required?
        validates field.name, presence: true, inclusion: { in: "#{field.name}_valid_values".to_sym }
      end

      define_method "#{field.name}_options" do
        field.options['collection'].collect { |option| [option['key'], option['value']]}
      end

      define_method "#{field.name}_valid_values" do
        public_send("#{field.name}_options").map(&:second)
      end

    end
  end
end

module CustomFormsHelper
  def build_field(attr, form)
    field = form.object.class.field_map[attr]
    build_custom_field(field, form)
  end

  def build_custom_field(field, form)
    type = field.type
    name = type.demodulize.underscore
    public_send("build_#{name}", field, form)
  end

  def build_string_field(field, form)
    form.input field.name, as: :string, placeholder: field.options['placeholder'], label: field.label, error: "#{form.object.errors[field.name].first}"
  end

  def build_boolean_field(field, form)
    form.input field.name, as: :boolean, include_blank: field.options['include_blank']
  end

  def build_select_field(field, form)
    form.input field.name, as: :select, label: field.label, include_blank: field.options['placeholder'], collection: form.object.public_send("#{field.name}_options"), error: "#{form.object.errors[field.name].first}"
  end
end

module Custom
  class ResponseDecorator < Draper::Decorator
    def attributes
      map = {}
      object.response_fields.each do |rfield|
        label = rfield.field.label
        value = rfield.value
        map[label] = value
      end

      map
    end
  end
end

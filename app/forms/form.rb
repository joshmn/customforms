# frozen_string_literal: true

class Form
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment
  include ActiveModel::AttributeMethods

  attribute :id, :integer

  class_attribute :model
  class_attribute :model_name
  class_attribute :copy_attributes, default: false
  class_attribute :default_ignored_attributes, default: %w[id created_at updated_at]
  class_attribute :ignored_attributes, default: []

  def self.inherit_model_validations(model, *attributes)
    attributes.each do |attr|
      model._validators[attr].each do |validator|
        if validator.options.none?
          validates attr, validator.kind => true
        else
          validates attr, validator.kind => validator.options
        end
      end
    end
  end

  def self.from_params(params, additional_params = {})
    attributes_hash = params.merge(additional_params)

    instance = new
    attributes_hash.each do |k, v|
      instance.public_send("#{k}=", v) if instance.attributes.key?(k.to_s)
    end
    instance
  end

  def self.acts_like_model(model)
    self.model = model

    return unless copy_attributes?

    model.columns_hash.each do |key, value|
      next if ignored_attributes.include?(key)
      next if default_ignored_attributes.include?(key)

      if value.type == :text
        attribute key.to_sym, :string
      else
        attribute key.to_sym, value.type
      end
      alias_method "#{key.to_sym}?", key.to_sym if value.type == :boolean
    end

    model._validators.each do |attribute_name, validators|
      next if model._reflect_on_association(attribute_name)

      validators.each do |validator|
        validates attribute_name, validator.kind => validator.options
      end
    end
  end

  def self.from_model(record)
    instance = new
    record.attributes.each do |k, v|
      instance.public_send("#{k}=", v) if instance.attributes.key?(k)
    end
    instance.id = record.id
    instance
  end

  def with_context(contexts = {})
    @context = OpenStruct.new(contexts)
    self
  end

  attr_reader :context

  def persisted?
    id.present? && id.to_i.positive?
  end

  def attributes
    super.except('id')
  end

  def valid?(options = {})
    options     = {} if options.blank?
    context     = options[:context]
    validations = [super(context)]

    validations.all?
  end

  def invalid?(options = {})
    !valid?(options)
  end

  def to_key
    [id]
  end

  def self.model_name
    if model.is_a?(Symbol)
      ActiveModel::Name.new(self, nil, model.to_s)
    elsif model.present?
      ActiveModel::Name.new(self, nil, model.model_name.name.split('::').last)
    else
      ActiveModel::Name.new(self, nil, name.split('::').last)
    end
  end

  def model_name
    self.class.model_name
  end

  def type_for_attribute(attr)
    self.class.attribute_types[attr].type
  end

  def column_for_attribute(attr)
    model.column_for_attribute(attr)
  end

  def has_attribute?(attr_name)
    attr_name = attr_name.to_s
    attr_name = self.class.attribute_aliases[attr_name] || attr_name
    @attributes.key?(attr_name)
  end
end

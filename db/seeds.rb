form = Custom::Form.create!(name: "Welcome form")
Custom::Field.create!(type: "Custom::StringField", label: "Name (required)", required: true, form: form)
Custom::Field.create!(type: "Custom::SelectField", label: "Fav color?", options: {"collection"=>[{"key"=>"Sapphire Blue Metallic", "value"=>"blue"}, {"key"=>"Ferrari Red", "value"=>"red"}] }, form: form)

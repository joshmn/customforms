module CustomForms
  class FieldsController < BaseController
    def create
      @field_form = ::Custom::Forms::Fields::NewForm.from_params(field_params)
      if @field_form.valid?
        options = @field_form.options.to_unsafe_h.deep_symbolize_keys

        if @field_form.collection
          options[:collection] = @field_form.collection
        end

        @custom_form.fields.create!(label: field_params[:label], type: field_params[:type], required: field_params[:required], options: options)
        respond_to do |f|
          f.html do
            redirect_to custom_form_path(current_loc, @custom_form), notice: "Nice"
          end
          f.turbo_stream do
            render turbo_stream: [
              turbo_stream.update(:new_field, partial: 'form', locals: { field_form: ::Custom::Forms::Fields::NewForm.new, custom_form: @custom_form }),
              turbo_stream.update(:fields, partial: 'custom_forms/fields', locals: { custom_form: @custom_form })
            ]
          end
        end
      else
        respond_to do |f|
          f.html do
            redirect_to custom_form_path(@custom_form), notice: "Error", status: :see_other
          end
          f.turbo_stream do
            flash.now[:notice] = "Error"
            render turbo_stream: turbo_stream.update(:new_field, partial: 'form', locals: { field_form: @field_form, custom_form: @custom_form }), status: :bad_request

          end
        end
      end
    end

    def update
      @field = @custom_form.fields.find(params[:id])
      @field.update!(position: field_params[:position])
      respond_to do |f|
        f.html do
          redirect_to custom_form_path(@custom_form), notice: "Nice"
        end
        f.turbo_stream do
          render turbo_stream: turbo_stream.update(:fields, partial: 'custom_forms/fields', locals: { custom_form: @custom_form })
        end
      end
    end

    def destroy
      @field = @custom_form.fields.find(params[:id])
      @field.destroy!

      respond_to do |f|
        f.html do
          redirect_to custom_form_path(@custom_form), notice: "Nice"
        end
        f.turbo_stream do
          render turbo_stream: turbo_stream.update(:fields, partial: 'custom_forms/fields', locals: { custom_form: @custom_form })
        end
      end
    end

    private

    def field_params
      params.require(:field).permit(:label, :required, :type, :position, options: [:placeholder, :include_blank], collection: {})
    end
  end
end

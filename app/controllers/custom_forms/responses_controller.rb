module CustomForms
  class ResponsesController < BaseController
    def new
      @builder = ::CustomForms::FormBuilderForm.build(@custom_form)
      @response = ::Custom::Response.new
    end

    def create
      @builder = ::CustomForms::FormBuilderForm.build(@custom_form)
      @builder.assign_attributes(repsonse_params)
      ::CustomForms::Responses::CreateCommand.call(@builder) do
        on(:ok) do |response|
          redirect_to custom_form_response_path(response.form, response)
        end
        on(:invalid) do |form|
          expose(builder: form)
          expose(custom_form: form.context.custom_form)
          render :new, status: :bad_request
        end
      end
    end

    def show
      response = @custom_form.responses.find(params[:id])
      @response = ::Custom::ResponseDecorator.decorate(response)
    end

    private
    def repsonse_params
      params.require(:response).permit!
    end
  end
end

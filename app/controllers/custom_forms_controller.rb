class CustomFormsController < ApplicationController
  def index
    @custom_forms = Custom::Form.all
  end

  def new
    @custom_form = Custom::Form.new
  end

  def create
    @custom_form = Custom::Form.new(custom_form_params)
    @custom_form.save!
    redirect_to custom_form_path(@custom_form)
  end

  def show
    @custom_form = Custom::Form.find(params[:id])
    @field_form = ::Custom::Forms::Fields::NewForm.new
    @field_form.type = params[:type].presence
  end

  private

  def custom_form_params
    params.require(:custom_form).permit(:name)
  end
end

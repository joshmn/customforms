module CustomForms
  class BaseController < ApplicationController
    before_action :find_custom_form!

    private

    def find_custom_form!
      @custom_form = Custom::Form.find(params[:custom_form_id])
    end
  end
end

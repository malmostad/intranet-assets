class TestPagesController < ApplicationController
  def index
    template_name = params[:name].present? ? params[:name] : "index"
    render template: "test_pages/#{template_name}"
  end
end

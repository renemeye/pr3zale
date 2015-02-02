class ValidationController < ApplicationController
  authorize_resource :class => Event

  def index
  end
end

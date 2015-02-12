class CooperatorsController < ApplicationController
  before_action :set_cooperator, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @cooperators = Cooperator.all
    respond_with(@cooperators)
  end

  def show
    respond_with(@cooperator)
  end

  def new
    @cooperator = Cooperator.new
    respond_with(@cooperator)
  end

  def edit
  end

  def create
    @cooperator = Cooperator.new(cooperator_params)
    @cooperator.save
    respond_with(@cooperator)
  end

  def update
    @cooperator.update(cooperator_params)
    respond_with(@cooperator)
  end

  def destroy
    @cooperator.destroy
    respond_with(@cooperator)
  end

  private
    def set_cooperator
      @cooperator = Cooperator.find(params[:id])
    end

    def cooperator_params
      params.require(:cooperator).permit(:user_id, :event_id, :nickname, :role)
    end
end

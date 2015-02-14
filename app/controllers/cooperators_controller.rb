class CooperatorsController < ApplicationController
  load_and_authorize_resource :event
  load_and_authorize_resource :through => :event

  respond_to :html

  def index
    authorize! :mange, @event
    @cooperators = Cooperator.all
    respond_with(@cooperators)
  end

  def show
    respond_with(@cooperator)
  end

  def new
    @cooperator = Cooperator.new
    @possible_users = @event.users.uniq - @event.cooperators
    @possible_roles = Cooperator.ROLES
    @cooperator.event = @event
    respond_with(@cooperator)
  end

  def edit
  end

  def create
    @cooperator = Cooperator.new(cooperator_params)
    @cooperator.event = @event
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
    # def set_cooperator
    #   @cooperator = Cooperator.find(params[:id])
    # end

    def cooperator_params
      params.require(:cooperator).permit(:user_id, :event_id, :nickname, :role)
    end
end

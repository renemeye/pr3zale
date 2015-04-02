class CooperatorsController < ApplicationController

  skip_before_filter :check_for_new_cooperators, :only => [:edit_phishing_data, :update_phishing_data]

  skip_authorization_check
  before_filter :set_cooperator, only: [:show, :edit, :update, :destroy, :edit_phishing_data, :update_phishing_data]

  respond_to :html

  def index
    authorize! :mange, @event
    @cooperators = @event.cooperators.all
    respond_with(@cooperators)
  end

  def show
    authorize! :mange, @event
    respond_with(@cooperator)
  end

  def new
    authorize! :mange, @event
    @cooperator = Cooperator.new
    @possible_users = @event.users.uniq - @event.cooperators
    @possible_roles = Cooperator.ROLES
    @cooperator.event = @event
    respond_with(@cooperator)
  end

  def edit
    authorize! :mange, @event
    @possible_roles = Cooperator.ROLES
    @possible_users = [@cooperator.user]
  end

  def edit_phishing_data
    authorize! :edit_phishing_data, @cooperator
  end

  def update_phishing_data
    authorize! :edit_phishing_data, @cooperator
    @cooperator.update(nickname: cooperator_params[:nickname], anti_phishing_secret: cooperator_params[:anti_phishing_secret])

    redirect_to(root_path)
  end

  def create
    authorize! :mange, @event
    @cooperator = Cooperator.new(cooperator_params)
    @cooperator.event = @event
    @cooperator.save
    respond_with(@cooperator)
  end

  def update
    authorize! :mange, @event
    @cooperator.update(cooperator_params)
    respond_with(@cooperator)
  end

  def destroy
    authorize! :mange, @event
    @cooperator.destroy
    respond_with(@cooperator)
  end

  private
    def set_cooperator
      @cooperator = Cooperator.find(params[:id])
    end

    def cooperator_params
      params.require(:cooperator).permit(:user_id, :event_id, :nickname, :role, :anti_phishing_secret)
    end
end

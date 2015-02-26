class EventsController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  def index
    @events = Event.all
    respond_with(@events)
  end

  def show
    respond_with(@event)
  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.save
    respond_with(@event)
  end

  def update
    @event.update(event_params)
    respond_with(@event)
  end

  def destroy
    @event.destroy
    respond_with(@event)
  end

  private

    def event_params
      params.require(:event).permit(:name, :short_description, :description, :owner_id, :payment_receiver, :payment_iban, :payment_bic, :pay_until, :company_name, :company_address)
    end
end

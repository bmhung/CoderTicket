class TicketsController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
  end

  def create
    @event = Event.find(params[:event_id])
    @ticket = TicketType.new(ticket_type_params)
    @ticket.event_id = @event.id

    if @ticket.save
      redirect_to edit_event_path(id: params[:event_id]), notice: "Ticket added!"
    else
      redirect_to edit_event_path(id: params[:event_id]), notice: "Ticket failed to add!"
    end
  end

  def ticket_type_params
		params.required(:TicketType).permit(:price, :name, :max_quantity)
	end

  def destroy
    @ticket = TicketType.find(params[:id])
    @ticket.destroy
    redirect_to edit_event_path(id: params[:event_id]), notice: "Ticket removed!"
  end
end

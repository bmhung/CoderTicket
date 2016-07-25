class TicketsController < ApplicationController
  def new
    @event = Event.find(params[:event_id])
    if @event.ends_at < DateTime.current
      flash[:error] = "This event has passed."
      redirect_to events_path
    end
  end

  def create
    @event = Event.find(params[:event_id])
    @ticket = TicketType.new(ticket_type_params)
    @ticket.event_id = @event.id
    @ticket.available_quantity = params[:TicketType][:max_quantity]
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

  def buy
    @event = Event.find(params[:event_id])
    params[:ticket].each do |key, value|
      ticket = TicketType.find(key)
      if ticket.available_quantity < value.to_i
        flash[:notice] = "Not enough ticket."
        redirect_to new_event_ticket_path(@event.id)
        return
      end
    end
    params[:ticket].each do |key, value|
      ticket = TicketType.find(key)
      if ticket.available_quantity >= value.to_i
        ticket.available_quantity -= value.to_i
        ticket.save
      end
    end   
    flash[:success] = "Ticket bought." 
    redirect_to new_event_ticket_path(@event.id)
  end
end

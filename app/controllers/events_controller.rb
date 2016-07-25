class EventsController < ApplicationController
  def index
    @events = Event.where("ends_at >= :today", {today: DateTime.current})    
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    @categories = Category.all
    @venues = Venue.all
  end

  def create
    @event = Event.new(event_params)
    @categories = Category.all
    @venues = Venue.all
    if @event.save
      redirect_to events_path
    else
      render "new"
    end
  end

  def event_params
		params.required(:event).permit(:user_id, :name, :extended_html_description, :starts_at, :ends_at, :hero_image_url, :category_id, :venue_id)
	end

  def edit
    @event = Event.find(params[:id])
    @categories = Category.all
    @venues = Venue.all
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      redirect_to event_path(id: params[:id]), notice: "Event edited!"
    else
      render "edit"
    end
  end

  def publish
    @event = Event.find(params[:id])
    unless @event.ticket_types.count > 0
      @event.publish_at = DateTime.current
      @event.save    
      redirect_to root_path
    end
  end

  def mine
    @events = Event.where(user_id: current_user.id)
  end

  def find
    @events = Event.where("name LIKE :search_term", { search_term: "%"+params[:search_term]+"%" })
    render "index"
  end

end

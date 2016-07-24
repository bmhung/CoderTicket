class VenuesController < ApplicationController
  def new
    @venue = Venue.new
    @regions = Region.all
  end

  def create
    @venue = Venue.new(venue_params)
    @venue.save
    redirect_to new_event_path
  end

  def venue_params
		params.required(:venue).permit(:name, :full_address, :region_id)
	end
  
end

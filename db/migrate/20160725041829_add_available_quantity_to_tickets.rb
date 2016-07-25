class AddAvailableQuantityToTickets < ActiveRecord::Migration
  def change
    add_column :ticket_types, :available_quantity, :integer
  end
end

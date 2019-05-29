class ShoppingCartsController < ApplicationController
  def add_ticket

    if session[:shopping_cart] == nil
      session[:shopping_cart] ||= []
    end


    begin
      ticket_type = TicketType.find(shopping_cart_params[:ticket_type_id])
    rescue
      logger.debug("[ShoppingCartsController::add_ticket] no ticket found!")
      redirect_back fallback_location: root_path, flash: { error: "Invalid event or ticket type!" } and return
    end

    shopping_cart_params[:amount].to_i.times {
      session[:shopping_cart] << shopping_cart_params[:ticket_type_id]
    }

    redirect_back fallback_location: root_path, flash: { notice: "Ticket added to shopping cart!" } and return

    #render plain: "success! " + session[:shopping_cart].inspect
  end

  def remove_ticket(id)
    tickets = shopping_cart_get_tickets()
    ticket = tickets.where(tickets.id == id)
    session[:shopping_cart].delete(ticket)
    redirect_back fallback_location: root_path, flash: { notice: "Ticket removed from shopping cart!" } and return

  end

  def index
    # Not much to do here...
  end

  private

  def shopping_cart_params
    params.permit(:utf8, :_method, :authenticity_token, :commit, :id, :ticket_type_id, :amount)
  end

end

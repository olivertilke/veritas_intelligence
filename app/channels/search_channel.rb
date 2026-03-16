class SearchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "search_#{current_user&.id || 'guest'}"
  end

  def unsubscribed
    stop_all_streams
  end
end

module Formatter

  def format_time(time, breaker=false)
    time.strftime("%b %d, %Y#{breaker ? "<br>" : ", "}%I:%M %p")
  end

end

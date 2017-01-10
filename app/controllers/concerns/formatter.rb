module Formatter

  def format_time(time, breaker=false)
    time.strftime("%A, %b %d#{breaker ? "<br>" : " "}%I:%M %p")
  end
  
end

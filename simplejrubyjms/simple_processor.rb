require 'processor.rb'

class SimpleProcessor < Processor
  subscribes_to "SIMPLE.TOPIC"

  def on_message message
    puts message
  end
end


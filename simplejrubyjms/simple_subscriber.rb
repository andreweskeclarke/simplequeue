require 'message_handler'
require 'simple_processor'

# include each processor, for now just act like we've found all the processors.
processors = []
processors << SimpleProcessor.new
processors.each do |processor|
  handler = MessageHandler.new processor
  handler.run
end

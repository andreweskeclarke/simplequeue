require "java"
require "~/Programming/apache-activemq-5.5.1/activemq-all-5.5.1.jar"
require "~/Programming/apache-activemq-5.5.1/lib/optional/log4j-1.2.14.jar"
require "~/Programming/apache-activemq-5.5.1/lib/optional/slf4j-log4j12-1.5.11.jar"

include_class "org.apache.activemq.ActiveMQConnectionFactory"
include_class "org.apache.activemq.util.ByteSequence"
include_class "org.apache.activemq.command.ActiveMQBytesMessage"
include_class "javax.jms.MessageListener"
include_class "javax.jms.Session"

class MessageHandler
  include javax.jms.Session
  include javax.jms.MessageListener

  def onMessage(serialized_message)
    message_body = serialized_message.get_content.get_data.inject("") { |body, byte| body << byte }
    @processor.on_message message_body
    if message_body =~ /throw/
      raise Exception.new "Throwing from onMessage"
    end
  end

  def initialize(processor)
    @processor = processor
    factory = ActiveMQConnectionFactory.new("tcp://localhost:61616")
    @connection = factory.create_connection();
    @connection.set_client_id("JRUBY");
    session = @connection.create_session(false, Session::AUTO_ACKNOWLEDGE);
    topic = session.create_topic(@processor.topic);

    subscriber = session.create_durable_subscriber(topic, "JRUBY");
    subscriber.set_message_listener(self);

  end

  def run
    @connection.start();
    puts "Listening..."
  end
end


class ApplicationProcessor
  @@topic_map = {}
  class<<self
    def subscribes_to destination_name
      @@topic_map[self.name] = destination_name
    end
  end

  def topic
    @@topic_map[self.class.name]
  end
end

class SimpleProcessor < ApplicationProcessor
  subscribes_to "SIMPLE.TOPIC"

  def on_message message
    puts message
  end
end

# include each processor
processors = []
processors << SimpleProcessor.new
processors.each do |processor|
  handler = MessageHandler.new processor
  handler.run
end

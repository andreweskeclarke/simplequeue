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
    puts message_body
    if message_body =~ /throw/
      raise Exception.new "Throwing from onMessage"
    end
  end

  def run
    factory = ActiveMQConnectionFactory.new("tcp://localhost:61616")
    connection = factory.create_connection();
    connection.set_client_id("JRUBY");
    session = connection.create_session(false, Session::AUTO_ACKNOWLEDGE);
    topic = session.create_topic("SIMPLE.TOPIC");

    subscriber = session.create_durable_subscriber(topic, "JRUBY");
    subscriber.set_message_listener(self);

    connection.start();
    puts "Listening..."
  end
end

handler = MessageHandler.new
handler.run

#
# class ApplicationProcessor
#  def on_error(err)
#    if(err.kind_of? StandardError)
#      this is normal stuff.
#    else
#    end
#  end
# end
#
# class EventsProcessor < ApplicationProcessor
#
#   subscribes_to :events
#   def on_message(message)
#     ...do stuff....
#   end
# end
#

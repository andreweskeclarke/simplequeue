require "java"
require "~/Programming/apache-activemq-5.5.1/activemq-all-5.5.1.jar"
require "~/Programming/apache-activemq-5.5.1/lib/optional/log4j-1.2.14.jar"
require "~/Programming/apache-activemq-5.5.1/lib/optional/slf4j-log4j12-1.5.11.jar"

java_import "org.apache.activemq.ActiveMQConnectionFactory"
java_import "org.apache.activemq.util.ByteSequence"
java_import "org.apache.activemq.command.ActiveMQBytesMessage"
java_import "javax.jms.MessageListener"
java_import "javax.jms.Session"

class MessageHandler
  include javax.jms.Session
  include javax.jms.MessageListener

  def onMessage(serialized_message)
    message_body = serialized_message.get_content.get_data.inject("") { |body, byte| body << byte }
    @processor.on_message message_body
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

require 'rubygems'
require 'jms'

config = {
  :factory => 'org.apache.activemq.ActiveMQConnectionFactory',
  :broker_url => 'tcp://localhost:61616',
  :require_jars => [
    "~/Programming/apache-activemq-5.5.1/activemq-all-5.5.1.jar",
    "~/Programming/apache-activemq-5.5.1/lib/optional/log4j-1.2.14.jar",
    "~/Programming/apache-activemq-5.5.1/lib/optional/slf4j-log4j12-1.5.11.jar"
  ]
}

connection = JMS::Connection.new(config)

connection.on_message(:topic_name => 'SIMPLE.TOPIC', :options => JMS::Session::AUTO_ACKNOWLEDGE) do |message|
  begin
    p message
  rescue
    return false
  end
  true
end


while true do
end

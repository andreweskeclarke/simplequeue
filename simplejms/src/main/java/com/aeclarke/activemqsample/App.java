package com.aeclarke.activemqsample;

import org.apache.activemq.ActiveMQConnection;
import org.apache.activemq.ActiveMQConnectionFactory;

import javax.jms.*;
import java.util.Calendar;
import java.util.Date;

public class App 
{

    public static final String BROKER_URL = ActiveMQConnection.DEFAULT_BROKER_URL;
    public static final String TOPIC_NAME = "SIMPLE.TOPIC";
    public static final String SUBSCRIBER_NAME = "SimpleJMS";

    public static void main( String[] args )
    {
        System.out.println("Starting...");
        try {
            ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory(BROKER_URL);
            TopicConnection connection = connectionFactory.createTopicConnection();
            connection.setClientID(getClientId());
            TopicSession session = connection.createTopicSession(false, Session.AUTO_ACKNOWLEDGE);
            Topic topic =  session.createTopic(TOPIC_NAME);
            TopicSubscriber subscriber = session.createDurableSubscriber(topic, SUBSCRIBER_NAME);
            subscriber.setMessageListener(new SimpleMessageListener());
            connection.start();
        } catch (JMSException e) {
            System.out.println("Failed!");
            e.printStackTrace();
            return;
        }
        System.out.println("Started listening!");
    }

    private static String getClientId() {
        return "com.aeclarke.activemqsample" + Calendar.getInstance().getTimeInMillis();
    }

    private static class SimpleMessageListener implements MessageListener {
        @Override
        public void onMessage(Message message) {
            try {
                String text = ((TextMessage) message).getText();
                System.out.println(text);
            } catch (JMSException e) {
                e.printStackTrace();
            }
        }
    }
}

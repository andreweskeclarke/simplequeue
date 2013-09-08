package com.aeclarke.activemqsample;

import org.apache.activemq.ActiveMQConnectionFactory;

import javax.jms.*;

/**
 * Hello world!
 *
 */
public class App 
{
    public static void main( String[] args )
    {
        System.out.println("Starting...");
        ActiveMQConnectionFactory connectionFactory = new ActiveMQConnectionFactory("http://localhost");
        try {
            Connection connection = connectionFactory.createConnection();
            Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            session.setMessageListener(new SimpleMessageListener());
        } catch (JMSException e) {
            e.printStackTrace();
        }
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

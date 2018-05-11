package CarVisual.handler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.AbstractWebSocketHandler;


public class CarWebSocketHandler extends AbstractWebSocketHandler {

	private static final Log logger = LogFactory.getLog(CarWebSocketHandler.class);
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		logger.info("websocket established");
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		logger.info("Recieved message:"+message.getPayload());
		Thread.sleep(2000);
		session.sendMessage(new TextMessage("hello"));
	}

}



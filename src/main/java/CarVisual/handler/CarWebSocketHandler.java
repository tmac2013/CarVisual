package CarVisual.handler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.AbstractWebSocketHandler;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class CarWebSocketHandler extends AbstractWebSocketHandler {

	private static final Log logger = LogFactory.getLog(CarWebSocketHandler.class);
	private static final ArrayList<WebSocketSession> carsession = new ArrayList< WebSocketSession>();
	private static final String CLIENT_ID = "userId";
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		logger.info("websocket established");
		carsession.add(session);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		logger.info("Recieved message:"+message.getPayload());
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
		logger.info("websocket connection closed");
		carsession.remove(session);
	}
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		carsession.remove(session);
	}

	public void SendMessageToCar(String command) throws Exception{
		carsession.get(0).sendMessage(new TextMessage(command));
	}

}



package CarVisual.handler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.AbstractWebSocketHandler;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;


public class CarWebSocketHandler extends AbstractWebSocketHandler {

	private static final Log logger = LogFactory.getLog(CarWebSocketHandler.class);
	private static final ArrayList<WebSocketSession> carsession = new ArrayList< WebSocketSession>();
	private static String location_send = "";
	private static String location_recieve= "";
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		logger.info("websocket established");
		carsession.add(session);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		location_recieve = message.getPayload();
		logger.info(location_recieve);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
		logger.info("websocket connection closed");
		carsession.remove(session);
	}
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		logger.info("error!");
		carsession.remove(session);
	}

	public void SendMessageToCar(String command) throws Exception{
		carsession.get(0).sendMessage(new TextMessage(command));
		location_send = command;
		logger.info(location_send);
	}
	public void CheckRecieve() throws  Exception{
        logger.info(location_send+" "+location_recieve);
        if(!location_send.equals(location_recieve)){
            carsession.get(0).close();
        }
	}
	public String CheckConnect(){
		if(carsession.isEmpty()){
			return "Disconnecting";
		}
		else {
			return "Connecting";
		}
	}

}



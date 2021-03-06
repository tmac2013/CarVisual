package CarVisual.controller;

import CarVisual.handler.CarWebSocketHandler;
import CarVisual.bean.CarLocation;
import net.sf.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.concurrent.TimeUnit;

@Controller
public class CarVisualController {
	private static final Log logger = LogFactory.getLog(CarVisualController.class);
	private CarLocation carLocation = new CarLocation("","","");
	@Bean
	public CarWebSocketHandler infoHandler() {
		return new CarWebSocketHandler();
	}
	@RequestMapping(value = "/welcome",method = RequestMethod.POST)
	@ResponseBody
	public JSONObject pageShow(){
		//logger.info("PageShowController used!");
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("longitude",carLocation.getLongitude());
		jsonObject.put("latitude",carLocation.getLatitude());

		jsonObject.put("connect",infoHandler().CheckConnect());
        //logger.info(infoHandler().CheckConnect());
		return jsonObject;
	}
	@RequestMapping(value="/car",method = RequestMethod.POST)
	public ModelAndView carvisual(@RequestParam("longitude") String longitude, @RequestParam("latitude") String latitude){
		logger.info("CarVisualController used!");
		logger.info(longitude+" "+latitude);
		carLocation.setLongitude(longitude);
		carLocation.setLatitude(latitude);
		ModelAndView model = new ModelAndView("welcome");
		model.addObject("carlocation",carLocation);
		return model;
	}


	@RequestMapping("/websocket/destination")
	@ResponseBody
	public void sendLocation(@RequestParam("longitude") String longitude,@RequestParam("latitude") String latitude) throws Exception {
		infoHandler().SendMessageToCar(longitude+","+latitude);
		logger.info("longitude:"+longitude+" latitude:"+latitude);
	}

	@RequestMapping("/websocket/check")
	@ResponseBody
	public void checkRecv() throws Exception{
		logger.info("CheckRecv!");
		infoHandler().CheckRecieve();
	}

}

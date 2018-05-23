package CarVisual.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class PageController {
	private static final Log logger = LogFactory.getLog(PageController.class);
	@RequestMapping(value = "/welcome",method = RequestMethod.GET)
	public String pageShow1(){
		logger.info("PageController1 used!");
		return "welcome";
	}
	@RequestMapping(value = "/robot",method = RequestMethod.GET)
	public String pageShow2(){
		logger.info("PageController2 used!");
		return "robot";
	}
}

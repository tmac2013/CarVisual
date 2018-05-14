package CarVisual.controller;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class PageController {
	private static final Log logger = LogFactory.getLog(PageController.class);
	@RequestMapping(value = "/welcome")
	public String pageShow(){
		logger.info("PageController used!");
		return "welcome";
	}
}

package game.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import game.model.domain.Sales;
import game.model.service.PayService;

@Controller
public class SalesController {
	@Autowired
	private PayService payService;
	
	@RequestMapping(value = "/client/sales/regist", method = RequestMethod.POST)
	public ModelAndView registSales(Sales sales) {
		ModelAndView mav = new ModelAndView("client/main/index");
		payService.insert(sales);
		return mav;
	}
}

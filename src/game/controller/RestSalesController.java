package game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import game.model.domain.Sales;
import game.model.domain.Sales_Detail;
import game.model.service.GameService;
import game.model.service.PayService;

@RestController
public class RestSalesController {
	@Autowired
	private PayService payService;
	@Autowired
	private GameService gameService;

	@RequestMapping(value = "/rest/admin/salesGames", method = RequestMethod.GET)
	public List selectSalesDetailGame(@RequestParam("game_id") int game_id) {
		return payService.selectGame(game_id);
	}

	@RequestMapping(value = "/rest/admin/totalSales", method = RequestMethod.GET)
	public int getTotalSales() {
		return payService.getTotal();
	}

	@RequestMapping(value = "/rest/admin/sales")
	public List<Sales> getSales(@RequestParam("order_date") String order_date) {
		return payService.selectAllByOrderDate(order_date);
	}

	@RequestMapping(value = "/rest/admin/sales/detail")
	public List<Sales_Detail> getTopSales() {
		return payService.selectTopGames();
	}

	@RequestMapping(value = "/rest/admin/sales/countGame")
	public int getCount(@RequestParam("game_id") int game_id) {
		return gameService.countGame(game_id);
	}

	@RequestMapping(value = "/rest/admin/sales/data")
	public List<Sales> getData() {
		return payService.selectAllSales();
	}
}

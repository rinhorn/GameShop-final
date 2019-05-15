package game.model.service;

import java.util.List;

import game.model.domain.Sales;
import game.model.domain.Sales_Detail;

public interface PayService {
	public void insert(Sales sales);
	public List<Sales> selectSales_Detail(int member_id);
	public List<Sales> selectAllSales();
	public List<Sales_Detail> selectTopGames();
	public List<Sales> selectAllByOrderDate(String order_date);
	public List<Sales_Detail> selectGame(int game_id);
	public int getTotal();
}

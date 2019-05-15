package game.model.domain;

public class Sales_Detail {
	private int sales_detail_id;
	private int sales_rate;
	private Game game;
	private Sales sales;
	
	public int getSales_detail_id() {
		return sales_detail_id;
	}
	public void setSales_detail_id(int sales_detail_id) {
		this.sales_detail_id = sales_detail_id;
	}
	public int getSales_rate() {
		return sales_rate;
	}
	public void setSales_rate(int sales_rate) {
		this.sales_rate = sales_rate;
	}
	public Game getGame() {
		return game;
	}
	public void setGame(Game game) {
		this.game = game;
	}
	public Sales getSales() {
		return sales;
	}
	public void setSales(Sales sales) {
		this.sales = sales;
	}
}

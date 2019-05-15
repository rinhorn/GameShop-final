package game.model.domain;

import java.util.List;

public class Sales {
	private int sales_id;
	private String order_date;
	private int member_id;
	private Member member;
	private int[] game_id;
	// collection을 위한 자식 객체 List 보유
	private List<Sales_Detail> detailList;
	public int getSales_id() {
		return sales_id;
	}
	public void setSales_id(int sales_id) {
		this.sales_id = sales_id;
	}
	public String getOrder_date() {
		return order_date;
	}
	public void setOrder_date(String order_date) {
		this.order_date = order_date;
	}
	public int getMember_id() {
		return member_id;
	}
	public void setMember_id(int member_id) {
		this.member_id = member_id;
	}
	public Member getMember() {
		return member;
	}
	public void setMember(Member member) {
		this.member = member;
	}
	public int[] getGame_id() {
		return game_id;
	}
	public void setGame_id(int[] game_id) {
		this.game_id = game_id;
	}
	public List<Sales_Detail> getDetailList() {
		return detailList;
	}
	public void setDetailList(List<Sales_Detail> detailList) {
		this.detailList = detailList;
	}
	
}
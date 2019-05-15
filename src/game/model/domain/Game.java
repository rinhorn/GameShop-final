package game.model.domain;

import org.springframework.web.multipart.MultipartFile;

public class Game {
	private int game_id;
	private String game_name;
	private int game_price, game_sale;
	private String game_company, game_date, game_detail;
	private Category category;
	private int category_id;
	private MultipartFile[] myfile;
	private String[] myfile_name;
	
	public int getGame_id() {
		return game_id;
	}
	public void setGame_id(int game_id) {
		this.game_id = game_id;
	}
	public String getGame_name() {
		return game_name;
	}
	public void setGame_name(String game_name) {
		this.game_name = game_name;
	}
	public int getGame_price() {
		return game_price;
	}
	public void setGame_price(int game_price) {
		this.game_price = game_price;
	}
	public int getGame_sale() {
		return game_sale;
	}
	public void setGame_sale(int game_sale) {
		this.game_sale = game_sale;
	}
	public String getGame_company() {
		return game_company;
	}
	public void setGame_company(String game_company) {
		this.game_company = game_company;
	}
	public String getGame_date() {
		return game_date;
	}
	public void setGame_date(String game_date) {
		this.game_date = game_date;
	}
	public String getGame_detail() {
		return game_detail;
	}
	public void setGame_detail(String game_detail) {
		this.game_detail = game_detail;
	}
	public Category getCategory() {
		return category;
	}
	public void setCategory(Category category) {
		this.category = category;
	}
	public int getCategory_id() {
		return category_id;
	}
	public void setCategory_id(int category_id) {
		this.category_id = category_id;
	}
	public MultipartFile[] getMyfile() {
		return myfile;
	}
	public void setMyfile(MultipartFile[] myfile) {
		this.myfile = myfile;
	}
	public String[] getMyfile_name() {
		return myfile_name;
	}
	public void setMyfile_name(String[] myfile_name) {
		this.myfile_name = myfile_name;
	}
}
package game.model.domain;

import org.springframework.web.multipart.MultipartFile;

public class Event {
	private int event_id;
	private int event_discount;
	private String event_name, event_icon, event_img;
	private MultipartFile myFile_icon, myFile_img;
	private int[] game_id;
	
	public int getEvent_id() {
		return event_id;
	}
	public void setEvent_id(int event_id) {
		this.event_id = event_id;
	}
	public int getEvent_discount() {
		return event_discount;
	}
	public void setEvent_discount(int event_discount) {
		this.event_discount = event_discount;
	}
	public String getEvent_name() {
		return event_name;
	}
	public void setEvent_name(String event_name) {
		this.event_name = event_name;
	}
	public String getEvent_icon() {
		return event_icon;
	}
	public void setEvent_icon(String event_icon) {
		this.event_icon = event_icon;
	}
	public String getEvent_img() {
		return event_img;
	}
	public void setEvent_img(String event_img) {
		this.event_img = event_img;
	}
	public MultipartFile getMyFile_icon() {
		return myFile_icon;
	}
	public void setMyFile_icon(MultipartFile myFile_icon) {
		this.myFile_icon = myFile_icon;
	}
	public MultipartFile getMyFile_img() {
		return myFile_img;
	}
	public void setMyFile_img(MultipartFile myFile_img) {
		this.myFile_img = myFile_img;
	}
	public int[] getGame_id() {
		return game_id;
	}
	public void setGame_id(int[] game_id) {
		this.game_id = game_id;
	}
}
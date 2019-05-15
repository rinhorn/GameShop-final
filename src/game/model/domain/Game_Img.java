package game.model.domain;

public class Game_Img {
	private int game_img_id;
	private Game game;
	private String img_filename;
	
	public int getGame_img_id() {
		return game_img_id;
	}
	public void setGame_img_id(int game_img_id) {
		this.game_img_id = game_img_id;
	}
	public Game getGame() {
		return game;
	}
	public void setGame(Game game) {
		this.game = game;
	}
	public String getImg_filename() {
		return img_filename;
	}
	public void setImg_filename(String img_filename) {
		this.img_filename = img_filename;
	}

	
}

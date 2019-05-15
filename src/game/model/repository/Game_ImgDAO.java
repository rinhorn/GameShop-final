package game.model.repository;

import java.util.List;

import game.model.domain.Game_Img;

public interface Game_ImgDAO {
	public int insert(Game_Img game_img);
	public List selectAll();
	public Game_Img select(int game_img_id);
	public int update(Game_Img game_img);
	public int delete(int game_id);
	public List selectImg(int game_id);
}

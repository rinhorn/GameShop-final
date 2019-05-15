package game.model.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Game_Img;

@Repository
public class MybatisGame_ImgDAO implements Game_ImgDAO{
	@Autowired
	private SqlSessionTemplate sessionTemplate;
		
	public int insert(Game_Img game_img) {
		return sessionTemplate.insert("Game_Img.insert", game_img);
	}

	public List selectAll() {
		return null;
	}

	public Game_Img select(int game_img_id) {
		return null;
	}

	public int update(Game_Img game_img) {
		return 0;
	}

	public int delete(int game_id) {
		return sessionTemplate.delete("Game_Img.delete", game_id);
	}

	public List selectImg(int game_id) {
		return sessionTemplate.selectList("Game_Img.selectImg", game_id);
	}
}

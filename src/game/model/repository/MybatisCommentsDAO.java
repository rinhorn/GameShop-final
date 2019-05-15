package game.model.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Comments;

@Repository
public class MybatisCommentsDAO implements CommentsDAO {
	@Autowired
	private SqlSessionTemplate sessionTemplate;

	public int insert(Comments comments) {
		return sessionTemplate.insert("Comments.insert", comments);
	}

	public List selectAllByGame(int game_id) {
		return sessionTemplate.selectList("Comments.selectAllByGame", game_id);
	}

	public int update(Comments comments) {
		return sessionTemplate.update("Comments.update", comments);
	}

	public int delete(int comments_id) {
		return sessionTemplate.delete("Comments.delete", comments_id);
	}
}
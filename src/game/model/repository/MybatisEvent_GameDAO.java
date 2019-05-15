package game.model.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Event_Game;

@Repository
public class MybatisEvent_GameDAO implements Event_GameDAO {
	@Autowired
	private SqlSessionTemplate sessionTemplate;

	public int insert(Event_Game event_Game) {
		return sessionTemplate.insert("Event_Game.insert", event_Game);
	}

	public List selectAll() {
		return sessionTemplate.selectList("Event_Game.selectAll");
	}

	public Event_Game select(int event_game_id) {
		return sessionTemplate.selectOne("Event_Game.select", event_game_id);
	}

	public int update(Event_Game event_Game) {
		return 0;
	}

	public int delete(int event_id) {
		return sessionTemplate.delete("Event_Game.delete", event_id);
	}

	public List selectGame(int event_id) {
		return sessionTemplate.selectList("Event_Game.selectGame", event_id);
	}
	
	public List selectEventGame(int game_id) {
		return sessionTemplate.selectList("Event_Game.selectEventGame", game_id);
	}
}
package game.model.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Event;

@Repository
public class MybatisEventDAO implements EventDAO{
	@Autowired
	private SqlSessionTemplate sessionTemplate;

	public int insert(Event event) {
		return sessionTemplate.insert("Event.insert", event);
	}

	public List selectAll() {
		return sessionTemplate.selectList("Event.selectAll");
	}

	public Event select(int event_id) {
		return sessionTemplate.selectOne("Event.select", event_id);
	}

	public int update(Event event) {
		return sessionTemplate.update("Event.update", event);
	}

	public int delete(int event_id) {
		return sessionTemplate.delete("Event.delete", event_id);
	}

	public Event search(String event_name) {
		return sessionTemplate.selectOne("Event.search", event_name);
	}
}
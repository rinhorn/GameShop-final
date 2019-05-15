package game.model.repository;

import java.util.List;

import game.model.domain.Event;

public interface EventDAO {
	public int insert(Event event);
	public List selectAll();
	public Event select(int event_id	);
	public int update(Event event);
	public int delete(int event_id);
	public Event search(String event_name);
}

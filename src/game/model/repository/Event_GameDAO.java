package game.model.repository;

import java.util.List;

import game.model.domain.Event_Game;

public interface Event_GameDAO {
	public int insert(Event_Game event_Game);
	public List selectAll();
	public Event_Game select(int event_game_id);
	public int update(Event_Game event_Game);
	public int delete(int event_id);
	public List selectGame(int event_id);
	public List selectEventGame(int game_id);
}
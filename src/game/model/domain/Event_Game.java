package game.model.domain;

public class Event_Game {
	private int event_game_id;
	private Event event;
	private Game game;
	
	public int getEvent_game_id() {
		return event_game_id;
	}
	public void setEvent_game_id(int event_game_id) {
		this.event_game_id = event_game_id;
	}
	public Event getEvent() {
		return event;
	}
	public void setEvent(Event event) {
		this.event = event;
	}
	public Game getGame() {
		return game;
	}
	public void setGame(Game game) {
		this.game = game;
	}

}

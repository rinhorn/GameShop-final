package game.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import game.common.exception.DataNotFoundException;
import game.common.exception.DeleteFailException;
import game.common.exception.EditFailException;
import game.common.exception.RegistFailException;
import game.model.domain.Event;
import game.model.domain.Event_Game;
import game.model.domain.Game;
import game.model.repository.EventDAO;
import game.model.repository.Event_GameDAO;
import game.model.repository.GameDAO;

@Service
public class EventServiceImpl implements EventService {
	@Autowired
	private EventDAO eventDAO;
	@Autowired
	private Event_GameDAO event_GameDAO;
	@Autowired
	private GameDAO gameDAO;

	public void insert(Event event) throws RegistFailException {
		int result2 = 0;
		int result3 = 0;

		int result1 = eventDAO.insert(event);
		if (result1 == 0) {
			throw new RegistFailException("이벤트 등록 실패");
		} else {
			for (int i = 0; i < event.getGame_id().length; i++) {
				Event_Game event_game = new Event_Game();
				event_game.setEvent(event);

				Game game = new Game();
				game.setGame_id(event.getGame_id()[i]);
				event_game.setGame(game);

				result2 = event_GameDAO.insert(event_game);
				if (result2 == 0) {
					throw new RegistFailException("게임에 이벤트 적용 실패");

				} else {
					game.setGame_sale(event.getEvent_discount());
					result3 = gameDAO.updateSale(game);
					if (result3 == 0) {
						throw new EditFailException("게임 할인율 수정 실패");
					}
				}
			}
		}
	}

	public List selectAll() {
		return eventDAO.selectAll();
	}

	public Event select(int event_id) throws DataNotFoundException {
		Event event = eventDAO.select(event_id);
		if (event == null) {
			throw new DataNotFoundException("이벤트 조회 실패");
		}
		return event;
	}

	public void update(Event event) throws EditFailException, DeleteFailException, RegistFailException {
		int result1 = 0;
		int result2 = 0;
		int result3 = 0;
		int result4 = 0;

		result1 = eventDAO.update(event);
		if (result1 == 0) {
			throw new EditFailException("이벤트 수정 실패");
		} else {
			result2 = event_GameDAO.delete(event.getEvent_id());
			if (result2 == 0) {
				throw new DeleteFailException("이벤트 게임 삭제 실패");
			} else {
				for (int i = 0; i < event.getGame_id().length; i++) {
					Event_Game event_game = new Event_Game();
					event_game.setEvent(event);

					Game game = new Game();
					game.setGame_id(event.getGame_id()[i]);
					event_game.setGame(game);
					result3 = event_GameDAO.insert(event_game);
					if (result3 == 0) {
						throw new RegistFailException("게임에 이벤트 등록 실패");

					} else {
						game.setGame_sale(event.getEvent_discount());
						result4 = gameDAO.updateSale(game);
						if (result4 == 0) {
							throw new EditFailException("게임 할인율 수정 실패");
						}
					}
				}
			}
		}
	}

	public void delete(Event event) throws DeleteFailException {
		int result1 = 0;
		int result2 = 0;
		int result3 = 0;

		result1 = event_GameDAO.delete(event.getEvent_id());
		if (result1 == 0) {
			throw new DeleteFailException("게임의 이벤트 삭제 실패");
		} else {
			result2 = eventDAO.delete(event.getEvent_id());
			if (result2 == 0) {
				throw new DeleteFailException("이벤트 삭제 실패");
				 
			} else {
				for (int i = 0; i < event.getGame_id().length; i++) {
					Game game = new Game();
					game.setGame_id(event.getGame_id()[i]);
					game.setGame_sale(0);
					result3 = gameDAO.updateSale(game);
					if (result3 == 0) {
						throw new EditFailException("게임 할인율 수정 실패");
					}
				}
			}
		}
	}

	public List selectGame(int event_id) {
		return event_GameDAO.selectGame(event_id);
	}

	public Event search(String event_name) throws DataNotFoundException {
		Event event = eventDAO.search(event_name);
		if (event == null) {
			throw new DataNotFoundException("이벤트 검색 실패");
		}
		return event;
	}

	public List eventGameList() {
		return event_GameDAO.selectAll();
	}

	public List eventGame(int game_id) {
		return event_GameDAO.selectEventGame(game_id);
	}
}
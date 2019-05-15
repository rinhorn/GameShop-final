package game.model.repository;

import game.model.domain.Master;

public interface MasterDAO {
	public Master loginCheck(Master master);
}
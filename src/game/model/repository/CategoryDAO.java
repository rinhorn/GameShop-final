package game.model.repository;

import java.util.List;

import game.model.domain.Category;

public interface CategoryDAO {
	public List selectAll();
	public Category select(int category_id);
}

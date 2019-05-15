package game.model.service;

import java.util.List;

import game.model.domain.Category;

public interface CategoryService {
	public List selectAll();
	public Category select(int category_id);
}

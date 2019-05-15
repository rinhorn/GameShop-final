package game.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import game.common.exception.DataNotFoundException;
import game.model.domain.Category;
import game.model.repository.CategoryDAO;

@Service
public class CategoryServiceImpl implements CategoryService {
	@Autowired
	private CategoryDAO categoryDAO;

	public List selectAll() {
		return categoryDAO.selectAll();
	}

	public Category select(int category_id) throws DataNotFoundException {
		Category category = categoryDAO.select(category_id);
		if (category == null) {
			throw new DataNotFoundException("카테고리 조회 실패");
		}
		return category;
	}
}

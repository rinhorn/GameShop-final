package game.model.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Category;

@Repository
public class MybatisCategoryDAO implements CategoryDAO{
	@Autowired
	private SqlSessionTemplate sessionTemplate;

	public List selectAll() {
		return sessionTemplate.selectList("Category.selectAll");
	}
	
   public Category select(int category_id) {
      return sessionTemplate.selectOne("Category.select", category_id);
   }
}

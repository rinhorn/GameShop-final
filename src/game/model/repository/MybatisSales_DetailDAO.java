package game.model.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Sales_Detail;

@Repository
public class MybatisSales_DetailDAO implements Sales_DetailDAO {
   @Autowired
   private SqlSessionTemplate sessionTemplate;

   public int insert(Sales_Detail sales_Detail) {
      return sessionTemplate.insert("Sales_Detail.insert", sales_Detail);
   }

   public List selectAll() {
      return sessionTemplate.selectList("Sales_Detail.selectAll");
   }

	public List selectAllByGame(int game_id) {
		return sessionTemplate.selectList("Sales_Detail.selectAllGame", game_id);
	}
	
	public List selectByGame(int game_id) {
      return sessionTemplate.selectList("Sales_Detail.selectByGame", game_id);
   }
	   
   public int countGame(int game_id) {
      return sessionTemplate.selectOne("Sales_Detail.countGame", game_id);
   }
}
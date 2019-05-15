package game.model.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Sales;

@Repository
public class MybatisSalesDAO implements SalesDAO {
   @Autowired
   private SqlSessionTemplate sessionTemplate;
   
   public int insert(Sales sales) {
      return sessionTemplate.insert("Sales.insert", sales);
   }
   
   public List<Sales> selectAllInMyPage(int member_id) {
      return sessionTemplate.selectList("Sales.selectAllInMyPage", member_id);
   }
   
   public List<Sales> selectAll() {
      return sessionTemplate.selectList("Sales.selectAll");
   }
   
   public List<Sales> selectAllByOrderDate(String order_date){
      return sessionTemplate.selectList("Sales.selectAllByOrderDate", order_date);
   }
}
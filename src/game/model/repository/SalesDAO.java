package game.model.repository;

import java.util.List;

import game.model.domain.Sales;

public interface SalesDAO {
   public int insert(Sales sales);
   public List<Sales> selectAllInMyPage(int member_id);
   public List<Sales> selectAll();
   public List<Sales> selectAllByOrderDate(String order_date);
}
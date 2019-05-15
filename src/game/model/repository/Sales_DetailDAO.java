package game.model.repository;

import java.util.List;

import game.model.domain.Sales_Detail;

public interface Sales_DetailDAO {
   public int insert(Sales_Detail sales_Detail);
   public List selectAll();
   public List selectAllByGame(int game_id);
   public List selectByGame(int game_id);
   public int countGame(int game_id);
}
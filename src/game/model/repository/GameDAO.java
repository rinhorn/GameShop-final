package game.model.repository;

import java.util.List;

import game.model.domain.Game;

public interface GameDAO {
   public int insert(Game game);
   public List selectAll();
   public Game select(int game_id);
   public int update(Game game);
   public int delete(int game_id);
   public Game search(String game_name);
   public List selectByName();
   public List selectByPrice();
   public List selectByRegdate();
   public List selectByCategory(int category_id);
   public List selectByCategoryName(int category_id);
   public List selectByCategoryPrice(int category_id);
   public List selectByCategoryRegdate(int category_id);
   public int updateSale(Game game);
}
package game.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import game.common.exception.DeleteFailException;
import game.common.exception.RegistFailException;
import game.model.domain.Cart;
import game.model.domain.Game;
import game.model.domain.Member;
import game.model.domain.Sales;
import game.model.domain.Sales_Detail;
import game.model.repository.CartDAO;
import game.model.repository.GameDAO;
import game.model.repository.SalesDAO;
import game.model.repository.Sales_DetailDAO;

@Service
public class PayServiceImpl implements PayService {
   @Autowired
   private SalesDAO salesDAO;
   @Autowired
   private Sales_DetailDAO sales_DetailDAO;
   @Autowired
   private GameDAO gameDAO;
   @Autowired
   private CartDAO cartDAO;

   public void insert(Sales sales) throws RegistFailException {
      int result1 = salesDAO.insert(sales);
      if (result1 == 0) {
         throw new RegistFailException("매출 등록 실패");
         
      } else {
         for (int i = 0; i < sales.getGame_id().length; i++) {
            Sales_Detail sales_Detail = new Sales_Detail();
            sales_Detail.setSales(sales);

            Game game = gameDAO.select(sales.getGame_id()[i]);
            sales_Detail.setGame(game);
            sales_Detail.setSales_rate(game.getGame_sale());

            int result2 = sales_DetailDAO.insert(sales_Detail);
            if (result2 == 0) {
               throw new RegistFailException("매출 상세 등록 실패");
               
            } else {
    			Cart cart = new Cart();
    			Member member = new Member();
    			member.setMember_id(sales.getMember_id());
    			cart.setMember(member);
    			cart.setGame(game);
    			cartDAO.deleteBySelect(cart);
            }
         }
      }
   }

   public List<Sales> selectSales_Detail(int member_id) {
      return salesDAO.selectAllInMyPage(member_id);
   }

	public List<Sales_Detail> selectGame(int game_id) {
		return sales_DetailDAO.selectAllByGame(game_id);
	}
	
	public int getTotal() {
		int total=0;
		List<Sales_Detail> salesDetailList=sales_DetailDAO.selectAll();
		for(int i=0;i<salesDetailList.size();i++) {
			Sales_Detail detail=salesDetailList.get(i);
			int game_price=detail.getGame().getGame_price();
			int sales_rate=detail.getSales_rate();
			total+=game_price*(100-sales_rate)*0.01;
		}
		return total;
	}
	
	public List<Sales> selectAllSales() {
      return salesDAO.selectAll();
   }
   
   public List<Sales_Detail> selectTopGames(){
      return sales_DetailDAO.selectAll();
   }
   
   public List<Sales> selectAllByOrderDate(String order_date){
      return salesDAO.selectAllByOrderDate(order_date);
   }
}
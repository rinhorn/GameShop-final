package game.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import game.common.board.Pager;
import game.model.domain.Cart;
import game.model.domain.Category;
import game.model.domain.Game;
import game.model.domain.Member;
import game.model.domain.Sales_Detail;
import game.model.service.CartService;
import game.model.service.CategoryService;
import game.model.service.GameService;
import game.model.service.PayService;

@RestController
public class RestGameController {
	@Autowired
	private CategoryService categoryService;
	@Autowired
	private GameService gameService;
	@Autowired
	private CartService cartService;
	@Autowired
	private Pager pager;
	@Autowired
	private PayService payService;

	@RequestMapping(value = "/rest/admin/categories/{category_id}", method = RequestMethod.GET)
	public Category getCategory(@PathVariable("category_id") int category_id) {
		return categoryService.select(category_id);
	}

	@RequestMapping(value = "/rest/admin/categories", method = RequestMethod.GET)
	public List getCategories() {
		return categoryService.selectAll();
	}

	@RequestMapping(value = "/rest/admin/gamePagers", method = RequestMethod.GET)
	public Pager paging(@RequestParam("currentPage") int currentPage) {
		List<Game> gameList = gameService.selectAllGames();
		pager.init(currentPage, gameList.size(), 10);
		return pager;
	}

	@RequestMapping(value = "/rest/admin/games", method = RequestMethod.GET)
	public List getGames() {
		return gameService.selectAllGames();
	}

	@RequestMapping(value = "/rest/admin/games/{game_id}", method = RequestMethod.GET)
	public Game getGameDetail(@PathVariable("game_id") int game_id) {
		return gameService.selectGame(game_id);
	}

	@RequestMapping(value = "/rest/admin/game/images", method = RequestMethod.GET)
	public List getGameImage(@RequestParam("game_id") int game_id) {
		return gameService.selectGameImg(game_id);
	}

	@RequestMapping(value = "/rest/admin/searchgame", method = RequestMethod.GET)
	public Game searchGames(@RequestParam("game_name") String game_name) {
		return gameService.searchGame(game_name);
	}

	@RequestMapping(value = "/rest/client/game/search", method = RequestMethod.GET)
	public Game searchGame(@RequestParam("game_name") String game_name) {
		return gameService.searchGame(game_name);
	}

	@RequestMapping(value = "/rest/client/games/{game_id}", method = RequestMethod.GET)
	public Game clientGetGame(@PathVariable("game_id") int game_id) {
		return gameService.selectGame(game_id);
	}

	@RequestMapping(value = "/rest/client/games", method = RequestMethod.GET)
	public List clientGetGames() {
		return gameService.selectAllGames();
	}

	@RequestMapping(value = "/rest/client/game/images", method = RequestMethod.GET)
	public List clientGetGameImage(@RequestParam("game_id") int game_id) {
		return gameService.selectGameImg(game_id);
	}

	@RequestMapping(value = "/rest/client/game/sort", method = RequestMethod.GET)
	   public List sortGames(@RequestParam("category_id") int category_id, @RequestParam("type") String type) {
	      List<Game> gameList = new ArrayList<Game>();
	      if (category_id == 0) {
	         if (type.equals("0")) {
	            gameList = gameService.selectAllGames();
	         } else if (type.equals("1")) {
	            gameList = gameService.selectGameByName();
	         } else if (type.equals("2")) {
	            gameList = gameService.selectGameByPrice();
	         } else if (type.equals("3")) {
	            gameList = gameService.selectGameByRegdate();
	         } else if (type.equals("4")) {
	        	 List<Sales_Detail> salesList = gameService.selectGameBySales();
	             for (int i = 0; i < salesList.size(); i++) {
	                Game game = salesList.get(i).getGame();
	                gameList.add(game);
	             }
	             
	             List<Game> allList=gameService.selectAllGames();
	             for(int i=0; i < allList.size(); i++) {
	            	 Game allGame=allList.get(i);
	            	 int cnt=0;
	            	 for(int j=0;j<gameList.size();j++) {
	            		 if(gameList.get(j).getGame_id()==allGame.getGame_id()) {
	            			 cnt++;
	            		 }
	            	 }
	            	 if(cnt==0) { 
	            		 gameList.add(allGame);
	            	 }
	             }
	         }
	      } else {
	         if (type.equals("0")) {
	            gameList = gameService.selectGameByCategory(category_id);
	         } else if (type.equals("1")) {
	            gameList = gameService.selectGameByCategoryName(category_id);
	         } else if (type.equals("2")) {
	            gameList = gameService.selectGameByCategoryPrice(category_id);
	         } else if (type.equals("3")) {
	            gameList = gameService.selectGameByCategoryRegdate(category_id);
	         } else if (type.equals("4")) {
	        	 List<Sales_Detail> salesList = gameService.selectGameBySales();
	             for (int i = 0; i < salesList.size(); i++) {
	                Game game = salesList.get(i).getGame();
	                if (game.getCategory_id() == category_id) {
	                   gameList.add(game);
	                }
	             }
	             
	             List<Game> allList=gameService.selectGameByCategory(category_id);
	             for(int i=0; i < allList.size(); i++) {
	            	 Game allGame=allList.get(i);
	            	 int cnt=0;
	            	 for(int j=0;j<gameList.size();j++) {
	            		 if(gameList.get(j).getGame_id()==allGame.getGame_id()) {
	            			 cnt++;
	            		 }
	            	 }
	            	 if(cnt==0) { 
	            		 gameList.add(allGame);
	            	 }
	             }
	         }
	      }
	      return gameList; 
	   }
	
	@RequestMapping(value = "/rest/client/gameList", method = RequestMethod.GET)
	public List mainGameList() {
		return gameService.selectAllGames();
	}

	@RequestMapping(value = "/rest/client/game/comment/{game_id}", method = RequestMethod.GET)
	public List getComments(@PathVariable("game_id") int game_id) {
		return gameService.selectAllComments(game_id);
	}

	@RequestMapping(value = "/rest/client/pay/cart/{member_id}", method = RequestMethod.GET)
	public List getCart(@PathVariable("member_id") int member_id) {
		return cartService.selectAll(member_id);
	}

	@RequestMapping(value = "/rest/client/pay/cart/image", method = RequestMethod.GET)
	public List getCartImg(int game_id) {
		return gameService.selectGameImg(game_id);
	}

	@RequestMapping(value = "/rest/client/game/category", method = RequestMethod.GET)
	public List clientGetCategories() {
		return categoryService.selectAll();
	}
	
	@RequestMapping(value="/rest/client/pay/cart/game", method=RequestMethod.GET)
	public Cart checkCart(@RequestParam("game_id") int game_id, @RequestParam("member_id") int member_id) {
		Game game=new Game();
		Member member=new Member();
		Cart cart=new Cart();
		
		game.setGame_id(game_id);
		member.setMember_id(member_id);
		cart.setGame(game);
		cart.setMember(member);
		
		return cartService.select(cart);
	}
	
	@RequestMapping(value="/rest/client/pay/cart/delAll", method=RequestMethod.GET)
	public void delAllCart(@RequestParam("member_id") int member_id) {
		cartService.deleteByMember(member_id);
	}
	
	@RequestMapping(value="/rest/client/pay/cart/delSelect", method=RequestMethod.GET)
	public void delSelectCart(@RequestParam("member_id") int member_id, @RequestParam("game_id") String[] game_id) {
		cartService.deleteBySelect(member_id, game_id);
	}
	
	@RequestMapping(value = "/rest/client/game/myPage", method = RequestMethod.GET)
   public List selectMyGame(@RequestParam("member_id") int member_id) {
      return payService.selectSales_Detail(member_id);
   }
	
	@RequestMapping(value = "/rest/client/gamePagers", method = RequestMethod.GET)
	public Pager gamePaging(@RequestParam("currentPage") int currentPage) {
		List<Game> gameList = gameService.selectAllGames();
		pager.init(currentPage, gameList.size(), 12);
		return pager;
	}
	
	@RequestMapping(value = "/rest/client/gameSortPagers", method = RequestMethod.GET)
	public Pager gameSortPaging(@RequestParam("currentPage") int currentPage, @RequestParam("category_id") int category_id, @RequestParam("type") String type) {
	   List<Game> gameList = new ArrayList<Game>();
	      if (category_id == 0) {
	         if (type.equals("0")) {
	            gameList = gameService.selectAllGames();
	         } else if (type.equals("1")) {
	            gameList = gameService.selectGameByName();
	         } else if (type.equals("2")) {
	            gameList = gameService.selectGameByPrice();
	         } else if (type.equals("3")) {
	            gameList = gameService.selectGameByRegdate();
	         } else if (type.equals("4")) {
	        	 List<Sales_Detail> salesList = gameService.selectGameBySales();
	             for (int i = 0; i < salesList.size(); i++) {
	                Game game = salesList.get(i).getGame();
	                gameList.add(game);
	             }
	             
	             List<Game> allList=gameService.selectAllGames();
	             for(int i=0; i < allList.size(); i++) {
	            	 Game allGame=allList.get(i);
	            	 int cnt=0;
	            	 for(int j=0;j<gameList.size();j++) {
	            		 if(gameList.get(j).getGame_id()==allGame.getGame_id()) {
	            			 cnt++;
	            		 }
	            	 }
	            	 if(cnt==0) { 
	            		 gameList.add(allGame);
	            	 }
	             }
	         }
	      } else {
	         if (type.equals("0")) {
	            gameList = gameService.selectGameByCategory(category_id);
	         } else if (type.equals("1")) {
	            gameList = gameService.selectGameByCategoryName(category_id);
	         } else if (type.equals("2")) {
	            gameList = gameService.selectGameByCategoryPrice(category_id);
	         } else if (type.equals("3")) {
	            gameList = gameService.selectGameByCategoryRegdate(category_id);
	         } else if (type.equals("4")) {
	        	 List<Sales_Detail> salesList = gameService.selectGameBySales();
	             for (int i = 0; i < salesList.size(); i++) {
	                Game game = salesList.get(i).getGame();
	                if (game.getCategory_id() == category_id) {
	                   gameList.add(game);
	                }
	             }
	             
	             List<Game> allList=gameService.selectGameByCategory(category_id);
	             for(int i=0; i < allList.size(); i++) {
	            	 Game allGame=allList.get(i);
	            	 int cnt=0;
	            	 for(int j=0;j<gameList.size();j++) {
	            		 if(gameList.get(j).getGame_id()==allGame.getGame_id()) {
	            			 cnt++;
	            		 }
	            	 }
	            	 if(cnt==0) { 
	            		 gameList.add(allGame);
	            	 }
	             }
	         }
	      }
	      
		pager.init(currentPage, gameList.size(), 12);
		return pager;
	}
}
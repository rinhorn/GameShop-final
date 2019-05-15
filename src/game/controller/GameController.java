package game.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import game.common.exception.DataNotFoundException;
import game.common.exception.DeleteFailException;
import game.common.exception.EditFailException;
import game.common.exception.RegistFailException;
import game.common.file.FileManager;
import game.model.domain.Cart;
import game.model.domain.Category;
import game.model.domain.Comments;
import game.model.domain.Event;
import game.model.domain.Game;
import game.model.domain.Member;
import game.model.service.CartService;
import game.model.service.CategoryService;
import game.model.service.GameService;

@Controller
public class GameController {
	@Autowired
	private CategoryService categoryService;
	@Autowired
	private GameService gameService;
	@Autowired
	private CartService cartService;
	@Autowired
	private FileManager fileManager;

	@RequestMapping(value = "/admin/game", method = RequestMethod.GET)
	public ModelAndView selectAllGames(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("admin/game/index");
		List gameList = gameService.selectAllGames();
		mav.addObject("gameList", gameList);
		return mav;
	}

	@RequestMapping(value = "/admin/game/regist", method = RequestMethod.POST)
	public ModelAndView registGame(Game game, HttpServletRequest request) {
		String[] myFile_name = new String[game.getMyfile().length];

		for (int i = 0; i < game.getMyfile().length; i++) {
			String realPath = request.getServletContext().getRealPath("/data/game");
			// System.out.println(realPath);
			MultipartFile myFile_one = game.getMyfile()[i];
			String filename = myFile_one.getOriginalFilename();

			File uploadFile = null;
			try {
				uploadFile = new File(realPath + "/" + filename);
				myFile_one.transferTo(uploadFile);
				filename = fileManager.renameByDate(uploadFile, realPath);

				if (filename != null) {
					myFile_name[i] = filename;
				}
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		gameService.registGame(game, myFile_name);

		ModelAndView mav = new ModelAndView("admin/game/index");
		return mav;
	}

	@RequestMapping(value = "/admin/game/update", method = RequestMethod.POST)
	public ModelAndView updateGame(Game game, HttpServletRequest request) {
		Category category = categoryService.select(game.getCategory_id());
		game.setCategory(category);

		if (game.getMyfile_name() == null) {
			String[] myFile_name = new String[game.getMyfile().length];
			for (int i = 0; i < game.getMyfile().length; i++) {
				String realPath = request.getServletContext().getRealPath("/data/game");
				// System.out.println(realPath);
				MultipartFile myFile_one = game.getMyfile()[i];
				String filename = myFile_one.getOriginalFilename();

				File uploadFile = null;
				try {
					uploadFile = new File(realPath + "/" + filename);
					myFile_one.transferTo(uploadFile);
					filename = fileManager.renameByDate(uploadFile, realPath);

					if (filename != null) {
						myFile_name[i] = filename;
					}
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			gameService.editAllGames(game, myFile_name);

		} else {
			gameService.editGame(game);
		}

		ModelAndView mav = new ModelAndView();
		mav.setViewName("/admin/game/index");
		return mav;
	}

	@RequestMapping(value = "/admin/game/delete", method = RequestMethod.POST)
	public ModelAndView deleteGame(int game_id) {
		gameService.deleteGame(game_id);
		ModelAndView mav = new ModelAndView("/admin/game/index");
		return mav;
	}

	@RequestMapping(value = "/client/game/comments/regist", method = RequestMethod.POST)
	public ModelAndView registComment(Comments comments, int member_id, int game_id) {
		Game game = new Game();
		Member member = new Member();

		game.setGame_id(game_id);
		member.setMember_id(member_id);
		comments.setGame(game);
		comments.setMember(member);

		gameService.registComment(comments);
		ModelAndView mav = new ModelAndView("redirect:/client/game/single.jsp");
		mav.addObject("game_id", game_id);

		return mav;
	}

	@RequestMapping(value = "/client/pay/cart/regist", method = RequestMethod.POST)
	public ModelAndView registCart(@RequestParam int member_id, @RequestParam int game_id) {
		Cart cart = new Cart();
		Member member = new Member();
		Game game = new Game();

		member.setMember_id(member_id);
		game.setGame_id(game_id);
		cart.setMember(member);
		cart.setGame(game);

		cartService.insert(cart);
		ModelAndView mav = new ModelAndView("/client/pay/cart");
		return mav;
	}
	
	@RequestMapping(value = "/client/comment/edit", method = RequestMethod.POST)
	public ModelAndView editComment(Comments comments,  int game_id) {
		gameService.editComment(comments);
		ModelAndView mav = new ModelAndView("redirect:/client/game/single.jsp");
		mav.addObject("game_id",  game_id);
		return mav;
	}
	
	@RequestMapping(value = "/client/comment/delete", method = RequestMethod.POST)
	public ModelAndView deleteComment(Comments comments,  int game_id) {
		gameService.deleteComment(comments.getComments_id());
		ModelAndView mav = new ModelAndView("redirect:/client/game/single.jsp");
		mav.addObject("game_id",  game_id);
		return mav;
	}
	
	@ExceptionHandler(DataNotFoundException.class)
	@ResponseBody
	public String dataNotFoundHandler(DataNotFoundException e) {
		return "{\"resultCode\":0, \"msg\":\"" + e.getMessage() + "\"}";
	}

	@ExceptionHandler(RegistFailException.class)
	@ResponseBody
	public String insertFailHandler(RegistFailException e) {
		return "{\"resultCode\":0, \"msg\":\"" + e.getMessage() + "\"}";
	}

	@ExceptionHandler(EditFailException.class)
	@ResponseBody
	public String updateFailException(EditFailException e) {
		return "{\"resultCode\":0, \"msg\":\"" + e.getMessage() + "\"}";
	}

	@ExceptionHandler(DeleteFailException.class)
	@ResponseBody
	public String deleteFailHandler(DeleteFailException e) {
		return "{\"resultCode\":0, \"msg\":\"" + e.getMessage() + "\"}";
	}
}
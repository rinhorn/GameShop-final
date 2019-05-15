package game.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import game.common.exception.DeleteFailException;
import game.common.exception.RegistFailException;
import game.model.domain.Cart;
import game.model.domain.Game;
import game.model.domain.Member;
import game.model.repository.CartDAO;

@Service
public class CartServiceImpl implements CartService {
	@Autowired
	private CartDAO cartDAO;

	public List selectAll(int member_id) {
		return cartDAO.selectAll(member_id);
	}

	public void insert(Cart cart) throws RegistFailException {
		int result = cartDAO.insert(cart);
		if (result == 0) {
			throw new RegistFailException("장바구니 등록 실패");
		}
	}

	public Cart select(Cart cart) {
		return cartDAO.select(cart);
	}

	public void deleteBySelect(int member_id, String[] game_id) throws DeleteFailException {
		for (int i = 0; i < game_id.length; i++) {
			Cart cart = new Cart();
			Member member = new Member();
			member.setMember_id(member_id);
			Game game = new Game();
			game.setGame_id(Integer.parseInt(game_id[i]));
			cart.setMember(member);
			cart.setGame(game);

			int result = cartDAO.deleteBySelect(cart);
			if (result == 0) {
				throw new DeleteFailException("장바구니 삭제 실패");
			}
		}
	}

	public void deleteByMember(int member_id) throws DeleteFailException {
		int result = cartDAO.deleteByMember(member_id);
		if (result == 0) {
			throw new DeleteFailException("장바구니 삭제 실패");
		}
	}
}
package game.model.service;

import java.util.List;

import game.model.domain.Cart;

public interface CartService {
	public List selectAll(int member_id);
	public void insert(Cart cart);
	public Cart select(Cart cart);
	public void deleteBySelect(int member_id, String[] game_id);
	public void deleteByMember(int member_id);
}
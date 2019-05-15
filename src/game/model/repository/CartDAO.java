package game.model.repository;

import java.util.List;

import game.model.domain.Cart;

public interface CartDAO {
	public List selectAll(int member_id);
	public int insert(Cart cart);
	public Cart select(Cart cart);
	public int deleteBySelect(Cart cart);
	public int deleteByMember(int member_id);
}	
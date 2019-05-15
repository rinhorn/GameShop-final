package game.model.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Cart;

@Repository
public class MybatisCartDAO implements CartDAO {
	@Autowired
	private SqlSessionTemplate sessionTemplate;

	public List selectAll(int member_id) {
		return sessionTemplate.selectList("Cart.selectAll", member_id);
	}

	public int insert(Cart cart) {
		return sessionTemplate.insert("Cart.insert", cart);
	}

	public Cart select(Cart cart) {
		return sessionTemplate.selectOne("Cart.select", cart);
	}

	public int deleteBySelect(Cart cart) {
		return sessionTemplate.delete("Cart.deleteBySelect", cart);
	}
	
	public int deleteByMember(int member_id) {
		return sessionTemplate.delete("Cart.deleteByMember", member_id);
	}
}
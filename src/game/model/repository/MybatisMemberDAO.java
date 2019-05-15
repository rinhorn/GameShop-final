package game.model.repository;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Member;

@Repository
public class MybatisMemberDAO implements MemberDAO {
	@Autowired
	private SqlSessionTemplate sessionTemplate;

	public int insert(Member member) {
		return sessionTemplate.insert("Member.insert", member);
	}

	public List selectAll() {
		return sessionTemplate.selectList("Member.selectAll");
	}

	public Member select(int member_id) {
		return sessionTemplate.selectOne("Member.select", member_id);
	}

	public int update(Member member) {
		return sessionTemplate.update("Member.update", member);
	}

	public int delete(int member_id) {
		return sessionTemplate.delete("Member.delete", member_id);
	}

	public Member search(String id) {
		return sessionTemplate.selectOne("Member.search", id);
	}

	public Member checkNick(String nick) {
		return sessionTemplate.selectOne("Member.checkNick", nick);
	}

	public Member checkEmail(String email) {
		return sessionTemplate.selectOne("Member.checkEmail", email);
	}

	public Member loginCheck(Member member) {
		return sessionTemplate.selectOne("Member.loginCheck", member);
	}
}
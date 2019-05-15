package game.model.repository;

import java.util.List;

import game.model.domain.Member;

public interface MemberDAO {
	public int insert(Member member);
	public List selectAll();
	public Member select(int member_id);
	public int update(Member member);
	public int delete(int member_id);
	public Member search(String id);
	public Member checkNick(String nick);
	public Member checkEmail(String email);
	public Member loginCheck(Member member);
}
package game.model.service;

import java.util.List;

import game.model.domain.Member;

public interface MemberService {
	public void insert(Member member);
	public List selectAll();
	public Member select(int member_id);
	public void update(Member member);
	public void delete(int member_id);
	public Member search(String id);
	public Member checkId(String id);
	public Member checkNick(String nick);
	public Member checkEmail(String email);
	public Member loginCheck(Member member);
}
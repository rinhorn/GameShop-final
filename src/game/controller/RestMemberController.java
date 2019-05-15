package game.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import game.common.board.Pager;
import game.common.exception.DataNotFoundException;
import game.model.domain.Member;
import game.model.service.MemberService;

@RestController
public class RestMemberController {
	@Autowired
	private MemberService memberService;
	@Autowired
	private Pager pager;

	@RequestMapping(value = "/rest/admin/members", method = RequestMethod.GET)
	public List list() {
		List<Member> memberList = memberService.selectAll();
		return memberList;
	}

	@RequestMapping(value = "/rest/admin/memberPagers", method = RequestMethod.GET)
	public Pager paging(@RequestParam("currentPage") int currentPage) {
		List<Member> memberList = memberService.selectAll();
		pager.init(currentPage, memberList.size(), 10);
		return pager;
	}

	@RequestMapping(value = "/rest/admin/member/{member_id}", method = RequestMethod.GET)
	public Member detail(@PathVariable("member_id") int member_id) {
		Member member = memberService.select(member_id);
		return member;
	}

	@RequestMapping(value = "/rest/admin/membersearch", method = RequestMethod.GET)
	public Member search(@RequestParam("id") String id) {
		Member member = memberService.search(id);
		return member;
	}

	@RequestMapping(value = "rest/admin/member/checkNick", method = RequestMethod.GET)
	public Member checkNick(@RequestParam("nick") String nick) {
		return memberService.checkNick(nick);
	}

	@RequestMapping(value = "rest/admin/member/checkEmail", method = RequestMethod.GET)
	public Member checkEmail(@RequestParam("email") String email) {
		return memberService.checkEmail(email);
	}

	@RequestMapping(value = "/rest/client/member/checkId", method = RequestMethod.GET)
	public Member checkClientId(@RequestParam("id") String id) {
		return memberService.checkId(id);
	}

	@RequestMapping(value = "/rest/client/member/checkNick", method = RequestMethod.GET)
	public Member checkClientNick(@RequestParam("nick") String nick) {
		return memberService.checkNick(nick);
	}

	@RequestMapping(value = "/rest/client/member/checkEmail", method = RequestMethod.GET)
	public Member checkClientEmail(@RequestParam("email") String email) {
		return memberService.checkEmail(email);
	}
	
	@RequestMapping(value = "/rest/client/profile", method = RequestMethod.GET)
	   public Member memberDetail(@RequestParam("member_id") int member_id) {
	      Member member = memberService.select(member_id);
	      return member;
	   }

	@ExceptionHandler(DataNotFoundException.class)
	@ResponseBody
	public String dataNotFoundHandler(DataNotFoundException e) {
		return "{\"resultCode\":0, \"msg\":\"" + e.getMessage() + "\"}";
	}
}
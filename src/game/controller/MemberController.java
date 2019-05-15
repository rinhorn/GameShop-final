package game.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import game.common.exception.AccountNotFoundException;
import game.common.exception.DataNotFoundException;
import game.common.exception.DeleteFailException;
import game.common.exception.EditFailException;
import game.common.exception.RegistFailException;
import game.model.domain.Member;
import game.model.service.MemberService;

@Controller
public class MemberController {
	@Autowired
	private MemberService memberService;

	@RequestMapping(value = "/admin/member", method = RequestMethod.GET)
	public ModelAndView selectAll(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("admin/member/index");
		List memberList = memberService.selectAll();
		mav.addObject("memberList", memberList);
		return mav;
	}

	@RequestMapping(value = "/admin/member/edit", method = RequestMethod.POST)
	public ModelAndView update(Member member) {
		ModelAndView mav = new ModelAndView("admin/member/index");
		memberService.update(member);
		return mav;
	}

	@RequestMapping(value = "/admin/member/delete", method = RequestMethod.GET)
	public ModelAndView delete(int member_id) {
		ModelAndView mav = new ModelAndView("admin/member/index");
		memberService.delete(member_id);
		return mav;
	}

	@RequestMapping(value = "/client/member/login", method = RequestMethod.POST)
	public ModelAndView login(Member member, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("client/main/index");
		Member obj = memberService.loginCheck(member);
		request.getSession().setAttribute("member", obj);
		return mav;
	}

	@RequestMapping(value = "/client/member/register", method = RequestMethod.POST)
	public ModelAndView registMember(Member member) {
		ModelAndView mav = new ModelAndView("client/login/index");
		memberService.insert(member);
		return mav;
	}

   @RequestMapping(value = "/client/member/edit", method = RequestMethod.POST)
   public ModelAndView editMember(Member member) {
      ModelAndView mav = new ModelAndView("client/myPage/index");
      memberService.update(member);
      return mav;
   }
   
   @RequestMapping(value = "/client/member/delete", method = RequestMethod.GET)
   public ModelAndView deleteMember(int member_id, HttpServletRequest request) {
      ModelAndView mav = new ModelAndView("client/main/index");
      memberService.delete(member_id);
      request.getSession().invalidate();
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

	@ExceptionHandler(AccountNotFoundException.class)
	public ModelAndView handleException(AccountNotFoundException e) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("client/login/loginFail");
		mav.addObject("err", e);
		return mav;
	}
}
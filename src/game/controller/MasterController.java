package game.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import game.common.exception.AccountNotFoundException;
import game.model.domain.Master;
import game.model.service.MasterService;

@RestController
public class MasterController {
	@Autowired
	private MasterService masterService;

	@RequestMapping(value = "/admin/login", method = RequestMethod.POST)
	public ModelAndView login(Master master, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("admin/member/index");
		Master obj = masterService.loginCheck(master);
		request.getSession().setAttribute("master", obj);
		return mav;
	}

	@RequestMapping(value = "/admin/logout", method = RequestMethod.GET)
	public ModelAndView logout(HttpServletRequest request) {
		request.getSession().invalidate();
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/login/logout");
		return mav;
	}

	@ExceptionHandler(AccountNotFoundException.class)
	public ModelAndView handleException(AccountNotFoundException e) {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("admin/login/loginFail");
		mav.addObject("err", e);
		return mav;
	}
}
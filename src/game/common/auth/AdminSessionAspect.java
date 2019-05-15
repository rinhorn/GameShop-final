package game.common.auth;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.web.servlet.ModelAndView;

@Aspect
public class AdminSessionAspect {

	@Pointcut("execution(public * game.controller.MemberController.*(..))")
	public void memberMaster() {

	}

	@Pointcut("execution(public * game.controller.GameController.*(..))")
	public void gameMaster() {

	}

	@Pointcut("execution(public * game.controller.EventController.*(..))")
	public void eventMaster() {

	}

	String[] exceptList = { "/client/member/login", "/client/member/register", "/client/member/delete" };

	@Around("memberMaster()||gameMaster()||eventMaster()")
	public ModelAndView loginCheck(ProceedingJoinPoint joinPoint) throws Throwable {
		HttpServletRequest request = null;
		ModelAndView mav = new ModelAndView();
		String requestURL = null;
		int count = 0;
		Object[] objArray = joinPoint.getArgs();

		for (Object obj : objArray) {
			if (obj instanceof HttpServletRequest) {
				request = (HttpServletRequest) obj;
				requestURL = request.getRequestURL().toString();

				for (int i = 0; i < exceptList.length; i++) {
					if (requestURL.endsWith(exceptList[i])) {
						count++;
					}
				}
			}
		}

		if (request != null && count == 0) {
			if (request.getSession().getAttribute("master") == null) {
				mav.setViewName("admin/login/index");
			} else {
				mav = (ModelAndView) joinPoint.proceed();
			}
		} else {
			mav = (ModelAndView) joinPoint.proceed();
		}
		return mav;
	}
}
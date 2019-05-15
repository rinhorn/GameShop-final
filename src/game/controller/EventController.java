package game.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import game.common.exception.DataNotFoundException;
import game.common.exception.DeleteFailException;
import game.common.exception.EditFailException;
import game.common.exception.RegistFailException;
import game.common.file.FileManager;
import game.model.domain.Event;
import game.model.service.EventService;

@Controller
public class EventController {
	@Autowired
	private EventService eventService;
	@Autowired
	private FileManager fileManager;

	@RequestMapping(value = "/admin/event", method = RequestMethod.GET)
	public ModelAndView selectAll(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("admin/event/index");
		List eventList = eventService.selectAll();
		mav.addObject("eventList", eventList);

		return mav;
	}

	@RequestMapping(value = "/admin/event/regist", method = RequestMethod.POST)
	public ModelAndView registEvent(Event event, HttpServletRequest request) {
		MultipartFile myFile_img = event.getMyFile_img();
		String filename_img = myFile_img.getOriginalFilename();
		MultipartFile myFile_icon = event.getMyFile_icon();
		String filename_icon = myFile_icon.getOriginalFilename();

		String realPath = request.getServletContext().getRealPath("/data/event");

		File uploadFile_img = null;
		File uploadFile_icon = null;
		try {
			uploadFile_img = new File(realPath + "/" + filename_img);
			myFile_img.transferTo(uploadFile_img);
			filename_img = fileManager.renameByDate(uploadFile_img, realPath);

			uploadFile_icon = new File(realPath + "/" + filename_icon);
			myFile_icon.transferTo(uploadFile_icon);
			filename_icon = fileManager.renameByDate(uploadFile_icon, realPath);

			if (filename_img != null && filename_icon != null) {
				event.setEvent_img(filename_img);
				event.setEvent_icon(filename_icon);
				eventService.insert(event);
			}
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		ModelAndView mav = new ModelAndView("admin/event/index");
		mav.addObject("event", event);
		return mav;
	}

	@RequestMapping(value = "/admin/event/edit", method = RequestMethod.POST)
	public ModelAndView update(Event event, HttpServletRequest request) {
		String realPath = request.getServletContext().getRealPath("/data/event");

		if (event.getMyFile_img() != null) {
			MultipartFile myFile_img = event.getMyFile_img();
			String filename_img = myFile_img.getOriginalFilename();
			File uploadFile_img = null;

			try {
				uploadFile_img = new File(realPath + "/" + filename_img);
				myFile_img.transferTo(uploadFile_img);
				filename_img = fileManager.renameByDate(uploadFile_img, realPath);

				if (filename_img != null) {
					event.setEvent_img(filename_img);
				}
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		if (event.getMyFile_icon() != null) {
			MultipartFile myFile_icon = event.getMyFile_icon();
			String filename_icon = myFile_icon.getOriginalFilename();
			File uploadFile_icon = null;

			try {
				uploadFile_icon = new File(realPath + "/" + filename_icon);
				myFile_icon.transferTo(uploadFile_icon);
				filename_icon = fileManager.renameByDate(uploadFile_icon, realPath);

				if (filename_icon != null) {
					event.setEvent_icon(filename_icon);
				}
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		eventService.update(event);
		ModelAndView mav = new ModelAndView("admin/event/index");
		return mav;
	}

	@RequestMapping(value = "/admin/event/delete", method = RequestMethod.POST)
	public ModelAndView delete(Event event) {
		eventService.delete(event);
		ModelAndView mav = new ModelAndView("admin/event/index");
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
	public String updateFailHandler(EditFailException e) {
		return "{\"resultCode\":0, \"msg\":\"" + e.getMessage() + "\"}";
	}

	@ExceptionHandler(DeleteFailException.class)
	@ResponseBody
	public String deleteFailHandler(DeleteFailException e) {
		return "{\"resultCode\":0, \"msg\":\"" + e.getMessage() + "\"}";
	}
}
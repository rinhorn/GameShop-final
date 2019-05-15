package game.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import game.common.exception.AccountNotFoundException;
import game.model.domain.Master;
import game.model.repository.MasterDAO;

@Service
public class MasterServiceImpl implements MasterService {
	@Autowired
	private MasterDAO masterDAO;

	public Master loginCheck(Master master) throws AccountNotFoundException{
		Master obj=masterDAO.loginCheck(master);
		if(obj==null) {
			throw new AccountNotFoundException("일치하는 정보가 없습니다");
		}
		return obj;
	}

}
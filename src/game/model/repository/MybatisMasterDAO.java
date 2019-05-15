package game.model.repository;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import game.model.domain.Master;

@Repository
public class MybatisMasterDAO implements MasterDAO {
	@Autowired
	private SqlSessionTemplate sessionTemplate;

	public Master loginCheck(Master master) {
		return sessionTemplate.selectOne("Master.loginCheck", master);
	}

}
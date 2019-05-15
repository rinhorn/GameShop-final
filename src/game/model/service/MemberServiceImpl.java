package game.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import game.common.auth.Security;
import game.common.exception.AccountNotFoundException;
import game.common.exception.DataNotFoundException;
import game.common.exception.DeleteFailException;
import game.common.exception.EditFailException;
import game.model.domain.Member;
import game.model.repository.MemberDAO;

@Service
public class MemberServiceImpl implements MemberService {
   Security security=new Security();
   @Autowired
   private MemberDAO memberDAO;

   public void insert(Member member) {
      String pass=security.textToHash(member.getPass());
      member.setPass(pass);
      
      memberDAO.insert(member);
   }

   public List selectAll() {
      return memberDAO.selectAll();
      
   }

   public Member select(int member_id) throws DataNotFoundException {
      Member member = memberDAO.select(member_id);
      if (member == null) {
         throw new DataNotFoundException("���� ��ȸ ����");
      }
      return member;
   }

   public void update(Member member) throws EditFailException {
      int result = 0;
      Member mem=memberDAO.select(member.getMember_id());
      
      if(!member.getPass().equals(mem.getPass())) {
         String pass=security.textToHash(member.getPass());
         member.setPass(pass);         
      }
      
      result=memberDAO.update(member);
      if (result == 0) {
         throw new EditFailException("���� ���� ���� ����");
      }
   }

   public void delete(int member_id) throws DeleteFailException {
      int result = 0;
      result = memberDAO.delete(member_id);
      if (result == 0) {
         throw new DeleteFailException("���� Ż�� ����");
      }
   }

   public Member search(String id) throws DataNotFoundException {
      Member member = memberDAO.search(id);
      if (member == null) {
         throw new DataNotFoundException("���� �˻� ����");
      }
      return member;
   }

   public Member checkId(String id) {
      return memberDAO.search(id);
   }

   public Member checkNick(String nick) {
      return memberDAO.checkNick(nick);
   }

   public Member checkEmail(String email) {
      return memberDAO.checkEmail(email);
   }

   public Member loginCheck(Member member) throws AccountNotFoundException {   
      String pass=security.textToHash(member.getPass());
      member.setPass(pass);
      
      Member member1 = memberDAO.loginCheck(member);
      if (member1 == null) {
         throw new AccountNotFoundException("��ġ�ϴ� ������ �����ϴ�");
      }
      return member1;
   }
}
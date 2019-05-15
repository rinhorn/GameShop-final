package game.common.auth;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Security {
   
   //�Ϲ� �ؽ�Ʈ�� �ؽð�(16������)���� ��ȯ�Ͽ� ��ȯ�ϴ� �޼��� ����
   public static String textToHash(String password) {
      StringBuilder sb=new StringBuilder();
      try {
         MessageDigest md=MessageDigest.getInstance("SHA-256");
         
         md.update(password.getBytes());//�ؽ�ȭ��ų �����͸� ����Ʈȭ(�� �ɰ��� �־���� ��)
         
         //��ȣȭ �� ����Ʈ ��ȯ�ޱ�
         byte[] data=md.digest();//�Ϲ� ����Ʈ�迭�� ��ȣȭ�� �����ͷ� ��ȯ
         //�迭�� ����ϱ⿣ ������ �����Ƿ� �ٽ� ��Ʈ��ȭ ��Ű��
         for(int i=0;i<data.length;i++) {
            sb.append(Integer.toString((data[i]&0xff)+0x100,16).substring(1));
         }
      } catch (NoSuchAlgorithmException e) {
         e.printStackTrace();
      }
      
      return sb.toString();
   }
   
}
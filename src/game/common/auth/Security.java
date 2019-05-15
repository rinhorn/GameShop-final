package game.common.auth;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Security {
   
   //일반 텍스트를 해시값(16진수값)으로 변환하여 반환하는 메서드 정의
   public static String textToHash(String password) {
      StringBuilder sb=new StringBuilder();
      try {
         MessageDigest md=MessageDigest.getInstance("SHA-256");
         
         md.update(password.getBytes());//해쉬화시킬 데이터를 바이트화(즉 쪼개서 넣어줘야 함)
         
         //암호화 된 바이트 반환받기
         byte[] data=md.digest();//일반 바이트배열을 암호화된 데이터로 반환
         //배열로 사용하기엔 무리가 있으므로 다시 스트링화 시키자
         for(int i=0;i<data.length;i++) {
            sb.append(Integer.toString((data[i]&0xff)+0x100,16).substring(1));
         }
      } catch (NoSuchAlgorithmException e) {
         e.printStackTrace();
      }
      
      return sb.toString();
   }
   
}
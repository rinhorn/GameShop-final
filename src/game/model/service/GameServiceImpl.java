package game.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import game.common.exception.DataNotFoundException;
import game.common.exception.DeleteFailException;
import game.common.exception.EditFailException;
import game.common.exception.RegistFailException;
import game.model.domain.Comments;
import game.model.domain.Game;
import game.model.domain.Game_Img;
import game.model.repository.CommentsDAO;
import game.model.repository.GameDAO;
import game.model.repository.Game_ImgDAO;
import game.model.repository.Sales_DetailDAO;

@Service
public class GameServiceImpl implements GameService {
   @Autowired
   private GameDAO gameDAO;
   @Autowired
   private Game_ImgDAO game_imgDAO;
   @Autowired
   private CommentsDAO commentsDAO;
   @Autowired
   private Sales_DetailDAO sales_DetailDAO;

   public void registGame(Game game, String[] myFile_name) throws RegistFailException {
      int result1 = 0;
      int result2 = 0;

      result1 = gameDAO.insert(game);
      if (result1 == 0) {
         throw new RegistFailException("게임 등록 실패");
      } else {
         for (int i = 0; i < myFile_name.length; i++) {
            Game_Img game_img = new Game_Img();
            game_img.setGame(game);
            game_img.setImg_filename(myFile_name[i]);
            result2 = game_imgDAO.insert(game_img);
            if (result2 == 0) {
               throw new RegistFailException("게임 이미지 등록 실패");
            }
         }
      }
   }

   public List selectAllGames() {
      return gameDAO.selectAll();
   }

   public Game selectGame(int game_id) throws DataNotFoundException {
      Game game = gameDAO.select(game_id);
      if (game == null) {
         throw new DataNotFoundException("게임 조회 실패");
      }
      return game;
   }

   public void editGame(Game game) throws EditFailException {
      int result = 0;
      result = gameDAO.update(game);
      if (result == 0) {
         throw new EditFailException("게임 정보 수정 실패");
      }
   }

   public void editAllGames(Game game, String[] myFile_name)
         throws DeleteFailException, RegistFailException, EditFailException {
      int result1 = 0;
      int result2 = 0;
      int result3 = 0;
      result1 = game_imgDAO.delete(game.getGame_id());
      if (result1 == 0) {
         throw new DeleteFailException("게임 이미지 삭제 실패");
      } else {
         for (int i = 0; i < myFile_name.length; i++) {
            Game_Img game_img = new Game_Img();
            game_img.setGame(game);
            game_img.setImg_filename(myFile_name[i]);
            result2 = game_imgDAO.insert(game_img);
            if (result2 == 0) {
               throw new RegistFailException("게임 이미지 등록 실패");
            } else {
               result3 = gameDAO.update(game);
               if (result3 == 0) {
                  throw new EditFailException("게임 정보 수정 실패");
               }
            }
         }
      }
   }

   public void deleteGame(int game_id) throws DeleteFailException {
      int result1 = 0;
      int result2 = 0;

      result1 = game_imgDAO.delete(game_id);
      if (result1 == 0) {
         throw new DeleteFailException("게임 이미지 삭제 실패");
      } else {
         result2 = gameDAO.delete(game_id);
         if (result2 == 0) {
            throw new DeleteFailException("게임 삭제 실패");
         }
      }
   }

   public Game searchGame(String game_name) {
      return gameDAO.search(game_name);
   }

   public List selectGameImg(int game_id) {
      return game_imgDAO.selectImg(game_id);
   }

   public List selectGameByName() {
      return gameDAO.selectByName();
   }

   public List selectGameByPrice() {
      return gameDAO.selectByPrice();
   }

   public List selectGameByRegdate() {
      return gameDAO.selectByRegdate();
   }

   public List selectGameByCategory(int category_id) {
      return gameDAO.selectByCategory(category_id);
   }

   public List selectGameByCategoryName(int category_id) {
      return gameDAO.selectByCategoryName(category_id);
   }

   public List selectGameByCategoryPrice(int category_id) {
      return gameDAO.selectByCategoryPrice(category_id);
   }

   public List selectGameByCategoryRegdate(int category_id) {
      return gameDAO.selectByCategoryRegdate(category_id);
   }

   public void registComment(Comments comments) throws RegistFailException {
      int result = commentsDAO.insert(comments);
      if (result == 0) {
         throw new RegistFailException("코멘트 등록 실패");
      }
   }

   public List selectAllComments(int game_id) throws DataNotFoundException {
      List coList = commentsDAO.selectAllByGame(game_id);
      if (coList == null) {
         throw new DataNotFoundException("코멘트 조회 실패");
      }
      return coList;
   }
   
   public List selectGameBySales() {
      return sales_DetailDAO.selectAll();
   }
   
   public int countGame(int game_id) {
      return sales_DetailDAO.countGame(game_id);
   }

	public void editComment(Comments comments) {
		int result=commentsDAO.update(comments);
		if (result==0) {
			throw new DataNotFoundException("댓글 수정 실패");
		}
	}
	
	public void deleteComment(int comments_id) {
		int result=commentsDAO.delete(comments_id);
		if (result==0) {
			throw new DataNotFoundException("댓글 삭제 실패");
		}
	} 
	
}
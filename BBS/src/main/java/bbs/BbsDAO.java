package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID= "root";
			String dbPassword = "0000";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//현재 시간을 가져오는 함수
	public String getDate() {
		//현재 시간을 가져오는 sql문장
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				return rs.getString(1); //현재 시간 반환
			}
		} catch (Exception e){

			e.printStackTrace();
		}
		//데이터베이스 오류
		return ""; 
	}
	
	//게시글 번호 가져오는 함수
	public int getNext(){ 
		//게시글 번호는 1번부터 올라가므로 내림차순으로 들고와서 +1해 주는 방식을 사용
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
				
			if(rs.next()){
				//마지막 게시글 번호에 +1
				return rs.getInt(1) + 1;
			}
			//첫번째 게시물인 경우
			return 1;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		//데이터베이스 오류
		return -1; 
	}
		
	//실제로 글을 작성하는 write함수 
	public int write(String bbsTitle, String userID, String bbsContent) { 
		//BBS 테이블에 들어갈 인자 6개를 ?로 선언 
		String SQL = "INSERT INTO BBS VALUES(?, ?, ?, ?, ?, ?)";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6,1); //글이 처음 작성되었을때 보여지는 형태 => 1
			
			return pstmt.executeUpdate();
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		//데이터베이스 오류
		return -1; 
	}

	//글 목록을 가져오는 함수
	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ?  AND bbsAvailable = 1 OREDR BY bbsID DESC LIMIT 10"; 
		//bbsID가 특정조건보다 작을때, Available=1 또는 내림차순으로 10개까지 제한해서 나타냄
		ArrayList<Bbs> list = new ArrayList<Bbs>();
			
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
				
			while(rs.next()) { //값이 존재할동안,
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				    
				list.add(bbs);
			} 		
		} catch(Exception e) {
				e.printStackTrace();
		}
		
		return list;
		}
	
	//페이지 처리하는 함수
	public boolean nextPage(int pageNumber){
		String SQL = "SELECT * FROM BBS WHERE bbsID < ?  AND bbsAvailable = 1"; 
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			
			if(rs.next()) { //값이 존재한다면
				//다음으로 넘어갈 수 있는 true
				return true;
			} 		
		} catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	
	//하나의 글 내용을 불러오는 함수
	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?"; 
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID); // bbsID에 해당하는 게시글을 가져옴
			rs = pstmt.executeQuery();
			
			if(rs.next()) { 
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			} 		
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
		
		
	}
}

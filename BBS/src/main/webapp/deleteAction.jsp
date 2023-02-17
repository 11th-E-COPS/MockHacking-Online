<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.io.PrintWriter"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시판 웹사이트</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null){//세션이 존재하는 회원들 
			userID = (String) session.getAttribute("userID");//유저아이디에 해당 세션값을 넣는다.
		}
		
		if (userID == null){ //로그인이 안 된 경우 => 글쓰기 x
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} 
		 int bbsID = 0;
		    if (request.getParameter("bbsID") != null) {
		    	bbsID = Integer.parseInt(request.getParameter("bbsID"));
		    }
		    if(bbsID == 0) {
		    	PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'bbs.jsp'");
				script.println("</script>");
		    }
		    Bbs bbs = new BbsDAO().getBbs(bbsID);
		    if(!userID.equals(bbs.getUserID())){
		    	PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('권한이 없습니다.')");
				script.println("location.href = 'bbs.jsp'");
				script.println("</script>");
		    } else {
					BbsDAO BbsDAO = new BbsDAO();
					int result = BbsDAO.delete(bbsID);
				
					//함수에 반환된 값이 -1이면 오류 발생 경우
					if (result == -1) {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글 삭제에 실패했습니다')");
						script.println("history.back()");
						script.println("</script>");
					} 
					else {
						//글수정에 성공한 경우
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("location.href='bbs.jsp'");
						script.println("</script>");
					}
				}
	%>
</body>
</html>
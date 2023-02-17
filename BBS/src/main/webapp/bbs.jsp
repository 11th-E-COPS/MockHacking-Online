<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1" >  
<link rel="stylesheet" href="css/bootstrap.css"> 
<link rel="stylesheet" href="css/custom.css">

<title>JSP 게시판 웹 사이트</title>
<style type = "text/css"></style>
</head>
<body>
<%
    String userID = null; 
    if (session.getAttribute("userID") != null){
        userID = (String)session.getAttribute("userID");
        //로그인이 된 화원의 로그인 정보를 담게 설정
    }
    
    //기본적으로 1페이지부터 시작
    int pageNumber = 1; 
	if(request.getParameter("pageNumber") != null){
		pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
	}
 
%>
    <nav class ="navbar navbar-default">
    
        <div class="navbar-header"> 
        
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expand="false">
                <span class ="icon-bar"></span>
                <span class ="icon-bar"></span>
                <span class ="icon-bar"></span>
            </button>
            
            <a class ="navbar-brand" href="main.jsp">JSP 게시판</a>
        </div>
        
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
           
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li>
                <li class="active"><a href="bbs.jsp">게시판</a></li>
            </ul>
            
            <%
                // 로그인이 되어있지 않은 경우
                if(userID == null){
            %>
            
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" aria-haspopup="true"
                    aria-expanded="false">접속하기<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="join.jsp">회원가입</a></li>                    
                    </ul>
                </li>
            </ul>
            
            <%
            // 로그인이 되어있는 경우
                } else {
            %>
            <ul class="nav navbar-nav navbar-right">
                <li class="dropdown">
                <a href="#" class = "dropdown-toggle"
                    data-toggle="dropdown" role ="button" aria-haspopup="true"
                    aria-expanded="false">회원관리<span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="loginAction.jsp">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
            
            <%
                }
            %>
        </div>
        
    </nav>
   
    <div class="container">
        <div class="row">
        
         	
            <table class="table table-striped" style="text-align:center; border:1px solid #dddddd">
                
                
                <thead>
                    <tr>
                        <th style="background-color:#eeeeee; text-align:center;">번호</th>
                        <th style="background-color:#eeeeee; text-align:center;">제목</th>
                        <th style="background-color:#eeeeee; text-align:center;">작성자</th>
                        <th style="background-color:#eeeeee; text-align:center;">작성일</th>
                    </tr>
                </thead>
           
                <tbody>
                <% 
                   BbsDAO bbsDAO = new BbsDAO();
				   ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
				   for(int i=0; i<list.size(); i++){		      
                %>
                <tr>
                    <td><%= list.get(i).getBbsID() %></td>  
					<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td>
					<td><%= list.get(i).getUserID() %></td>
					<td><%= list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11, 13) + "시 " + list.get(i).getBbsDate().substring(14, 16) + "분 " %></td>
	            </tr>   
              	<%
				   }
              	%>
                </tbody>
            </table>
            <%
               if(pageNumber != 1){
            %>
               <a href="bbs.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arrow-left">이전</a>
            
            <% 
               } if(bbsDAO.nextPage(pageNumber + 1)) {
            %>
                 <a href="bbs.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arrow-left">다음</a>
            <%
                 }
            %>       
            <a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
        </div>    
    </div>
    
    <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script> 
    
</body>
</html>

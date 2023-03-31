<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>AddParty</title>
    <link rel="stylesheet" href="/resources/css/style.css" type="text/css">
</head>
<body>
<div class="navColor">
    <div class="size2">

        <div class="header-margin">
            <div class="roboto">
                <nav class="header-nav">

                    <a class="ssilka" href="<c:url value="/Party"/>"> Группы</a>
                    <a class="ssilka" href="<c:url value="/Student"/>">Студенты</a>
                    <a class="ssilka" href="<c:url value="/Subject"/>">Предметы</a>
                    <a class="ssilka" href="<c:url value="/Teacher"/>">Учителя</a>
                    <div class="dropdown">
                        <button class="dropbtn">${pageContext.request.userPrincipal.name}</button>
                        <div class="dropdown-content">
                            <form:form method="POST" action="/logout">
                                <button type="submit" class="logbtn">Выйти из аккаунта</button>
                            </form:form>

                        </div>
                    </div>


                </nav>
            </div>
        </div>
    </div>
</div>
</body>
</html>

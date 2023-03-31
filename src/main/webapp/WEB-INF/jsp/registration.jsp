<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<html>
<head>
    <meta charset="utf-8">
    <title>Registration</title>
    <link rel="stylesheet" href="/resources/css/style.css" type="text/css">
</head>
<body>
<div class="size1">
    <div class="navColor">
        <div class="size2">
            <div class="header-margin">
                <div class="roboto">
                    <nav class="header-nav">
                        <label>Регистрация</label>
                    </nav>
                </div>
            </div>
        </div>
    </div>

    <div class="size2">
        <form:form action="${pageContext.request.contextPath}/registration" method="post" class="form"
                   modelAttribute="userForm">
            <div>
                <input type="text" name="username" path="username" id="username" placeholder="Введите логин"/>
                    ${usernameError}
            </div>
            <div>
                <input type="password" name="password" path="password" id="password" placeholder="введите пароль"/>
                <errors path="password"></errors>
                    ${passwordError}
                <div>
                    <select name="role" id="role" class="selectCSS">
                        <option value='USER'>Ученик</option>
                        <option value='ADMIN'>Учитель</option>
                    </select>
                </div>
            </div>
            <button type="submit" class="btn">Добавить</button>
        </form:form>
        <a class="ssilka" href="<c:url value="/login"/>"> Назад</a>
    </div>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>
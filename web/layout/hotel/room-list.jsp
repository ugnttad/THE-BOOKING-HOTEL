<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Room" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    List<Room> rooms = (List<Room>) request.getAttribute("hotelRooms");
%>

<!-- Availability -->
<div class="border-bottom pb-2 mb-4" id="availability">
    <h5 class="mb-3 fs-18">Availability</h5>
    <div class="hotel-list">
        <c:forEach var="room" items="<%=rooms%>">
            <c:set var="currentRoom" value="${room}" scope="request" />
            <%@ include file="room-component.jsp" %>
        </c:forEach>
    </div>
</div>
<!-- /Availability -->
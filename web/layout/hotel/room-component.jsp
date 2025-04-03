<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="model.Room" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>

<%
    Room currentRoom = (Room) request.getAttribute("currentRoom");
    Map<Integer, List<Room>> selectedRooms = (Map<Integer, List<Room>>) session.getAttribute("selectedRooms");

    boolean isChecked = false;
    if (selectedRooms != null) {
        for (List<Room> roomList : selectedRooms.values()) {
            for (Room room : roomList) {
                if (room.getRoomId() == currentRoom.getRoomId()) {
                    isChecked = true;
                    break;
                }
            }
        }
    }

    // Parse RoomImageURLs
    ObjectMapper objectMapper = new ObjectMapper();
    List<String> roomImageUrls = new ArrayList<>();
    try {
        roomImageUrls = objectMapper.readValue(currentRoom.getRoomImageURLs(), List.class);
    } catch (Exception e) {
        // Nếu parse lỗi (JSON không hợp lệ hoặc null), để rỗng
        roomImageUrls.add("assets/img/hotels/hotel-02.jpg"); // Ảnh mặc định
    }
    request.setAttribute("roomImageUrls", roomImageUrls); // Đặt vào request để dùng JSTL
%>

<div class="place-item mb-4">
    <div class="place-img">
        <a href="hotel-details.html">
            <c:choose>
                <c:when test="${not empty roomImageUrls}">
                    <img src="${roomImageUrls[0]}" class="img-fluid" alt="Room Image">
                </c:when>
                <c:otherwise>
                    <img src="assets/img/hotels/hotel-02.jpg" class="img-fluid" alt="Default Room Image">
                </c:otherwise>
            </c:choose>
        </a>
        <div class="fav-item justify-content-end">
            <a href="javascript:void(0);" class="fav-icon">
                <i class="isax isax-heart5"></i>
            </a>
        </div>
    </div>
    <div class="place-content pb-1">
        <div class="d-flex align-items-center justify-content-between flex-wrap">
            <div class="overflow-hidden">
                <h5 class="mb-2 d-inline-flex align-items-center text-truncate"><%= currentRoom.getRoomTypeName()%></h5>
            </div>
        </div>
        <div class="d-flex align-items-center flex-wrap mb-2">
            <% if (currentRoom.isAvailable()) { %>
            <span class="badge badge-soft-success fs-10 fw-medium rounded-pill me-2 mb-2">Available</span>
            <% } else { %>
            <span class="badge badge-soft-danger fs-10 fw-medium rounded-pill me-2 mb-2">Unavailable</span>
            <% }%>
            <span class="badge badge-info-100 fs-10 fw-medium rounded-pill me-2 mb-2">Capacity: <%= currentRoom.getCapacity()%></span>
        </div>
        <div class="d-flex align-items-center justify-content-between flex-wrap border-top pt-3">
            <h5 class="text-primary me-2 mb-3">$<%= currentRoom.getPricePerNight()%> <span class="fs-14 fw-normal text-default">/ Night</span></h5>
            <div class="d-flex align-items-center">
                <a href="#" data-bs-toggle="modal" data-bs-target="#room-details<%= currentRoom.getRoomId() %>" class="fs-14 link-primary text-decoration-underline me-3 mb-3">View Room Details</a>
                <div class="btn btn-primary btn-md mb-3">
                    <div class="form-check d-flex align-items-center ps-0">
                        <input 
                            class="form-check-input ms-0 mt-0 border border-white" 
                            name="book" 
                            type="checkbox" 
                            id="book<%= currentRoom.getRoomId()%>"
                            <% if (!currentRoom.isAvailable()) { %> disabled <% } %>
                            <% if (isChecked && user != null) { %> checked <% }%>
                            onclick="handleRoomSelection(<%= currentRoom.getRoomId()%>)">
                        <label class="form-check-label fs-13 text-white ms-2" for="book<%= currentRoom.getRoomId()%>">Select Room</label>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Room Details -->
<c:set var="room" value="${currentRoom}" scope="request" />
<%@ include file="room-details-modal.jsp" %>
<!-- /Room Details -->

<script>
    function handleRoomSelection(roomId) {
        var isLoggedIn = <%= (session.getAttribute("user") != null) ? "true" : "false"%>;

        if (!isLoggedIn) {
            alert("You must login to select room!");
            event.preventDefault();
            event.target.checked = false;
            return;
        }

        var isChecked = event.target.checked;
        var hotelId = <%= currentRoom.getHotelId()%>;

        fetch("updateSelectedRoom?roomId=" + roomId + "&selected=" + isChecked + "&hotelId=" + hotelId, {
            method: "GET"
        }).then(response => response.text()).then(data => {
            console.log(data);
            location.reload();
        }).catch(error => console.error('Lỗi:', error));
    }
</script>
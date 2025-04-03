<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="model.RoomFacility" %>
<%@ page import="model.Room" %>
<%@ page import="dao.RoomFacilityDAO" %>
<%@ page import="java.util.List" %>

<%
    Room room = (Room) request.getAttribute("room");
    RoomFacilityDAO roomFacilitydao = new RoomFacilityDAO();
    List<RoomFacility> facilities = roomFacilitydao.getRoomFacilitiesByRoomId(room.getRoomId());
%>

<!-- Room Details -->
<div class="modal fade" id="room-details">
    <div class="modal-dialog modal-dialog-centered modal-md">
        <div class="modal-content">
            <div class="modal-header d-flex align-items-center justify-content-between">
                <h5>Room Details</h5>
                <a href="javascript:void(0);" data-bs-dismiss="modal" aria-label="Close">
                    <i class="ti ti-x fs-16"></i>
                </a>
            </div>
            <div class="modal-body pb-2">
                <div class="owl-carousel room-slider nav-center mb-4">
                    <div class="service-img">
                        <img src="assets/img/hotels/hotel-large-01.jpg" class="img-fluid" alt="Slider Img">
                    </div>
                    <div class="service-img">
                        <img src="assets/img/hotels/hotel-large-02.jpg" class="img-fluid" alt="Slider Img">
                    </div>
                    <div class="service-img">
                        <img src="assets/img/hotels/hotel-large-03.jpg" class="img-fluid" alt="Slider Img">
                    </div>
                    <div class="service-img">
                        <img src="assets/img/hotels/hotel-large-04.jpg" class="img-fluid" alt="Slider Img">
                    </div>
                    <div class="service-img">
                        <img src="assets/img/hotels/hotel-large-05.jpg" class="img-fluid" alt="Slider Img">
                    </div>
                    <div class="service-img">
                        <img src="assets/img/hotels/hotel-large-06.jpg" class="img-fluid" alt="Slider Img">
                    </div>
                </div>
                <div class="d-flex align-items-center justify-content-between flex-wrap row-gap-2 mb-4">
                    <div>
                        <h5 class="mb-1"><%=room.getRoomTypeName()%></h5>
                    </div>
                    <h5 class="text-primary">$<%=room.getPricePerNight()%> <span class="fs-14 fw-normal text-default">/ Night</span></h5>
                </div>
                <div class="mb-4">
                    <h6 class="mb-2">Description</h6>
                    <p>${currentRoom.getRoomDescription()}</p>
                </div>
                <div class="mb-0">
                    <h6 class="mb-2">Amenities</h6>
                    <div class="row">
                        <div class="col-lg-12">
                            <c:forEach var="facility" items="<%=facilities%>">
                                <p class="mb-2 d-flex align-items-center"><i class="isax isax-tick-circle5 text-success me-2"></i>${facility.getFacilityName()}</p>        
                                </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- /Room Details -->
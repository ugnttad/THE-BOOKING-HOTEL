<%@ page import="java.util.List" %>
<%@ page import="dao.RoomTypeDAO" %>
<%@ page import="dao.RoomFacilityDAO" %>
<%@ page import="model.RoomType" %>
<%@ page import="model.RoomFacility" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
    List<RoomType> roomTypes = roomTypeDAO.getTop5BookedRoomTypes();

    RoomFacilityDAO roomFacilityDAO = new RoomFacilityDAO();
    List<RoomFacility> roomFacilities = roomFacilityDAO.getTop5RoomFacilities();
%>

<!-- Sidebar -->
<div class="col-xl-3 col-lg-4 theiaStickySidebar">
    <div class="card filter-sidebar mb-4 mb-lg-0">
        <div class="card-header d-flex align-items-center justify-content-between">
            <h5>Filters</h5>
        </div>
        <div class="card-body p-0">
            <form id="filterForm" method="POST" action="${pageContext.request.contextPath}/filter-hotels">
                <div class="p-3 border-bottom">
                    <label class="form-label fs-16">Search by Hotel Name</label>
                    <div class="input-icon">
                        <span class="input-icon-addon">
                            <i class="isax isax-search-normal"></i>
                        </span>
                        <input name="hotelName" type="text" class="form-control" placeholder="Search by Hotel Name">
                    </div>
                </div>
                <div class="accordion accordion-list">
                    <div class="accordion-item border-bottom p-3">
                        <div class="accordion-header">
                            <div class="accordion-button p-0" data-bs-toggle="collapse" data-bs-target="#accordion-roomtypes" 
                                 aria-expanded="true" aria-controls="accordion-roomtypes" role="button">
                                <i class="isax isax-buildings me-2 text-primary"></i>Room Types
                            </div>
                        </div>
                        <div id="accordion-roomtypes" class="accordion-collapse collapse show">
                            <div class="accordion-body">
                                <div class="more-content">
                                    <%
                                        for (int i = 0; i < roomTypes.size(); i++) {
                                            RoomType roomType = roomTypes.get(i);
                                    %>
                                    <div class="form-check d-flex align-items-center ps-0 mb-2">
                                        <input class="form-check-input ms-0 mt-0" name="roomType" type="checkbox" id="room<%= i + 1%>" value="<%= roomType.getRoomTypeName()%>">
                                        <label class="form-check-label ms-2" for="room<%= i + 1%>">
                                            <%= roomType.getRoomTypeName()%>
                                        </label>
                                    </div>
                                    <% }%>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item border-bottom p-3">
                        <div class="accordion-header">
                            <div class="accordion-button p-0" data-bs-toggle="collapse" data-bs-target="#accordion-amenity" aria-expanded="true" aria-controls="accordion-amenity" role="button">
                                <i class="isax isax-candle me-2 text-primary"></i>Amenities
                            </div>
                        </div>
                        <div id="accordion-amenity" class="accordion-collapse collapse show">
                            <div class="accordion-body">
                                <div class="more-content">
                                    <%
                                        for (int i = 0; i < roomFacilities.size(); i++) {
                                            RoomFacility roomFacility = roomFacilities.get(i);
                                    %>
                                    <div class="form-check d-flex align-items-center ps-0 mb-2">
                                        <input class="form-check-input ms-0 mt-0" name="facilities" type="checkbox" id="facility<%= i + 1%>" value="<%= roomFacility.getFacilityName()%>">
                                        <label class="form-check-label ms-2" for="room<%= i + 1%>">
                                            <%= roomFacility.getFacilityName()%>
                                        </label>
                                    </div>
                                    <% }%>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item border-bottom p-3">
                        <div class="accordion-header">
                            <div class="accordion-button p-0" data-bs-toggle="collapse" data-bs-target="#accordion-meal" aria-expanded="true" aria-controls="accordion-meal" role="button">
                                <i class="isax isax-reserve me-2 text-primary"></i>Meal plans available
                            </div>
                        </div>
                        <div id="accordion-meal" class="accordion-collapse collapse show">
                            <div class="accordion-body pt-2">
                                <div class="form-checkbox form-check form-check-inline d-inline-flex align-items-center mt-2 me-2">
                                    <input class="form-check-input ms-0 mt-0" name="mealPlans" type="checkbox" id="meals1" value="All inclusive">
                                    <label class="form-check-label ms-2" for="meals1">
                                        All inclusive
                                    </label>
                                </div>
                                <div class="form-checkbox form-check form-check-inline d-inline-flex align-items-center mt-2 me-2">
                                    <input class="form-check-input ms-0 mt-0" name="mealPlans" type="checkbox" id="meals2" value="Breakfast">
                                    <label class="form-check-label ms-2" for="meals2">
                                        Breakfast
                                    </label>
                                </div>
                                <div class="form-checkbox form-check form-check-inline d-inline-flex align-items-center mt-2 me-2">
                                    <input class="form-check-input ms-0 mt-0" name="mealPlans" type="checkbox" id="meals3" value="Lunch">
                                    <label class="form-check-label ms-2" for="meals3">
                                        Lunch
                                    </label>
                                </div>
                                <div class="form-checkbox form-check form-check-inline d-inline-flex align-items-center mt-2 me-2">
                                    <input class="form-check-input ms-0 mt-0" name="mealPlans" type="checkbox" id="meals4" value="Dinner">
                                    <label class="form-check-label ms-2" for="meals4">
                                        Dinner
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-item border-bottom p-3">
                        <div class="accordion-header">
                            <div class="accordion-button p-0" data-bs-toggle="collapse" data-bs-target="#accordion-brands" aria-expanded="true" aria-controls="accordion-brands" role="button">
                                <i class="isax isax-discount-shape me-2 text-primary"></i>Reviews
                            </div>
                        </div>
                        <div id="accordion-brands" class="accordion-collapse collapse show">
                            <div class="accordion-body">
                                <div class="form-check d-flex align-items-center ps-0 mb-2">
                                    <input class="form-check-input ms-0 mt-0" name="minRating" type="radio" id="review5" value="5">
                                    <label class="form-check-label ms-2" for="review1">
                                        <span class="rating d-flex align-items-center">
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary"></i>
                                            <span class="ms-2">5 Star</span>
                                        </span>
                                    </label>
                                </div>
                                <div class="form-check d-flex align-items-center ps-0 mb-2">
                                    <input class="form-check-input ms-0 mt-0" name="minRating" type="radio" id="review4" value="4">
                                    <label class="form-check-label ms-2" for="review2">
                                        <span class="rating d-flex align-items-center">
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary"></i>
                                            <span class="ms-2">4 Star</span>
                                        </span>
                                    </label>
                                </div>
                                <div class="form-check d-flex align-items-center ps-0 mb-2">
                                    <input class="form-check-input ms-0 mt-0" name="minRating" type="radio" id="review3" value="3">
                                    <label class="form-check-label ms-2" for="review3">
                                        <span class="rating d-flex align-items-center">
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary"></i>
                                            <span class="ms-2">3 Star</span>
                                        </span>
                                    </label>
                                </div>
                                <div class="form-check d-flex align-items-center ps-0 mb-2">
                                    <input class="form-check-input ms-0 mt-0" name="minRating" type="radio" id="review2" value="2">
                                    <label class="form-check-label ms-2" for="review4">
                                        <span class="rating d-flex align-items-center">
                                            <i class="fas fa-star filled text-primary me-1"></i>
                                            <i class="fas fa-star filled text-primary"></i>
                                            <span class="ms-2">2 Star</span>
                                        </span>
                                    </label>
                                </div>
                                <div class="form-check d-flex align-items-center ps-0 mb-0">
                                    <input class="form-check-input ms-0 mt-0" name="minRating" type="radio" id="review1" value="1">
                                    <label class="form-check-label ms-2" for="review5">
                                        <span class="rating d-flex align-items-center">
                                            <i class="fas fa-star filled text-primary"></i>
                                            <span class="ms-2">1 Star</span>
                                        </span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <button class="btn btn-primary search-btn rounded" type="submit">Search</button>
            </form>
        </div>
    </div>
</div>
<!-- /Sidebar -->
<%@page import="java.util.Map"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="model.Room" %>
<%@ page import="model.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>

<%
    Map<Integer, List<Room>> selectedRooms = (Map<Integer, List<Room>>) session.getAttribute("selectedRooms");
    User provider = UserDAO.getUserByUserId(currentHotel.getHotelAgentId());
    List<Room> selectedRoomsForCurrentHotel = selectedRooms != null ? selectedRooms.get(currentHotel.getHotelId()) : null;
%>

<!-- Sidebar Details -->
<div class="col-xl-4 theiaStickySidebar">

    <% if (user != null && !selectedRoomsForCurrentHotel.isEmpty()) {%>
    <!-- Availability -->
    <div class="card shadow-none">
        <div class="card-body">

            <div id="availability-message" class="alert alert-danger d-none"></div>

            <div class="banner-form">
                <form id="bookingForm" onsubmit="return false;">
                    <div class="form-info border-0">
                        <div class="form-item border rounded p-3 mb-3 w-100">
                            <label class="form-label fs-14 text-default mb-0">Check In</label>
                            <input type="date" class="form-control datetimepicker" id="checkInDate" name="checkInDate">
                            <p class="fs-12">Monday</p>
                        </div>
                        <div class="form-item border rounded p-3 mb-3 w-100">
                            <label class="form-label fs-14 text-default mb-0">Check Out</label>
                            <input type="date" class="form-control datetimepicker" id="checkOutDate" name="checkOutDate">
                            <p class="fs-12">Monday</p>
                        </div>
                        <div class="card shadow-none mb-3">
                            <div class="card-body p-3 pb-0">
                                <div class="border-bottom pb-2 mb-2">
                                    <h6>Details</h6>
                                </div>
                                <c:forEach var="room" items="<%=selectedRoomsForCurrentHotel%>">
                                    <div class="mb-3 d-flex align-items-center justify-content-between selected-room" data-room-id="${room.roomId}" id="room-${room.roomId}">
                                        <label class="form-label text-gray-9 mb-0">${room.roomTypeName}</label>
                                        <div class="custom-increment">
                                            <div class="input-group">
                                                <input disabled type="number" name="quantity" class="input-number" value="1">
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <% if (!selectedRoomsForCurrentHotel.isEmpty()) {%>
                    <input type="hidden" name="hotelId" value="<%= currentHotel.getHotelId()%>">
                    <button type="submit" class="btn btn-primary btn-lg search-btn ms-0 mb-3 w-100 fs-14">Book Now</button>

                    <% }%>
                </form>
            </div>
        </div>
    </div>
    <!-- /Availability -->
    <% } else if (user == null) { %>
    <!-- If the user is not logged in, display a message asking them to log in -->
    <div class="alert alert-warning" role="alert">
        You need to log in to book a room.
    </div>
    <% }%>

    <!-- Map -->
    <div class="card shadow-none" id="location">
        <div id="locationMap" style="height: 300px;"></div>
        <div class="card-body">
            <div class="mb-1 d-flex align-items-center justify-content-between flex-wrap">
                <p class="d-flex align-items-center mb-3"><i class="isax isax-location5 me-2"></i><%=currentHotel.getLocation()%></p>
            </div>
            <h5 class="mb-3 fs-18">Nearby Landmarks & Visits</h5>
            <!-- Các địa điểm nổi tiếng sẽ được hiển thị tại đây -->
            <div id="nearbyPlaces">
                <!-- Các địa điểm sẽ được thêm vào từ script -->
            </div>
        </div>
    </div>
    <!-- /Map -->

    <!-- Why Book With Us -->
    <div class="card shadow-none">
        <div class="card-body pb-0">
            <h5 class="mb-3 fs-18">Why Book With Us</h5>
            <div class="py-1">
                <p class="d-flex align-items-center mb-3"><i class="isax isax-medal-star text-primary me-2"></i>Expertise and Experience</p>
                <p class="d-flex align-items-center mb-3"><i class="isax isax-menu text-primary me-2"></i>Tailored Services</p>
                <p class="d-flex align-items-center mb-3"><i class="isax isax-message-minus text-primary me-2"></i>Comprehensive Planning</p>
                <p class="d-flex align-items-center mb-3"><i class="isax isax-user-add text-primary me-2"></i>Client Satisfaction</p>
                <p class="d-flex align-items-center mb-3"><i class="isax isax-grammerly text-primary me-2"></i>24/7 Support</p>
            </div>
        </div>
    </div>
    <!-- /Why Book With Us -->

    <!-- Provider Details -->
    <div class="card shadow-none mb-0">
        <div class="card-body">
            <h5 class="mb-3 fs-18">Provider Details</h5>
            <div class="py-1">
                <div class="bg-light-500 br-10 mb-3 d-flex align-items-center p-3">
                    <a href="javascript:void(0);" class="avatar avatar-lg flex-shrink-0">
                        <img src="<%=provider.getAvatarUrl()%>" alt="img" class="rounded-circle">
                    </a>
                    <div class="ms-2 overflow-hidden">
                        <h6 class="fw-medium text-truncate"><a href="javascript:void(0);"><%=provider.getFirstName()%> <%=provider.getLastName()%></a></h6>
                        <p class="fs-14">Member Since : 14 May 2024</p>
                    </div>
                </div>
                <div class="border br-10 mb-3 p-3">
                    <div class="d-flex align-items-center border-bottom pb-3 mb-3">
                        <span class="avatar avatar-sm me-2 rounded-circle flex-shrink-0 bg-primary"><i class="isax isax-call-outgoing5"></i></span>
                        <p>Call Us : <%=provider.getPhoneNumber()%></p>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="avatar avatar-sm me-2 rounded-circle flex-shrink-0 bg-primary"><i class="isax isax-message-search5"></i></span>
                        <p>Email : <%=provider.getEmail()%></p>
                    </div>
                </div>
            </div>
            <div class="row g-2">
                <div class="col-sm-12">
                    <a href="#" class="btn btn-primary d-flex align-items-center justify-content-center"><i class="isax isax-message-notif5 me-2"></i>Chat Now</a>
                </div>
            </div>
        </div>
    </div>
    <!-- /Provider Details -->

</div>
<!-- /Sidebar Details -->

<!-- Load Leaflet.js -->
<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

<script>
    document.getElementById("bookingForm").addEventListener("submit", function (event) {
    event.preventDefault();  // Ngăn form gửi yêu cầu GET mặc định

    const checkInDate = document.getElementById("checkInDate").value;
    const checkOutDate = document.getElementById("checkOutDate").value;
    const hotelId = document.querySelector("input[name='hotelId']").value;

    if (!checkInDate || !checkOutDate) {
        alert("Please select check-in and check-out dates.");
        return;
    }

    let formData = new FormData();
    formData.append("hotelId", hotelId);
    formData.append("checkInDate", checkInDate);
    formData.append("checkOutDate", checkOutDate);

    fetch(`/HotelBooking/booking`, {
        method: "POST",
        body: formData
    })
    .then(response => {
        if (response.redirected) {
            // Nếu controller trả về redirect, thực hiện điều hướng ngay
            window.location.href = response.url;
            return;
        }
        return response.json(); // Nếu có lỗi, parse JSON
    })
    .then(data => {
        if (data && data.error) {
            const messageBox = document.getElementById("availability-message");
            messageBox.classList.remove("d-none");
            messageBox.innerHTML = `<strong>Error:</strong> ${data.error}`;
            
            if (data.unavailableRooms) {
                data.unavailableRooms.forEach(roomId => {
                    const roomElement = document.getElementById(`room-${roomId}`);
                    if (roomElement) {
                        roomElement.remove();
                    }
                });
            }
        }
    })
    .catch(error => console.error("Error processing booking:", error));
});

    // Giả sử currentHotel.getLocation() chứa tên địa chỉ (ví dụ "Danang, Vietnam")
    var address = "<%= currentHotel.getLocation()%>";

    // Bước 1: Gọi Nominatim API để lấy tọa độ
    var nominatimUrl = "https://nominatim.openstreetmap.org/search?format=json&q=" + encodeURIComponent(address);

    fetch(nominatimUrl)
            .then(response => response.json())
            .then(data => {
                if (data && data.length > 0) {
                    var latitude = data[0].lat;
                    var longitude = data[0].lon;

                    // Bước 2: Sử dụng Overpass API để tìm các địa điểm nổi tiếng trong bán kính 20km
                    var overpassUrl = "https://overpass-api.de/api/interpreter?data=[out:json];(node(around:20000," + latitude + "," + longitude + ")[amenity=place_of_worship][name];node(around:20000," + latitude + "," + longitude + ")[tourism][name];node(around:20000," + latitude + "," + longitude + ")[historic][name];node(around:20000," + latitude + "," + longitude + ")[leisure][name];);out qt;";

                    fetch(overpassUrl)
                            .then(response => response.json())
                            .then(data => {
                                var places = data.elements;
                                var placeList = '';
                                var count = 0; // Đếm số lượng địa điểm

                                places.forEach(place => {
                                    if (place.tags.name && count < 7) { // Chỉ lấy địa điểm có tên và tối đa 7 địa điểm
                                        var name = place.tags.name;
                                        placeList += "<p><i class='isax isax-tick-circle me-2'></i>" + name + "</p>";
                                        count++;
                                    }
                                });

                                // Hiển thị các địa điểm nổi tiếng gần
                                document.getElementById('nearbyPlaces').innerHTML = placeList;

                                if (count === 0) {
                                    document.getElementById('nearbyPlaces').innerHTML = "<p>No landmarks found within 20km.</p>";
                                }
                            })
                            .catch(error => {
                                console.error('Error fetching places:', error);
                            });

                    // Hiển thị bản đồ tại vị trí khách sạn
                    var map = L.map('locationMap').setView([latitude, longitude], 13);
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                    }).addTo(map);

                    L.marker([latitude, longitude])
                            .addTo(map)
                            .bindPopup("Hotel Location: " + address);
                } else {
                    console.error("Không tìm thấy tọa độ cho địa chỉ: " + address);
                }
            })
            .catch(error => {
                console.error('Lỗi khi lấy tọa độ:', error);
            });

// Hàm kiểm tra phòng có sẵn
    function checkRoomAvailability(roomId, checkInDate, checkOutDate) {
        // Xây dựng query string an toàn
        const params = new URLSearchParams({
            roomId: roomId,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate
        });

        const url = `/HotelBooking/check-room-availability?` + params.toString();

        fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (!data.isAvailable) {
                        alert(`Room ${roomId} is not available for the selected dates.`);
                        removeRoomFromSelection(roomId); // Loại bỏ phòng khỏi UI và session
                    }
                })
                .catch(error => console.error("Error checking room availability:", error));
    }

// Xử lý khi người dùng thay đổi ngày check-in
    document.querySelector("#checkInDate").addEventListener("change", function () {
        const checkInDate = this.value;
        const checkOutDate = document.querySelector("#checkOutDate").value;
        if (checkOutDate) {
            checkAvailabilityForAllRooms(checkInDate, checkOutDate);

        }
    });

// Xử lý khi người dùng thay đổi ngày check-out
    document.querySelector("#checkOutDate").addEventListener("change", function () {
        const checkInDate = document.querySelector("#checkInDate").value;
        const checkOutDate = this.value;
        if (checkInDate) {
            checkAvailabilityForAllRooms(checkInDate, checkOutDate);

        }
    });

// Hàm kiểm tra tất cả các phòng đã chọn
    function checkAvailabilityForAllRooms(checkInDate, checkOutDate) {
        const selectedRooms = document.querySelectorAll(".selected-room");  // Các phòng được chọn
        selectedRooms.forEach(room => {
            const roomId = room.dataset.roomId;  // Lấy ID phòng từ thuộc tính data-room-id
            checkRoomAvailability(roomId, checkInDate, checkOutDate);
        });
    }

    function setMinDateForInput(inputElement, minDate) {
        // Chuyển đổi minDate thành chuỗi theo định dạng 'YYYY-MM-DD'
        const minDateString = minDate.toISOString().split('T')[0];
        inputElement.setAttribute("min", minDateString);  // Thiết lập min cho input date
        inputElement.setAttribute("value", minDateString);
    }

    document.addEventListener("DOMContentLoaded", function () {
        const checkInDateInput = document.querySelector("#checkInDate");
        const checkOutDateInput = document.querySelector("#checkOutDate");

        // Lấy ngày hiện tại
        const today = new Date();

        // Thiết lập ngày tối thiểu cho check-in (ngày hôm nay hoặc tương lai)
        setMinDateForInput(checkInDateInput, today);

        // Thiết lập ngày tối thiểu cho check-out (phải là ngày hôm sau check-in)
        const nextDay = new Date(today);
        nextDay.setDate(today.getDate() + 1);  // Tăng ngày hôm nay lên 1 ngày
        setMinDateForInput(checkOutDateInput, nextDay);
    });

</script>

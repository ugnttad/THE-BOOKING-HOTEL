<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">


    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Summernote JS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/summernote/summernote-lite.min.css">

        <!-- Select2 CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/select2/css/select2.min.css">
        <%@ include file="../../layout/head.jsp" %>

        <style>
            .gallery-preview img {
                max-width: 100px;
                margin: 5px;
            }
            .gallery-trash {
                cursor: pointer;
            }
        </style>
    </head>

    <body>

        <div class="main-header">
            <!-- Header -->
            <%@ include file="../../layout/header.jsp" %>
        </div>

        <!-- Breadcrumb -->
        <c:set var="name" value="Edit Hotel" scope="request" />
        <jsp:include page="../../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">
                ${error}
            </div>
        </c:if>
        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">
                <div class="tab-content">

                    <!-- Edit Hotel -->
                    <div class="tab-pane fade active show" id="edit_hotel" role="tabpanel">
                        <div class="row">
                            <div class="col-lg-3 theiaStickySidebar">
                                <div class="card border-0 mb-4 mb-lg-0">
                                    <div class="card-body">
                                        <h5 class="mb-3">Edit Hotel</h5>
                                        <ul class="add-tab-list">
                                            <li><a href="#basic_info" class="active">Basic Info</a></li>
                                            <li><a href="#location">Locations</a></li>
                                            <li><a href="#services">Hotel Services</a></li>
                                            <li><a href="#gallery">Gallery</a></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="mt-2">
                                    <a href="${pageContext.request.contextPath}/add-room?hotelId=${hotel.getHotelId()}" class="btn btn-primary d-inline-flex align-items-center me-0"><i class="isax isax-add me-1 fs-16"></i>Add Room</a>
                                </div>
                            </div>
                            <div class="col-lg-9">
                                <form action="${pageContext.request.contextPath}/edit-hotel" method="POST" enctype="multipart/form-data" id="editHotelForm">
                                    <input type="hidden" name="hotelId" value="${hotel.hotelId}">

                                    <div class="card shadow-none" id="basic_info">
                                        <div class="card-header">
                                            <h5 class="fs-18">Hotel Details</h5>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Hotel Name</label>
                                                        <input type="text" class="form-control" name="hotelName" value="${hotel.hotelName}" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Hotel Description</label>
                                                        <input type="text" class="form-control" name="hotelDescription" value="${hotel.description}" required>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card shadow-none" id="location">
                                        <div class="card-header">
                                            <h5 class="fs-18">Location</h5>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <div class="col-xl-3 col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Country</label>
                                                        <select class="form-select" id="country" name="country" required>
                                                            <option value="">Select</option>
                                                            <c:forEach var="country" items="${countries}">
                                                                <option value="${country.code}" ${country.code == hotelCountry ? 'selected' : ''}>${country.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-xl-3 col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">City</label>
                                                        <select class="form-select" id="city" name="city" required>
                                                            <option value="">Select</option>
                                                            <c:forEach var="city" items="${cities}">
                                                                <option value="${city}" ${city == hotelCity ? 'selected' : ''}>${city}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Address</label>
                                                        <input type="text" class="form-control" id="address" name="address" value="${hotelAddress}" required>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card shadow-none" id="services">
                                        <div class="card-header">
                                            <h5 class="fs-18">Services</h5>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <c:forEach var="service" items="${services}">
                                                    <div class="col-lg-4 col-md-6">
                                                        <div class="mb-3">
                                                            <div class="form-check d-flex align-items-center ps-0 mb-2">
                                                                <input class="form-check-input ms-0 mt-0" type="checkbox" id="service-${service.serviceId}" 
                                                                       name="serviceIds" value="${service.serviceId}" 
                                                                       ${hotelServices.contains(service.serviceId) ? 'checked' : ''}>
                                                                <label class="form-check-label ms-2" for="service-${service.serviceId}">
                                                                    ${service.serviceName}
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="card shadow-none" id="gallery">
                                        <div class="card-header">
                                            <h5 class="fs-18">Gallery</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="file-upload drag-file w-100 d-flex align-items-center justify-content-center flex-column mb-2">
                                                <span class="upload-img d-block mb-2"><i class="isax isax-document-upload fs-24"></i></span>
                                                <h6 class="mb-1">Upload Gallery Images</h6>
                                                <p class="mb-0">Upload Feature Image First, Image size should below 5MB</p>
                                                <input type="file" name="galleryImages" id="galleryImages" accept="image/*" multiple>
                                            </div>
                                            <div class="d-flex align-items-center flex-wrap" id="galleryPreview">
                                                <c:set var="imageUrls" value="${hotel.hotelImageURLs}" />
                                                <c:if test="${not empty imageUrls and fn:startsWith(imageUrls, '[') and fn:endsWith(imageUrls, ']')}">
                                                    <c:set var="cleanUrls" value="${fn:substring(imageUrls, 1, fn:length(imageUrls) - 1)}" />
                                                    <c:forEach var="url" items="${fn:split(cleanUrls, ',')}">
                                                        <c:set var="trimmedUrl" value="${fn:trim(fn:replace(url, '\"', ''))}" />
                                                        <img src="${trimmedUrl}" alt="Hotel Image" style="width: 100px; height: 100px; object-fit: cover; margin: 5px;">
                                                    </c:forEach>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-flex align-items-center justify-content-center">
                                        <button type="button" class="btn btn-light me-2" onclick="document.getElementById('editHotelForm').reset(); $('#galleryPreview').empty();">Reset</button>
                                        <button type="submit" class="btn btn-primary">Save Changes</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- /Edit Hotel -->

                    <div class="border-bottom pb-2 mb-4" id="availability">
                        <h5 class="mb-3 fs-18">Room List</h5>
                        <div class="hotel-list">
                            <c:forEach var="room" items="${rooms}">
                                <div class="place-item mb-4">
                                    <div class="place-img">
                                        <a href="hotel-details.html?roomId=${room.roomId}">
                                            <!-- Hiển thị ảnh đầu tiên từ roomImageURLs -->
                                            <c:set var="imageUrls" value="${room.roomImageURLs}" />
                                            <c:choose>
                                                <c:when test="${not empty imageUrls and fn:startsWith(imageUrls, '[') and fn:endsWith(imageUrls, ']')}">
                                                    <c:set var="cleanUrls" value="${fn:substring(imageUrls, 1, fn:length(imageUrls) - 1)}" />
                                                    <c:set var="firstImage" value="${fn:split(cleanUrls, ',')[0]}" />
                                                    <c:set var="firstImage" value="${fn:trim(fn:replace(firstImage, '\"', ''))}" />
                                                    <img src="${firstImage}" alt="${room.roomTypeName}" onerror="this.src='assets/img/hotels/default-room.jpg'">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="assets/img/hotels/default-room.jpg" alt="Default Room Image">
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </div>
                                    <div class="place-content pb-1">
                                        <div class="d-flex align-items-center justify-content-between flex-wrap">
                                            <div class="overflow-hidden">
                                                <h5 class="mb-2 d-inline-flex align-items-center text-truncate">${room.roomTypeName}</h5>
                                            </div>
                                        </div>
                                        <div class="d-flex align-items-center flex-wrap mb-2">
                                            <c:choose>
                                                <c:when test="${room.available}">
                                                    <span class="badge badge-soft-success fs-10 fw-medium rounded-pill me-2 mb-2">Available</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-soft-danger fs-10 fw-medium rounded-pill me-2 mb-2">Unavailable</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="badge badge-info-100 fs-10 fw-medium rounded-pill me-2 mb-2">Capacity: ${room.capacity}</span>
                                        </div>
                                        <div class="d-flex align-items-center justify-content-between flex-wrap border-top pt-3">
                                            <h5 class="text-primary me-2 mb-3">$${room.pricePerNight} <span class="fs-14 fw-normal text-default">/ Night</span></h5>
                                            <div class="d-flex align-items-center">
                                                <a href="${pageContext.request.contextPath}/edit-room?roomId=${room.getRoomId()}" class="btn btn-primary d-inline-flex align-items-center me-0">Edit Room</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                </div>
            </div>
        </div>
        <!-- /Page Wrapper -->

        <!-- Footer -->
        <%@ include file="../../layout/footer.jsp" %>
        <!-- /Footer -->   

        <!-- Cursor -->
        <%@ include file="../../layout/cursor.jsp" %>
        <!-- /Cursor -->

        <!-- Back to top -->
        <%@ include file="../../layout/back-to-top.jsp" %>

        <!-- Script -->
        <%@ include file="../../layout/script.jsp" %>

        <!-- Owlcarousel Js -->
        <script src="${pageContext.request.contextPath}/assets/plugins/owlcarousel/owl.carousel.min.js" type="dc5e5cc01351023b63d3df61-text/javascript"></script>

        <!-- Sticky Sidebar JS -->
        <script src="${pageContext.request.contextPath}/assets/plugins/theia-sticky-sidebar/ResizeSensor.js" type="dc5e5cc01351023b63d3df61-text/javascript"></script>
        <script src="${pageContext.request.contextPath}/assets/plugins/theia-sticky-sidebar/theia-sticky-sidebar.js" type="dc5e5cc01351023b63d3df61-text/javascript"></script>
        <!-- Summernote JS -->
        <script src="${pageContext.request.contextPath}/assets/plugins/summernote/summernote-lite.min.js" type="dc5e5cc01351023b63d3df61-text/javascript"></script>

        <!-- Select2 JS -->
        <script src="${pageContext.request.contextPath}/assets/plugins/select2/js/select2.min.js" type="dc5e5cc01351023b63d3df61-text/javascript"></script>

        <script>
                                            $(document).ready(function () {
                                                function loadCities(countryCode, selectedCity) {
                                                    if (countryCode) {
                                                        $.get('${pageContext.request.contextPath}/get-cities?country=' + countryCode, function (data) {
                                                            var $citySelect = $('#city');
                                                            $citySelect.empty().append('<option value="">Select</option>');
                                                            $.each(data, function (index, city) {
                                                                var isSelected = (city === selectedCity) ? 'selected' : '';
                                                                $citySelect.append('<option value="' + city + '" ' + isSelected + '>' + city + '</option>');
                                                            });
                                                            $citySelect.prop('disabled', false);
                                                        }).fail(function () {
                                                            $('#city').empty().append('<option value="">Select</option>').prop('disabled', true);
                                                        });
                                                    } else {
                                                        $('#city').empty().append('<option value="">Select</option>').prop('disabled', true);
                                                    }
                                                }

                                                // Load cities ban đầu dựa trên hotelCountry và hotelCity
                                                var initialCountry = $('#country').val();
                                                var initialCity = '${hotelCity}';
                                                if (initialCountry) {
                                                    loadCities(initialCountry, initialCity);
                                                }

                                                // Xử lý khi thay đổi country
                                                $('#country').change(function () {
                                                    var countryCode = $(this).val();
                                                    loadCities(countryCode, null); // Không chọn sẵn city khi thay đổi
                                                });

                                                $("#galleryImages").change(function () {
                                                    let files = this.files;
                                                    let preview = $("#galleryPreview");
                                                    preview.empty(); // Xóa preview cũ

                                                    for (let i = 0; i < files.length; i++) {
                                                        let file = files[i];
                                                        if (file.size > 5 * 1024 * 1024) { // Kiểm tra kích thước < 5MB
                                                            alert("Image " + file.name + " exceeds 5MB limit!");
                                                            continue;
                                                        }
                                                        let reader = new FileReader();
                                                        reader.onload = function (e) {
                                                            let img = $('<img>').attr('src', e.target.result).addClass('gallery-preview');
                                                            let trash = $('<span>').addClass('trash-icon d-flex align-items-center justify-content-center text-danger gallery-trash')
                                                                    .html('<i class="isax isax-trash"></i>')
                                                                    .click(function () {
                                                                        $(this).parent().remove();
                                                                    });
                                                            let container = $('<a>').addClass('gallery-upload-img me-2').append(img, trash);
                                                            preview.append(container);
                                                        };
                                                        reader.readAsDataURL(file);
                                                    }
                                                });
                                            });
        </script>
</html>
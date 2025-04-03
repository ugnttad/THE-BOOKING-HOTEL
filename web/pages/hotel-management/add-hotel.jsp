<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/summernote/summernote-lite.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/plugins/select2/css/select2.min.css">
        <%@ include file="../../layout/head.jsp" %>

        <style>
            .gallery-preview img {
                max-width: 100px;
                margin: 5px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }
            .gallery-trash {
                cursor: pointer;
                position: absolute;
                top: 5px;
                right: 5px;
                background: rgba(255, 0, 0, 0.7);
                border-radius: 50%;
                padding: 2px;
                color: white;
            }
            .gallery-upload-img {
                position: relative;
                display: inline-block;
            }
            .file-upload.drag-file {
                border: 2px dashed #ccc;
                padding: 20px;
                text-align: center;
                background: #f9f9f9;
            }
            .file-upload.drag-file.dragover {
                border-color: #007bff;
                background: #e9f4ff;
            }
        </style>
    </head>
    <body>
        <div class="main-header">
            <%@ include file="../../layout/header.jsp" %>
        </div>

        <c:set var="user" value="${sessionScope.user}" />
        <c:set var="name" value="${user.role.roleId == 3 ? 'Add New Hotel' : 'Register as Hotel Agent'}" scope="request" />
        <jsp:include page="../../layout/breadcrumb.jsp" />

        <c:if test="${not empty error}">
            <div class="alert alert-danger" role="alert">${error}</div>
        </c:if>

        <div class="content">
            <div class="container">
                <div class="tab-content">
                    <div class="tab-pane fade active show" id="add_hotel" role="tabpanel">
                        <div class="row">
                            <div class="col-lg-3 theiaStickySidebar">
                                <div class="card border-0 mb-4 mb-lg-0">
                                    <div class="card-body">
                                        <h5 class="mb-3">${user.role.roleId == 3 ? 'Add New Hotel' : 'Hotel Agent Registration'}</h5>
                                        <ul class="add-tab-list">
                                            <li><a href="#basic_info" class="active">Basic Info</a></li>
                                            <li><a href="#location">Location</a></li>
                                            <li><a href="#license">License</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-9">
                                <form action="${pageContext.request.contextPath}/add-hotel" method="POST" enctype="multipart/form-data" id="addHotelForm">
                                    <div class="card shadow-none" id="basic_info">
                                        <div class="card-header">
                                            <h5 class="fs-18">Hotel Details</h5>
                                        </div>
                                        <div class="card-body pb-1">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Hotel Name <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="hotelName" placeholder="Enter hotel name" required maxlength="100">
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Hotel Description <span class="text-danger">*</span></label>
                                                        <textarea class="form-control" name="hotelDescription" rows="3" placeholder="Describe your hotel" required></textarea>
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
                                                        <label class="form-label">Country <span class="text-danger">*</span></label>
                                                        <select class="form-select" id="country" name="country" required>
                                                            <option value="">Select a country</option>
                                                            <c:forEach var="country" items="${countries}">
                                                                <option value="${country.code}">${country.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-xl-3 col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">City <span class="text-danger">*</span></label>
                                                        <select class="form-select" id="city" name="city" disabled required>
                                                            <option value="">Select a city</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="mb-3">
                                                        <label class="form-label">Address <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="address" name="address" placeholder="Enter full address" required maxlength="200">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card shadow-none" id="license">
                                        <div class="card-header">
                                            <h5 class="fs-18">Business License</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="file-upload drag-file w-100 d-flex align-items-center justify-content-center flex-column mb-2">
                                                <span class="upload-img d-block mb-2"><i class="isax isax-document-upload fs-24"></i></span>
                                                <h6 class="mb-1">Upload Business License</h6>
                                                <p class="mb-0">Max 5MB, supports .pdf, .jpg, .png (up to 3 files)</p>
                                                <input type="file" name="businessLicense" id="businessLicense" accept="image/*,application/pdf" multiple>
                                            </div>
                                            <div class="d-flex align-items-center flex-wrap" id="licensePreview"></div>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-center mt-4">
                                        <button type="button" class="btn btn-light me-2" onclick="resetForm()">Reset</button>
                                        <button type="submit" class="btn btn-primary">${user.role.roleId == 3 ? 'Submit Hotel Request' : 'Submit Agent Request'}</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%@ include file="../../layout/footer.jsp" %>
        <%@ include file="../../layout/cursor.jsp" %>
        <%@ include file="../../layout/back-to-top.jsp" %>
        <%@ include file="../../layout/script.jsp" %>

        <script src="${pageContext.request.contextPath}/assets/plugins/owlcarousel/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/plugins/theia-sticky-sidebar/ResizeSensor.js"></script>
        <script src="${pageContext.request.contextPath}/assets/plugins/theia-sticky-sidebar/theia-sticky-sidebar.js"></script>
        <script src="${pageContext.request.contextPath}/assets/plugins/summernote/summernote-lite.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/plugins/select2/js/select2.min.js"></script>

        <script>
                                            $(document).ready(function () {
                                                // Không cần khởi tạo Select2 ở đây, giống trang mới

                                                $("#country").change(function () {
                                                    let countryCode = $(this).val();
                                                    let citySelect = $("#city");
                                                    citySelect.prop("disabled", true).html('<option value="">Loading...</option>');

                                                    if (countryCode) {
                                                        $.getJSON("/HotelBooking/get-cities?country=" + countryCode)
                                                                .done(function (data) {
                                                                    console.log("Cities received:", data); // Log dữ liệu nhận được
                                                                    citySelect.html('<option value="">Select</option>'); // Reset danh sách
                                                                    if (data && data.length > 0) {
                                                                        data.forEach(function (city) {
                                                                            citySelect.append(
                                                                                    '<option value="' + city + '">' + city + '</option>'
                                                                                    );
                                                                        });
                                                                        citySelect.prop("disabled", false);
                                                                    } else {
                                                                        citySelect.html('<option value="">No cities found</option>');
                                                                    }
                                                                })
                                                                .fail(function (jqXHR, textStatus, errorThrown) {
                                                                    console.error("Error fetching cities:", textStatus, errorThrown); // Log lỗi
                                                                    citySelect.html('<option value="">Error loading cities</option>');
                                                                });
                                                    } else {
                                                        citySelect.prop("disabled", true).html('<option value="">Select</option>');
                                                    }
                                                });

                                                $("#businessLicense").change(function () {
                                                    let files = this.files;
                                                    let preview = $("#licensePreview");
                                                    preview.empty(); // Xóa preview cũ

                                                    for (let i = 0; i < files.length; i++) {
                                                        let file = files[i];
                                                        if (file.size > 5 * 1024 * 1024) { // Kiểm tra kích thước < 5MB
                                                            alert("File " + file.name + " exceeds 5MB limit!");
                                                            continue;
                                                        }
                                                        let reader = new FileReader();
                                                        reader.onload = function (e) {
                                                            let content;
                                                            if (file.type === 'application/pdf') {
                                                                content = $('<span>').text(file.name).addClass('gallery-preview');
                                                            } else {
                                                                content = $('<img>').attr('src', e.target.result).addClass('gallery-preview');
                                                            }
                                                            let trash = $('<span>').addClass('trash-icon d-flex align-items-center justify-content-center text-danger gallery-trash')
                                                                    .html('<i class="isax isax-trash"></i>')
                                                                    .click(function () {
                                                                        $(this).parent().remove();
                                                                    });
                                                            let container = $('<a>').addClass('gallery-upload-img me-2').append(content, trash);
                                                            preview.append(container);
                                                        };
                                                        reader.readAsDataURL(file);
                                                    }
                                                });
                                            });

                                            // Reset form function
                                            function resetForm() {
                                                document.getElementById('addHotelForm').reset();
                                                $('#licensePreview').empty();
                                                $("#city").prop("disabled", true).html('<option value="">Select</option>');
                                                $("#country").val(""); // Reset country
                                            }
        </script>
    </body>
</html>
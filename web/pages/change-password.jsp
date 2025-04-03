<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="../layout/head.jsp" %>
    </head>

    <body class="bg-light-200">
        <!-- Main Wrapper -->
        <div class="main-wrapper authentication-wrapper">
            <div class="container-fuild">
                <div class="w-100 overflow-hidden position-relative flex-wrap d-block vh-100">
                    <div class="row justify-content-center align-items-center vh-100 overflow-auto flex-wrap ">
                        <div class="col-xxl-4 col-xl-4 col-lg-6 col-md-6 col-11 mx-auto">
                            <div class="p-4 text-center">
                                <img src="assets/img/hotel-logo.svg" alt="logo" class="img-fluid">
                            </div>
                            <div class="card authentication-card">
                                <div class="card-header">
                                    <div class="text-center">
                                        <h5 class="mb-1">Change Password</h5>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <form id="cp-form" action="${pageContext.request.contextPath}/change-password">
                                        <div class="mb-3">
                                            <label class="form-label">Old Password</label>
                                            <div class="input-icon">
                                                <span class="input-icon-addon">
                                                    <i class="isax isax-lock"></i>
                                                </span>
                                                <input name="oldPassword" type="password" class="form-control form-control-lg pass-input" placeholder="Enter Old Password">
                                                <span class="input-icon-addon toggle-password">
                                                    <i class="isax isax-eye-slash"></i>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">New Password</label>
                                            <div class="input-icon">
                                                <span class="input-icon-addon">
                                                    <i class="isax isax-lock"></i>
                                                </span>
                                                <input name="newPassword" type="password" class="form-control form-control-lg pass-input" placeholder="Enter New Password">
                                                <span class="input-icon-addon toggle-password">
                                                    <i class="isax isax-eye-slash"></i>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="mb-4">
                                            <label class="form-label">Confirm Password</label>
                                            <div class="input-icon">
                                                <span class="input-icon-addon">
                                                    <i class="isax isax-lock"></i>
                                                </span>
                                                <input name="confirmPassword" type="password" class="form-control form-control-lg pass-input" placeholder="Enter Password">
                                                <span class="input-icon-addon toggle-password">
                                                    <i class="isax isax-eye-slash"></i>
                                                </span>
                                            </div>
                                        </div>

                                        <div id="response-message" class="alert d-none" role="alert"></div>

                                        <div class="mb-0">
                                            <button type="submit" class="btn btn-xl btn-primary d-flex align-items-center justify-content-center w-100">Change Password<i class="isax isax-arrow-right-3 ms-2"></i></button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="coprright-footer">
                <p class="fs-14">Copyright &copy; 2025. All Rights Reserved, <a href="javascript:void(0);" class="text-primary fw-medium">QuickBook</a></p>
            </div>
        </div>
        <!-- /Main Wrapper -->

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let form = document.getElementById("cp-form");
                let responseMessage = document.getElementById("response-message");
                let submitButton = form.querySelector("button[type='submit']");

                form.addEventListener("submit", async function (event) {
                    event.preventDefault();
                    if (submitButton.disabled)
                        return;

                    submitButton.disabled = true;
                    responseMessage.classList.add("d-none");
                    responseMessage.classList.remove("alert-success", "alert-danger");

                    let formData = new FormData(form);

                    try {
                        let response = await fetch(form.action, {
                            method: "POST",
                            body: new URLSearchParams(formData),
                            headers: {
                                "Content-Type": "application/x-www-form-urlencoded"
                            }
                        });

                        let result = await response.json();

                        responseMessage.classList.remove("d-none");
                        responseMessage.textContent = result.message;

                        if (result.success) {
                            responseMessage.classList.add("alert-success");

                            setTimeout(() => {
                                window.location.href = "/HotelBooking";
                            }, 3000);
                        } else {
                            responseMessage.classList.add("alert-danger");
                            submitButton.disabled = false;
                        }

                    } catch (error) {
                        responseMessage.classList.remove("d-none", "alert-success");
                        responseMessage.classList.add("alert-danger");
                        responseMessage.textContent = "An error occurred. Please try again.";
                        submitButton.disabled = false;
                    }
                });
            });
        </script>

        <!-- Cursor -->
        <%@ include file="../layout/cursor.jsp" %>
        <!-- /Cursor -->

        <!-- Script -->
        <%@ include file="../layout/script.jsp" %>
</html>
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
                        <div class="col-xxl-4 col-lg-6 col-md-6 col-11 mx-auto">
                            <div class="card authentication-card">
                                <div class="card-header">
                                    <div class="text-center">
                                        <h5 class="mb-1">Email Verification</h5>
                                        <p>Check your email for OTP verification.</p>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/verify-email">
                                        <div class="mb-3">
                                            <label for="otp" class="form-label">OTP</label>
                                            <div class="input-icon">
                                                <input type="text" name="otp" class="form-control form-control-lg" placeholder="Enter OTP" required>
                                            </div>
                                        </div>

                                        <div id="response-message" class="alert d-none" role="alert"></div>

                                        <div class="mb-3">
                                            <button type="submit" class="btn btn-xl btn-primary d-flex align-items-center justify-content-center w-100">Submit<i class="isax isax-arrow-right-3 ms-2"></i></button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /Main Wrapper -->

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let form = document.querySelector("form");
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
                                window.location.href = "../home";
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
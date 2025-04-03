<!-- Register Modal -->
<div class="modal fade" id="register-modal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header d-flex align-items-center justify-content-end pb-0 border-0">
                <a href="javascript:void(0);" data-bs-dismiss="modal" aria-label="Close">
                    <i class="ti ti-x fs-20"></i>
                </a>
            </div>
            <div class="modal-body p-4 pt-0">
                <form id="register-form" action="${pageContext.request.contextPath}/register" method="post">
                    <div class="text-center border-bottom mb-3">
                        <h5 class="mb-1">Sign Up</h5>
                        <p class="mb-3">Create your account</p>
                    </div>
                    <div class="mb-2">
                        <label for="username" class="form-label">Username</label>
                        <div class="input-icon">
                            <span class="input-icon-addon">
                                <i class="isax isax-user"></i>
                            </span>
                            <input id="username" name="username" type="text" class="form-control form-control-lg" placeholder="Enter Username" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label for="lastname" class="form-label">Last Name</label>
                        <div class="input-icon">
                            <span class="input-icon-addon">
                                <i class="isax isax-user"></i>
                            </span>
                            <input id="lastname" name="lastname" type="text" class="form-control form-control-lg" placeholder="Enter Last Name" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label for="firstname" class="form-label">First Name</label>
                        <div class="input-icon">
                            <span class="input-icon-addon">
                                <i class="isax isax-user"></i>
                            </span>
                            <input name="firstname" id="firstname" type="text" class="form-control form-control-lg" placeholder="Enter First Name" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label for="email" class="form-label">Email</label>
                        <div class="input-icon">
                            <span class="input-icon-addon">
                                <i class="isax isax-message"></i>
                            </span>
                            <input id="email" name="email" type="email" class="form-control form-control-lg" placeholder="Enter Email" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label for="password" class="form-label">Password</label>
                        <div class="input-icon">
                            <span class="input-icon-addon">
                                <i class="isax isax-lock"></i>
                            </span>
                            <input id="password" name="password" type="password" class="form-control form-control-lg pass-input" placeholder="Enter Password" required>
                            <span class="input-icon-addon toggle-password">
                                <i class="isax isax-eye-slash"></i>
                            </span>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Confirm Password</label>
                        <div class="input-icon">
                            <span class="input-icon-addon">
                                <i class="isax isax-lock"></i>
                            </span>
                            <input name="confirmPassword" type="password" id="confirm-password" class="form-control form-control-lg pass-input" placeholder="Enter Password" required>
                            <span class="input-icon-addon toggle-password">
                                <i class="isax isax-eye-slash"></i>
                            </span>
                        </div>
                    </div>
                    <div class="mt-3 mb-3">
                        <div class="d-flex">
                            <div class="form-check d-flex align-items-center mb-2">
                                <input class="form-check-input mt-0" type="checkbox" id="agree">
                                <label class="form-check-label ms-2 text-gray-9 fs-14" for="agree">
                                    I agree with the <a href="javascript:void(0);" class="link-primary fw-medium">Terms Of Service.</a>
                                </label>
                            </div>
                        </div>
                        <small id="agree-error" class="text-danger d-none">You must agree to the terms!</small>
                    </div>

                    <div id="register-response-message" class="alert d-none" role="alert"></div>

                    <div class="mb-3">
                        <button type="submit" class="btn btn-xl btn-primary d-flex align-items-center justify-content-center w-100">
                            Register <i class="isax isax-arrow-right-3 ms-2"></i>
                        </button>
                    </div>
                    <div class="login-or mb-3">
                        <span class="span-or">Or</span>
                    </div>
                    <div class="d-flex align-items-center mb-3">
                        <a href="https://accounts.google.com/o/oauth2/auth?scope=email&redirect_uri=http://localhost:8080/HotelBooking/google-login&response_type=code&client_id=151505397859-gras04bfo18abfhbguik5cqtgaaleaqs.apps.googleusercontent.com&prompt=consent" class="btn btn-light flex-fill d-flex align-items-center justify-content-center me-2">
                            <img src="assets/img/icons/google-icon.svg" class="me-2" alt="Img">Google
                        </a>
                    </div>
                    <div class="d-flex justify-content-center">
                        <p class="fs-14">Already have an account? 
                            <a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#login-modal">Sign In</a>
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        let form = document.getElementById("register-form");
        let responseMessage = document.getElementById("register-response-message");
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
                    window.location.href = form.action.replace("/register", "/pages/verify-email.jsp");
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

        document.getElementById("register-modal").addEventListener("hidden.bs.modal", function () {
            form.reset();
            responseMessage.classList.add("d-none");
            responseMessage.classList.remove("alert-success", "alert-danger");
            submitButton.disabled = false;
        });
    });
</script>
<!-- Login Modal -->
<div class="modal fade" id="login-modal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header d-flex align-items-center justify-content-end pb-0 border-0">
                <a href="javascript:void(0);" data-bs-dismiss="modal" aria-label="Close"><i
                        class="ti ti-x fs-20"></i></a>
            </div>
            <div class="modal-body p-4 pt-0">
                <form id="login-form" action="login">
                    <div class="text-center mb-3">
                        <h5 class="mb-1">Sign In</h5>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Username</label>
                        <div class="input-icon">
                            <span class="input-icon-addon">
                                <i class="isax isax-message"></i>
                            </span>
                            <input id="username" name="username" type="text" class="form-control form-control-lg" placeholder="Enter Username">
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Password</label>
                        <div class="input-icon">
                            <span class="input-icon-addon">
                                <i class="isax isax-lock"></i>
                            </span>
                            <input id="password" name="password" type="password" class="form-control form-control-lg pass-input" placeholder="Enter Password">
                            <span class="input-icon-addon toggle-password">
                                <i class="isax isax-eye-slash"></i>
                            </span>
                        </div>
                    </div>
                    <div class="mt-3 mb-3">
                        <div class="d-flex align-items-center justify-content-between flex-wrap row-gap-2">
                            <div class="form-check d-flex align-items-center mb-2">
                                <input class="form-check-input mt-0" type="checkbox" value="" id="remembers_me">
                                <label class="form-check-label ms-2 text-gray-9 fs-14" for="remembers_me">
                                    Remember Me
                                </label>
                            </div>
                            <a href="javascript:void(0);" class="link-primary fw-medium fs-14 mb-2" data-bs-toggle="modal" data-bs-target="#forgot-modal">Forgot Password?</a>
                        </div>
                    </div>

                    <div id="response-message" class="alert d-none" role="alert"></div>

                    <div class="mb-3">
                        <button type="submit" class="btn btn-xl btn-primary d-flex align-items-center justify-content-center w-100">Login<i class="isax isax-arrow-right-3 ms-2"></i></button>
                    </div>
                    <div class="login-or mb-3">
                        <span class="span-or">Or</span>
                    </div>
                    <div class="d-flex align-items-center mb-3">
                        <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/HotelBooking/google-login&response_type=code&client_id=151505397859-kolkm3d4fmvi21gkvjfdkmj3jufcpht5.apps.googleusercontent.com&prompt=consent" class="btn btn-light flex-fill d-flex align-items-center justify-content-center me-2">
                            <img src="assets/img/icons/google-icon.svg" class="me-2" alt="Img">Google
                        </a>
                    </div>
                    <div class="d-flex justify-content-center">
                        <p class="fs-14">Don't you have an account? <a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#register-modal">Sign up</a></p>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>
<!-- /Login Modal -->

<script>
    document.addEventListener("DOMContentLoaded", function () {
        let form = document.getElementById("login-form");
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
                        if (result.isAdmin) { // Assuming 'isAdmin' is returned in the JSON response
                            window.location.href = "/HotelBooking/admin";
                        } else {
                            window.location.href = "/HotelBooking/";
                        }
                    }, 1000);
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

        document.getElementById("login-modal").addEventListener("hidden.bs.modal", function () {
            form.reset();
            responseMessage.classList.add("d-none");
            responseMessage.classList.remove("alert-success", "alert-danger");
            submitButton.disabled = false;
        });
    });
</script>
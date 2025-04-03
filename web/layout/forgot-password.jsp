<!-- Forgot Password -->
<div class="modal fade" id="forgot-modal">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header d-flex align-items-center justify-content-end pb-0 border-0">
                <a href="javascript:void(0);" data-bs-dismiss="modal" aria-label="Close"><i
                        class="ti ti-x fs-20"></i></a>
            </div>
            <div class="modal-body p-4 pt-0">
                <form id="fp-form" action="${pageContext.request.contextPath}/forgot-password">
                    <div class="text-center border-bottom mb-3">
                        <h5 class="mb-1">Forgot Password</h5>
                        <p>Reset Your Password</p>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Email</label>
                        <div class="input-icon">
                            <span class="input-icon-addon">
                                <i class="isax isax-message"></i>
                            </span>
                            <input name="email" type="email" class="form-control form-control-lg" placeholder="Enter Email">
                        </div>
                    </div>
                    <div class="mb-3">
                        <button type="submit" class="btn btn-xl btn-primary d-flex align-items-center justify-content-center w-100">Reset Password<i class="isax isax-arrow-right-3 ms-2"></i></button>
                    </div>

                    <div id="fp-response-message" class="alert d-none" role="alert"></div>

                    <div class="d-flex justify-content-center">
                        <p class="fs-14">Remember Password ? <a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#login-modal">Sign In</a></p>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>
<!-- /Forgot Password -->

<script>
    document.addEventListener("DOMContentLoaded", function () {
        let form = document.getElementById("fp-form");
        let responseMessage = document.getElementById("fp-response-message");
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
                    window.location.href = form.action.replace("/forgot-password", "/pages/verify-email-fp.jsp");
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
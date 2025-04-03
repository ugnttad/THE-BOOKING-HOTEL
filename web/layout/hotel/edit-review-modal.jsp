<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Review Modal -->
<!--<div class="modal fade" id="edit_review">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header d-flex align-items-center justify-content-between">
                <h5>Edit Review</h5>
                <a href="javascript:void(0);" data-bs-dismiss="modal" aria-label="Close">
                    <i class="ti ti-x fs-16"></i>
                </a>
            </div>
            <form id="editReviewForm" method="POST">
                <div class="modal-body pb-0">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="mb-3">
                                <label class="form-label">Your Rating <span class="text-danger">*</span></label>
                                <div class="selection-wrap">
                                    <div class="d-inline-block">
                                        <div class="rating-selction">
                                            <input type="radio" name="rating" value="5" id="rating5">
                                            <label for="rating5"><i class="fa-solid fa-star"></i></label>
                                            <input type="radio" name="rating" value="4" id="rating4">
                                            <label for="rating4"><i class="fa-solid fa-star"></i></label>
                                            <input type="radio" name="rating" value="3" id="rating3">
                                            <label for="rating3"><i class="fa-solid fa-star"></i></label>
                                            <input type="radio" name="rating" value="2" id="rating2">
                                            <label for="rating2"><i class="fa-solid fa-star"></i></label>
                                            <input type="radio" name="rating" value="1" id="rating1">
                                            <label for="rating1"><i class="fa-solid fa-star"></i></label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-12">
                            <div class="mb-3">
                                <label class="form-label">Write Your Review <span class="text-danger">*</span></label>
                                <textarea id="reviewComment" name="comment" class="form-control" rows="3"></textarea>
                            </div>
                        </div>
                         Hidden Fields 
                        <input type="hidden" id="hotelId" name="hotelId" value="<%=currentHotel.getHotelId()%>">
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="d-flex align-items-center justify-content-end m-0">
                        <button type="submit" class="btn btn-primary btn-md" onclick="submitReview()">
                            <i class="isax isax-edit-2 me-1"></i> Submit Review
                        </button>
                    </div>
                </div>
            </form>

        </div>
    </div>
</div>-->

<script>
    function submitReview() {
        const form = document.getElementById("editReviewForm");
        const formData = new FormData(form); // Tự động lấy tất cả input có `name`

        // Debug kiểm tra xem dữ liệu có được lấy đúng không
        for (let [key, value] of formData.entries()) {
            console.log(`${key}: ${value}`);
                    }

                    fetch("feedback?action=upsert", {
                        method: "POST",
                        body: formData
                    })
                            .then(response => response.text())
                            .then(data => {
                                alert(data);
                                location.reload(); // Reload trang để thấy review mới
                            })
                            .catch(error => console.error("Error:", error));
                }

</script>
<%@page import="java.util.List"%>
<%@page import="model.Feedback"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="dao.FeedbackDAO" %>
<%@ page import="dao.UserDAO" %>

<%
    FeedbackDAO fbdao = new FeedbackDAO();
    List<Feedback> fbs = fbdao.getAllFeedbacks();

%>

<!-- Reviews -->
<div id="reviews">
    <div class="d-flex align-items-center justify-content-between flex-wrap mb-2">
        <h5 class="mb-3 fs-18">Reviews (<%=fbdao.getTotalReviewsByHotelId(currentHotel.getHotelId())%>)</h5>
    </div>
    <div class="row">
        <div class="col-md-6 d-flex">
            <div class="rating-item bg-light-200 text-center flex-fill mb-3">
                <h6 class="fw-medium mb-3">Customer Reviews & Ratings</h6>
                <h5 class="display-6"><%=dao.getAverageHotelRating(currentHotel.getHotelId())%> / 5.0</h5>
                <div class="d-inline-flex align-items-center justify-content-center mb-3">
                    <i class="ti ti-star-filled text-primary me-1"></i>
                    <i class="ti ti-star-filled text-primary me-1"></i>
                    <i class="ti ti-star-filled text-primary me-1"></i>
                    <i class="ti ti-star-filled text-primary me-1"></i>
                    <i class="ti ti-star-filled text-primary"></i>
                </div>
                <p>Based On <%=fbdao.getTotalReviewsByHotelId(currentHotel.getHotelId())%> Reviews</p>
            </div>
        </div>
        <div class="col-md-6 d-flex">
            <div class="card rating-progress shadow-none flex-fill mb-3">
                <div class="card-body">
                    <div class="d-flex align-items-center mb-2">
                        <p class="me-2 text-nowrap mb-0">5 Star Ratings</p>
                        <div class="progress w-100" role="progressbar" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100">
                            <div class="progress-bar bg-primary" style="width: <%=fbdao.getFeedbackPercentageByRatingLevel(5)%>%"></div>
                        </div>
                        <p class="progress-count ms-2"><%=fbdao.getTotalFeedbackByRating(5)%></p>
                    </div>
                    <div class="d-flex align-items-center mb-2">
                        <p class="me-2 text-nowrap mb-0">4 Star Ratings</p>
                        <div class="progress mb-0 w-100" role="progressbar" aria-valuenow="80" aria-valuemin="0" aria-valuemax="100">
                            <div class="progress-bar bg-primary" style="width: <%=fbdao.getFeedbackPercentageByRatingLevel(4)%>%"></div>
                        </div>
                        <p class="progress-count ms-2"><%=fbdao.getTotalFeedbackByRating(4)%></p>
                    </div>
                    <div class="d-flex align-items-center mb-2">
                        <p class="me-2 text-nowrap mb-0">3 Star Ratings</p>
                        <div class="progress mb-0 w-100" role="progressbar" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100">
                            <div class="progress-bar bg-primary" style="width: <%=fbdao.getFeedbackPercentageByRatingLevel(3)%>%"></div>
                        </div>
                        <p class="progress-count ms-2"><%=fbdao.getTotalFeedbackByRating(3)%></p>
                    </div>
                    <div class="d-flex align-items-center mb-2">
                        <p class="me-2 text-nowrap mb-0">2 Star Ratings</p>
                        <div class="progress mb-0 w-100" role="progressbar" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100">
                            <div class="progress-bar bg-primary" style="width: <%=fbdao.getFeedbackPercentageByRatingLevel(2)%>%"></div>
                        </div>
                        <p class="progress-count ms-2"><%=fbdao.getTotalFeedbackByRating(2)%></p>
                    </div>
                    <div class="d-flex align-items-center">
                        <p class="me-2 text-nowrap mb-0">1 Star Ratings</p>
                        <div class="progress mb-0 w-100" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100">
                            <div class="progress-bar bg-primary" style="width: <%=fbdao.getFeedbackPercentageByRatingLevel(1)%>%"></div>
                        </div>
                        <p class="progress-count ms-2"><%=fbdao.getTotalFeedbackByRating(1)%></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <c:forEach var="fb" items="<%=fbs%>">
        <div class="card review-item shadow-none mb-3">
            <div class="card-body p-3">
                <div class="review-info">
                    <div class="d-flex align-items-center justify-content-between flex-wrap">
                        <div class="d-flex align-items-center mb-2">
                            <span class="avatar avatar-lg me-2 flex-shrink-0">
                                <img src="${(UserDAO.getUserByUserId(fb.getUserId())).getAvatarUrl()}" class="rounded-circle" alt="img">
                            </span>
                            <div>
                                <h6 class="fs-16 fw-medium mb-1">${(UserDAO.getUserByUserId(fb.getUserId())).getFirstName()} ${(UserDAO.getUserByUserId(fb.getUserId())).getLastName()}</h6>
                                <div class="d-flex align-items-center flex-wrap date-info">
                                    <p class="fs-14 mb-0"><fmt:formatDate value="${fb.getLastUpdatedAt()}" pattern="dd MMM yyyy"/></p>
                                    <p class="fs-14 d-inline-flex align-items-center mb-0"><span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">${fb.getRating()}.0</span></p>
                                </div>
                            </div>
                        </div>

                        <c:if test="${user != null && FeedbackDAO.isUserFeedbackOwner(user.getUserId(), fb.getFeedbackId())}">
                            <button class="btn btn-link p-0 mb-2" 
                                    onclick="showEditPopup('${fb.getFeedbackId()}', '${fb.getRating()}', '${fn:escapeXml(fb.getComment())}')">
                                <i class="isax isax-edit-2"></i>
                            </button>
                        </c:if>

                    </div>
                    <p class="mb-2">${fb.getComment()}</p>
                    <div class="d-flex align-items-center">
<!--                        <a class="avatar avatar-md me-2 mb-2" data-fancybox="gallery" href="assets/img/hotels/hotel-large-07.jpg">
                            <img src="assets/img/hotels/hotel-gallery-01.jpg" alt="img">
                        </a>
                        <a class="avatar avatar-md me-2 mb-2" data-fancybox="gallery" href="assets/img/hotels/hotel-large-08.jpg">
                            <img src="assets/img/hotels/hotel-gallery-02.jpg" alt="img">
                        </a>
                        <a class="avatar avatar-md me-2 mb-2" data-fancybox="gallery" href="assets/img/hotels/hotel-large-09.jpg">
                            <img src="assets/img/hotels/hotel-gallery-03.jpg" alt="img">
                        </a>-->
                    </div>
                    <div class="d-inline-flex align-items-center">
                        <a href="javascript:void(0);" class="d-inline-flex align-items-center fs-14 me-3"><i class="isax isax-like-1 me-2"></i>0</a>
                        <a href="javascript:void(0);" class="d-inline-flex align-items-center me-3"><i class="isax isax-dislike me-2"></i>0</a>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>
<!-- /Reviews -->

<% if (user != null && bookingDAO.checkUserBooking(user.getUserId(), currentHotel.getHotelId()) && !fbdao.hasUserFeedbackForHotel(user.getUserId(), currentHotel.getHotelId())) {%>
<!-- Review -->
<div id="add_review">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header d-flex align-items-center justify-content-between">
                <h5>Write a Review</h5>
            </div>
            <form id="reviewForm" method="POST" action="feedback?action=upsert">

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
                        <!-- Hidden Fields -->
                        <input type="hidden" id="hotelId" name="hotelId" value="<%=currentHotel.getHotelId()%>">
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="d-flex align-items-center justify-content-end m-0">
                        <button type="submit" class="btn btn-primary btn-md" onclick="submitReview(event)">
                            <i class="isax isax-edit-2 me-1"></i> Submit Review
                        </button>
                    </div>
                </div>
            </form>

        </div>
    </div>
</div>
<% }%>

<!-- Edit Review Popup -->
<div class="overlay" id="editOverlay" onclick="hideEditPopup()"></div>
<div class="edit-popup" id="editPopup">
    <form id="editReviewForm" method="POST" action="feedback?action=upsert">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h5>Edit Your Review</h5>
            <button type="button" onclick="hideEditPopup()" class="btn btn-link p-0">×</button>
        </div>
        <div class="mb-3">
            <label class="form-label">Your Rating <span class="text-danger">*</span></label>
            <div class="selection-wrap">
                <div class="rating-selction">
                    <input type="radio" name="rating" value="5" id="editRating5">
                    <label for="editRating5"><i class="fa-solid fa-star"></i></label>
                    <input type="radio" name="rating" value="4" id="editRating4">
                    <label for="editRating4"><i class="fa-solid fa-star"></i></label>
                    <input type="radio" name="rating" value="3" id="editRating3">
                    <label for="editRating3"><i class="fa-solid fa-star"></i></label>
                    <input type="radio" name="rating" value="2" id="editRating2">
                    <label for="editRating2"><i class="fa-solid fa-star"></i></label>
                    <input type="radio" name="rating" value="1" id="editRating1">
                    <label for="editRating1"><i class="fa-solid fa-star"></i></label>
                </div>
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label">Write Your Review <span class="text-danger">*</span></label>
            <textarea id="editComment" name="comment" class="form-control" rows="3"></textarea>
        </div>
        <input type="hidden" id="editFeedbackId" name="feedbackId">
        <input type="hidden" name="hotelId" value="<%=currentHotel.getHotelId()%>">
        <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-secondary me-2" onclick="hideEditPopup()">Cancel</button>
            <button type="submit" class="btn btn-primary" onclick="submitEditReview(event)">Update Review</button>
        </div>
    </form>
</div>

<script>
    function submitReview(event) {
        event.preventDefault(); // Prevent form from submitting normally

        console.log('submitReview triggered'); // Debug log to see if the function is being called

        const form = document.getElementById("reviewForm");
        const formData = new FormData(form); // Automatically gather all form inputs with `name`

        // Make the fetch request
        fetch("feedback?action=upsert", {
            method: "POST",
            body: formData
        })
                .then(response => response.json()) // Parse the response as JSON
                .then(data => {
                    console.log('Server response:', data); // Debug log to see the server response

                    if (data.success) {
                        alert(data.message); // Show success message from the server
                    } else {
                        alert(data.message); // Show error message from the server
                    }
                    location.reload(); // Reload the page to display the new review
                })
                .catch(error => {
                    console.error("Error:", error);
                    alert("An error occurred while submitting your review."); // Handle any errors that occur in fetch
                });
    }

    function showEditPopup(feedbackId, rating, comment) {
        document.getElementById('editFeedbackId').value = feedbackId;
        document.getElementById('editComment').value = comment;
        document.getElementById('editRating' + rating).checked = true;

        document.getElementById('editPopup').classList.add('active');
        document.getElementById('editOverlay').classList.add('active');
    }

    function hideEditPopup() {
        document.getElementById('editPopup').classList.remove('active');
        document.getElementById('editOverlay').classList.remove('active');
    }

    function submitEditReview(event) {
        event.preventDefault();

        const form = document.getElementById("editReviewForm");
        const formData = new FormData(form);

        fetch("feedback?action=upsert", {
            method: "POST",
            body: formData
        })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        hideEditPopup();
                        location.reload();
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    console.error("Error:", error);
                    alert("An error occurred while updating your review.");
                });
    }

</script>
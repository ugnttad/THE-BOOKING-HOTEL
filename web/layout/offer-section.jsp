<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Offer Section -->
<!--<section class="section offers-section">
    <div class="offer-sec-bg">
        <img src="${pageContext.request.contextPath}/assets/img/bg/hotel-bg-02.svg" class="bg-1" alt="Img">
        <img src="${pageContext.request.contextPath}/assets/img/bg/hotel-bg-04.svg" class="bg-2" alt="Img">
    </div>
    <div class="container">
        <div class="offer-sec">
            <div class="offer-slider owl-carousel">
                <div class="offer-slider-img">
                    <img src="${pageContext.request.contextPath}/assets/img/hotels/slider-01.jpg" alt="Img">
                </div>
                <div class="offer-slider-img">
                    <img src="${pageContext.request.contextPath}/assets/img/hotels/slider-01.jpg" alt="Img">
                </div>
                <div class="offer-slider-img">
                    <img src="${pageContext.request.contextPath}/assets/img/hotels/slider-01.jpg" alt="Img">
                </div>
            </div>
            <div class="offers-content">
                <div class="row align-items-center">
                    <div class="col-md-6 col-10">
                        <div>
                            <h2 class="text-white mb-2">Seasonal Promotions</h2>
                            <p class="text-white mb-3">Save 20% on stays of three nights or more during summer months, including breakfast for two.</p>
                            <a href="hotel-list.html" class="btn btn-white text-dark">Explore All Offers<i class="isax isax-arrow-right-3 ms-2"></i></a>
                            <div class="owl-nav slide-nav mt-4"></div>
                        </div>
                    </div>
                    <div class="col-md-6 col-2">
                        <div class="text-center slider-video-btn">
                            <a class="video-btn video-effect" data-fancybox="" href="https://youtu.be/NSAOrGb9orM"><i class="isax isax-play5"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="offers-counter bg-white rounded p-2">
            <div class="bg-primary rounded offer-counter-inner">
                <div class="row g-4">
                    <div class="col-lg-4">
                        <div>
                            <h6 class="text-white mb-1">Destinations Worldwide</h6>
                            <h3 class="display-6 text-white"><span class="counter">50</span>+</h3>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div>
                            <h6 class="text-white mb-1">Destinations Worldwide</h6>
                            <h3 class="display-6 text-white"><span class="counter">7000</span>+</h3>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div>
                            <h6 class="text-white mb-1">Destinations Worldwide</h6>
                            <h3 class="display-6 text-white"><span class="counter">89</span>+</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="popular-hotels">
            <div class="section-header d-flex align-items-center justify-content-between flex-wrap row-gap-3">
                <div>
                    <p class="mb-2 fw-medium d-flex align-items-center text-white"><span class="text-bar bg-white"></span>Popular Hotels</p>
                    <h2 class="text-white">Try Relaxing Accomodations<span class="text-primary">.</span></h2>
                </div>
                <div>
                    <a href="hotel-grid.html" class="btn btn-primary">View All Hotels<i class="isax isax-arrow-right-3 ms-2"></i></a>
                </div>
            </div>
            <div class="popular-hotel-slider owl-carousel">
                <div class="card mb-0">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3 pb-3 border-bottom">
                            <a href="hotel-details.html" class="flex-shrink-0 me-3"><img src="${pageContext.request.contextPath}/assets/img/icons/hotel-logo-01.svg" class="rounded-circle" alt="Img"></a>
                            <div>
                                <h5 class="mb-2"><a href="hotel-details.html">Adventure Suites</a></h5>
                                <div class="d-flex align-items-center">
                                    <span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">4.9</span>
                                    <p>(450 Reviews)</p>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center seperate-dot">
                                <span>Boutique</span>
                                <span>Germany</span>
                            </div>
                            <span class="badge bg-outline-success">15 Rooms Left</span>
                        </div>
                    </div>
                </div>
                <div class="card mb-0">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3 pb-3 border-bottom">
                            <a href="hotel-details.html" class="flex-shrink-0 me-3"><img src="${pageContext.request.contextPath}/assets/img/icons/hotel-logo-02.svg" class="rounded-circle" alt="Img"></a>
                            <div>
                                <h5 class="mb-2"><a href="hotel-details.html">Mystery Manor</a></h5>
                                <div class="d-flex align-items-center">
                                    <span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">5.0</span>
                                    <p>(120 Reviews)</p>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center seperate-dot">
                                <span>Resorts</span>
                                <span>Ukraine</span>
                            </div>
                            <span class="badge bg-outline-success">20 Rooms Left</span>
                        </div>
                    </div>
                </div>
                <div class="card mb-0">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3 pb-3 border-bottom">
                            <a href="hotel-details.html" class="flex-shrink-0 me-3"><img src="${pageContext.request.contextPath}/assets/img/icons/hotel-logo-03.svg" class="rounded-circle" alt="Img"></a>
                            <div>
                                <h5 class="mb-2"><a href="hotel-details.html">Harmony Retreat</a></h5>
                                <div class="d-flex align-items-center">
                                    <span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">4.9</span>
                                    <p>(128 Reviews)</p>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center seperate-dot">
                                <span>Resorts</span>
                                <span>London</span>
                            </div>
                            <span class="badge bg-outline-success">05 Rooms Left</span>
                        </div>
                    </div>
                </div>
                <div class="card mb-0">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3 pb-3 border-bottom">
                            <a href="hotel-details.html" class="flex-shrink-0 me-3"><img src="${pageContext.request.contextPath}/assets/img/icons/hotel-logo-04.svg" class="rounded-circle" alt="Img"></a>
                            <div>
                                <h5 class="mb-2"><a href="hotel-details.html">Tranquil Spa</a></h5>
                                <div class="d-flex align-items-center">
                                    <span class="badge badge-warning badge-xs text-gray-9 fs-13 fw-medium me-2">5.0</span>
                                    <p>(69 Reviews)</p>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center justify-content-between">
                            <div class="d-flex align-items-center seperate-dot">
                                <span>Hotel</span>
                                <span>Japan</span>
                            </div>
                            <span class="badge bg-outline-success">20 Rooms Left</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>-->
<!-- /Offer Section -->
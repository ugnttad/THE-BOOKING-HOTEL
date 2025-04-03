<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Hotel Search -->
<div class="card">
    <div class="card-body">
        <div class="banner-form mb-0">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/search-hotels" method="POST">
                    <h6 class="fw-medium fs-16 mb-2">Book Hotel - Villas, Apartments & more.</h6>
                    <div class="d-lg-flex">
                        <div class="d-flex form-info flex-wrap">
                            <div class="form-item dropdown">
                                <div data-bs-toggle="dropdown" data-bs-auto-close="outside" aria-expanded="false" role="menu">
                                    <label class="form-label fs-14 text-default mb-1">City, Property name or Location</label>
                                    <input name="location" type="text" id="location-input" class="form-control" placeholder="Enter a location">
                                    <!--                                                <p class="fs-12 mb-0">USA</p>-->
                                </div>
                                <div class="dropdown-menu dropdown-md p-0">
                                    <ul id="location-suggestions" class="list-group">
                                        <!-- Suggestions will be appended here -->
                                    </ul>
                                </div>
                            </div>
                            <div class="form-item">
                                <label class="form-label fs-14 text-default mb-1">Check In</label>
                                <input name="checkin" type="date" id="checkin-date" class="form-control">
                                <p class="fs-12 mb-0" id="checkin-day"></p>
                            </div>
                            <div class="form-item">
                                <label class="form-label fs-14 text-default mb-1">Check Out</label>
                                <input name="checkout" type="date" id="checkout-date" class="form-control">
                                <p class="fs-12 mb-0" id="checkout-day"></p>
                            </div>
                            <div class="form-item">
                                <label class="form-label fs-14 text-default mb-1">Guests</label>
                                <input name="guests" type="number" id="guests" class="form-control" min="1" value="1">
                            </div>
                            <div class="form-item">
                                <label class="form-label fs-14 text-default mb-1">Rooms</label>
                                <input name="rooms" type="number" id="rooms" class="form-control" min="1" value="1">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary search-btn rounded">Search</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- /Hotel Search -->

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function () {
        function getFormattedDate(date) {
            let day = date.getDate().toString().padStart(2, '0');
            let month = (date.getMonth() + 1).toString().padStart(2, '0');
            let year = date.getFullYear();
            return `${year}-${month}-${day}`;
                    }

                    function getDayOfWeek(date) {
                        const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
                        return days[date.getDay()];
                    }

                    let today = new Date();
                    today.setHours(0, 0, 0, 0);
                    let tomorrow = new Date(today);
                    tomorrow.setDate(today.getDate() + 1);

                    $('#checkin-date').val(getFormattedDate(today));
                    $('#checkout-date').val(getFormattedDate(tomorrow));
                    $('#checkin-day').text(getDayOfWeek(today));
                    $('#checkout-day').text(getDayOfWeek(tomorrow));

                    $('#checkin-date').attr('min', getFormattedDate(today));
                    $('#checkout-date').attr('min', getFormattedDate(tomorrow));

                    $('#checkin-date').on('change', function () {
                        let checkin = new Date($(this).val());
                        let todayCheck = new Date();
                        todayCheck.setHours(0, 0, 0, 0);
                        if (checkin < todayCheck) {
                            alert('Check-in date cannot be in the past');
                            $(this).val(getFormattedDate(todayCheck));
                            checkin = todayCheck;
                        }

                        let checkout = new Date($('#checkout-date').val());
                        if (checkout <= checkin) {
                            checkout = new Date(checkin);
                            checkout.setDate(checkin.getDate() + 1);
                            $('#checkout-date').val(getFormattedDate(checkout));
                        }
                        $('#checkin-day').text(getDayOfWeek(checkin));
                        $('#checkout-date').attr('min', getFormattedDate(checkin));
                        $('#checkout-day').text(getDayOfWeek(checkout));
                    });

                    $('#checkout-date').on('change', function () {
                        let checkin = new Date($('#checkin-date').val());
                        let checkout = new Date($(this).val());
                        if (checkout <= checkin) {
                            alert('Check-out date must be after check-in date');
                            checkout = new Date(checkin);
                            checkout.setDate(checkin.getDate() + 1);
                            $(this).val(getFormattedDate(checkout));
                        }
                        $('#checkout-day').text(getDayOfWeek(checkout));
                    });

                    $('#location-input').on('input', function () {
                        var query = $(this).val();
                        if (query.length > 2) {
                            $.ajax({
                                url: 'https://nominatim.openstreetmap.org/search',
                                data: {q: query, format: 'json', addressdetails: 1, limit: 5},
                                success: function (data) {
                                    var suggestions = '';
                                    data.forEach(function (item) {
                                        suggestions += '<li class="list-group-item">' + item.display_name + '</li>';
                                    });
                                    $('#location-suggestions').html(suggestions).show();
                                }
                            });
                        } else {
                            $('#location-suggestions').hide();
                        }
                    });

                    $(document).on('click', '#location-suggestions li', function () {
                        $('#location-input').val($(this).text());
                        $('#location-suggestions').hide();
                    });
                });
</script>
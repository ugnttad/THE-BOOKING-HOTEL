<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Booking Cancel -->
<div class="modal fade" id="cancel-booking">
    <div class="modal-dialog  modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-body p-5">
                <form action="https://dreamstour.dreamstechnologies.com/html/customer-hotel-booking.html">
                    <div class="text-center">
                        <div class="mb-4">
                            <i class="isax isax-location-cross5 text-danger fs-40"></i>
                        </div>
                        <h5 class="mb-2">Are you sure you want to cancel booking?</h5>
                        <p class="mb-4 text-gray-9">Order ID : <span class="text-primary">#HB-1245</span></p>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Reason <span class="text-danger">*</span></label>
                        <textarea class="form-control" rows="3"></textarea>
                    </div>    
                    <div class="d-flex align-items-center justify-content-center">
                        <a href="#" class="btn btn-light me-2" data-bs-dismiss="modal">No, Dont Cancel</a>
                        <button type="submit" class="btn btn-primary">Yes, Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>  
<!-- /Booking Cancel -->
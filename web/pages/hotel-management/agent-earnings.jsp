<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <%@ include file="../../layout/head.jsp" %>
    </head>

    <body>

        <div class="main-header">
            <!-- Header -->
            <%@ include file="../../layout/header.jsp" %>
        </div>

        <!-- Breadcrumb -->
        <c:set var="name" value="Agent Earnings" scope="request" />
        <jsp:include page="../../layout/breadcrumb.jsp" />
        <!-- /Breadcrumb -->

        <!-- Page Wrapper -->
        <div class="content">
            <div class="container">

                <div class="row">

                    <!-- Sidebar -->
                    <%@ include file="../../layout/profile-sidebar.jsp" %>

                    <div class="col-xl-9 col-lg-8">
                        <div class="card border-0 bg-light">
                            <div class="card-body">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <h5>Payout Details</h5>
                                    <p class="fs-14">Expected payout on: 01 Apr 2025</p>
                                </div>
                                <div class="row align-items-center g-4">
                                    <div class="col-md-4">
                                        <div>
                                            <p class="mb-1">Amount to be paid</p>
                                            <h5>$<fmt:formatNumber value="${balanceUSD}" type="number" minFractionDigits="2" maxFractionDigits="2"/></h5>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div>
                                            <p class="mb-1">Last Withdrawn Payment</p>
                                            <h5>$<fmt:formatNumber value="${lastWithdrawn}" type="number" minFractionDigits="2" maxFractionDigits="2"/></h5>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="text-end">
                                            <a href="#withdraw_payment" data-bs-toggle="modal" class="btn btn-primary btn-sm">Withdraw Payment</a>
                                        </div>
                                    </div>
                                </div>
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger mt-3">${error}</div>
                                </c:if>
                                <c:if test="${param.success != null}">
                                    <div class="alert alert-success mt-3">${param.success}</div>
                                </c:if>
                            </div>
                        </div>

                        <div class="card shadow-none flex-fill">
                            <div class="card-body pb-0">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h6>Earnings</h6>
                                    <div class="dropdown ">
                                        <a href="javascript:void(0);" class="dropdown-toggle btn bg-light-200 btn-sm text-gray-6 rounded-pill fw-normal fs-14 d-inline-flex align-items-center" data-bs-toggle="dropdown">
                                            <i class="isax isax-calendar-2 me-2 fs-14 text-gray-6"></i>2025
                                        </a>
                                        <ul class="dropdown-menu  dropdown-menu-end p-3">
                                            <li>
                                                <a href="javascript:void(0);" class="dropdown-item rounded-1">
                                                    <i class="ti ti-point-filled me-1"></i>2025
                                                </a>
                                            </li>
                                            <li>
                                                <a href="javascript:void(0);" class="dropdown-item rounded-1">
                                                    <i class="ti ti-point-filled me-1"></i>2024
                                                </a>
                                            </li>
                                            <li>
                                                <a href="javascript:void(0);" class="dropdown-item rounded-1">
                                                    <i class="ti ti-point-filled me-1"></i>2023
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-2">
                                            <p class="mb-0">Total Earnings this Year</p>
                                            <div class="d-flex align-items-center">
                                                <h3>$20,659</h3>
                                                <p class="fs-14 ms-2">
                                                    <span class="badge badge-soft-success badge-md border border-success rounded-pill me-2">
                                                        <i class="isax isax-arrow-up-3 "></i>12%
                                                    </span>vs last years
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-2">
                                            <p class="mb-0">Total Earnings Last Year</p>
                                            <h3>$16,659</h3>
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div id="earning-chart"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="place-nav listing-nav">
                            <ul class="nav mb-2">
                                <li class="me-2">
                                    <a href="javascript:void(0);" class="nav-link active" data-bs-toggle="tab" data-bs-target="#earning-list">
                                        Earnings
                                    </a>
                                </li>
                                <li class="me-2">
                                    <a href="javascript:void(0);" class="nav-link" data-bs-toggle="tab" data-bs-target="#withdraw-list">
                                        Withdraw
                                    </a>
                                </li>
                            </ul>
                        </div>
                        <div class="tab-content">
                            <div class="tab-pane fade active show" id="earning-list">
                                <!-- Earning List -->
                                <div class="card hotel-list">
                                    <div class="card-body p-0">
                                        <div class="list-header d-flex align-items-center justify-content-between flex-wrap">
                                            <h6 class="">Invoices</h6>
                                            <div class="d-flex align-items-center flex-wrap">
                                                <div class="input-icon-start  me-2 position-relative">
                                                    <span class="icon-addon">
                                                        <i class="isax isax-search-normal-1 fs-14"></i>
                                                    </span>
                                                    <input type="text" class="form-control" placeholder="Search">
                                                </div>
                                                <div class="dropdown me-3">
                                                    <a href="javascript:void(0);" class="dropdown-toggle text-gray-6 btn  rounded border d-inline-flex align-items-center" data-bs-toggle="dropdown" aria-expanded="false">
                                                        Status
                                                    </a>
                                                    <ul class="dropdown-menu dropdown-menu-end p-3">
                                                        <li>
                                                            <a href="javascript:void(0);" class="dropdown-item rounded-1">Paid</a>
                                                        </li>
                                                        <li>
                                                            <a href="javascript:void(0);" class="dropdown-item rounded-1">Pending</a>
                                                        </li>
                                                        <li>
                                                            <a href="javascript:void(0);" class="dropdown-item rounded-1">Cancelled</a>
                                                        </li>
                                                    </ul>
                                                </div>
                                                <div class="d-flex align-items-center flex-wrap">
                                                    <div class="input-icon-start position-relative">
                                                        <span class="icon-addon">
                                                            <i class="isax isax-calendar-edit fs-14"></i>
                                                        </span>
                                                        <input type="text" class="form-control date-range bookingrange" placeholder="Select" value="Academic Year : 2024 / 2025">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="custom-datatable-filter table-responsive">
                                            <table class="table datatable">
                                                <thead class="thead-light">
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Invoice For</th>
                                                        <th>Service</th>
                                                        <th>Payment Type</th>
                                                        <th>Date</th>
                                                        <th>Amount</th>
                                                        <th>Status</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-1245</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">Hotel Atheena Plaza</p>
                                                        </td>
                                                        <td>
                                                            Hotel
                                                        </td>
                                                        <td>
                                                            Card
                                                        </td>
                                                        <td>15 May 2025, 10:00 AM</td>
                                                        <td>$11,569</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Paid</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-3215</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">Antonov-12</p>
                                                        </td>
                                                        <td>
                                                            Flight
                                                        </td>
                                                        <td>
                                                            Paypal
                                                        </td>
                                                        <td>20 May 2025, 10:00 AM</td>
                                                        <td>$12,543</td>
                                                        <td>
                                                            <span class="badge badge-secondary rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Pending</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-4581</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">The Queen of Ocean</p>
                                                        </td>
                                                        <td>
                                                            Cruise
                                                        </td>
                                                        <td>
                                                            Stripe
                                                        </td>
                                                        <td>27 May 2025, 10:00 AM</td>
                                                        <td>$14,697</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Paid</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-6545</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">Ford Mustang</p>
                                                        </td>
                                                        <td>
                                                            Car
                                                        </td>
                                                        <td>
                                                            Card
                                                        </td>
                                                        <td>12 Jun 2025, 10:00 AM</td>
                                                        <td>$10,528</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Paid</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-5769</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">PlayPalooza Part</p>
                                                        </td>
                                                        <td>
                                                            Tour
                                                        </td>
                                                        <td>
                                                            Stripe
                                                        </td>
                                                        <td>18 Jun 2025, 10:00 AM</td>
                                                        <td>$12,297</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Paid</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-4742</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">The Urban Retreat</p>
                                                        </td>
                                                        <td>
                                                            Hotel
                                                        </td>
                                                        <td>
                                                            Card
                                                        </td>
                                                        <td>22 Jun 2025, 10:00 AM</td>
                                                        <td>$18,349</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Paid</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-9364</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">Foodie Fiesta</p>
                                                        </td>
                                                        <td>
                                                            Tour
                                                        </td>
                                                        <td>
                                                            Stripe
                                                        </td>
                                                        <td>16 Jul 2025, 10:00 AM</td>
                                                        <td>$17,875</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Paid</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-6184</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">Nimbus 345</p>
                                                        </td>
                                                        <td>
                                                            Flight
                                                        </td>
                                                        <td>
                                                            Paypal
                                                        </td>
                                                        <td>25 Jul 2025, 10:00 AM</td>
                                                        <td>$15,175</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Paid</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-8207</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">The Grand Horizon</p>
                                                        </td>
                                                        <td>
                                                            Hotel
                                                        </td>
                                                        <td>
                                                            Card
                                                        </td>
                                                        <td>14 Jul 2025, 10:00 AM</td>
                                                        <td>$12,766</td>
                                                        <td>
                                                            <span class="badge badge-danger rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Cancelled</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#earning_invoice">#IN-3854</a></td>
                                                        <td>
                                                            <p class="text-dark mb-0 fw-medium fs-14">Mercedes-benz</p>
                                                        </td>
                                                        <td>
                                                            Car
                                                        </td>
                                                        <td>
                                                            Paypal
                                                        </td>
                                                        <td>28 Aug 2025, 10:00 AM</td>
                                                        <td>$13,496</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Paid</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#earning_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <!-- /Earning List -->
                                <div class="table-paginate d-flex justify-content-between align-items-center flex-wrap row-gap-3">
                                    <div class="value d-flex align-items-center">
                                        <span>Show</span>
                                        <select>
                                            <option>5</option>
                                            <option>10</option>
                                            <option>20</option>
                                        </select>
                                        <span>entries</span>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-center">
                                        <a href="javascript:void(0);"><span class="me-3"><i class="isax isax-arrow-left-2"></i></span></a>
                                        <nav aria-label="Page navigation">
                                            <ul class="paginations d-flex justify-content-center align-items-center">
                                                <li class="page-item me-2"><a class="page-link-1 active d-flex justify-content-center align-items-center " href="javascript:void(0);">1</a></li>
                                                <li class="page-item me-2"><a class="page-link-1 d-flex justify-content-center align-items-center" href="javascript:void(0);">2</a></li>
                                                <li class="page-item "><a class="page-link-1 d-flex justify-content-center align-items-center" href="javascript:void(0);">3</a></li>
                                            </ul>
                                        </nav>
                                        <a href="javascript:void(0);"><span class="ms-3"><i class="isax isax-arrow-right-3"></i></span></a>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane fade" id="withdraw-list">
                                <!-- Withdraw List List -->
                                <div class="card hotel-list">
                                    <div class="card-body p-0">
                                        <div class="list-header d-flex align-items-center justify-content-between flex-wrap">
                                            <h6>Invoices</h6>
                                            <div class="d-flex align-items-center flex-wrap">
                                                <div class="input-icon-start  me-2 position-relative">
                                                    <span class="icon-addon">
                                                        <i class="isax isax-search-normal-1 fs-14"></i>
                                                    </span>
                                                    <input type="text" class="form-control" placeholder="Search">
                                                </div>
                                                <div class="dropdown me-3">
                                                    <a href="javascript:void(0);" class="dropdown-toggle text-gray-6 btn  rounded border d-inline-flex align-items-center" data-bs-toggle="dropdown" aria-expanded="false">
                                                        Status
                                                    </a>
                                                    <ul class="dropdown-menu dropdown-menu-end p-3">
                                                        <li>
                                                            <a href="javascript:void(0);" class="dropdown-item rounded-1">Paid</a>
                                                        </li>
                                                        <li>
                                                            <a href="javascript:void(0);" class="dropdown-item rounded-1">Pending</a>
                                                        </li>
                                                        <li>
                                                            <a href="javascript:void(0);" class="dropdown-item rounded-1">Cancelled</a>
                                                        </li>
                                                    </ul>
                                                </div>
                                                <div class="d-flex align-items-center flex-wrap">
                                                    <div class="input-icon-start position-relative">
                                                        <span class="icon-addon">
                                                            <i class="isax isax-calendar-edit fs-14"></i>
                                                        </span>
                                                        <input type="text" class="form-control date-range bookingrange" placeholder="Select" value="Academic Year : 2024 / 2025">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="custom-datatable-filter table-responsive">
                                            <table class="table datatable">
                                                <thead class="thead-light">
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Date</th>
                                                        <th>Amount</th>
                                                        <th>Status</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-1245</a></td>                                                
                                                        <td>15 May 2025, 10:00 AM</td>
                                                        <td>$11,569</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Completed</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-3215</a></td>
                                                        <td>20 May 2025, 10:00 AM</td>
                                                        <td>$12,543</td>
                                                        <td>
                                                            <span class="badge badge-secondary rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Pending</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-4581</a></td>
                                                        <td>27 May 2025, 10:00 AM</td>
                                                        <td>$14,697</td>
                                                        <td>
                                                            <span class="badge badge-danger rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Cancelled</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-6545</a></td>
                                                        <td>12 Jun 2025, 10:00 AM</td>
                                                        <td>$10,528</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Completed</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-5769</a></td>
                                                        <td>18 Jun 2025, 10:00 AM</td>
                                                        <td>$12,297</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Completed</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-4742</a></td>
                                                        <td>22 Jun 2025, 10:00 AM</td>
                                                        <td>$18,349</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Completed</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-9364</a></td>
                                                        <td>16 Jul 2025, 10:00 AM</td>
                                                        <td>$17,875</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Completed</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-6184</a></td>
                                                        <td>25 Jul 2025, 10:00 AM</td>
                                                        <td>$15,175</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Completed</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-8207</a></td>
                                                        <td>14 Jul 2025, 10:00 AM</td>
                                                        <td>$12,766</td>
                                                        <td>
                                                            <span class="badge badge-danger rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Cancelled</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><a href="javascript:void(0);" class="link-primary fw-medium" data-bs-toggle="modal" data-bs-target="#withdraw_invoice">#WR-3854</a></td>
                                                        <td>28 Aug 2025, 10:00 AM</td>
                                                        <td>$13,496</td>
                                                        <td>
                                                            <span class="badge badge-success rounded-pill d-inline-flex align-items-center fs-10"><i class="fa-solid fa-circle fs-5 me-1"></i>Completed</span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#withdraw_invoice" class="me-2"><i class="isax isax-eye"></i></a>
                                                                <a href="#"><i class="isax isax-document-download"></i></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <!-- /Withdraw List -->
                                <div class="table-paginate d-flex justify-content-between align-items-center flex-wrap row-gap-3">
                                    <div class="value d-flex align-items-center">
                                        <span>Show</span>
                                        <select>
                                            <option>5</option>
                                            <option>10</option>
                                            <option>20</option>
                                        </select>
                                        <span>entries</span>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-center">
                                        <a href="javascript:void(0);"><span class="me-3"><i class="isax isax-arrow-left-2"></i></span></a>
                                        <nav aria-label="Page navigation">
                                            <ul class="paginations d-flex justify-content-center align-items-center">
                                                <li class="page-item me-2"><a class="page-link-1 active d-flex justify-content-center align-items-center " href="javascript:void(0);">1</a></li>
                                                <li class="page-item me-2"><a class="page-link-1 d-flex justify-content-center align-items-center" href="javascript:void(0);">2</a></li>
                                                <li class="page-item "><a class="page-link-1 d-flex justify-content-center align-items-center" href="javascript:void(0);">3</a></li>
                                            </ul>
                                        </nav>
                                        <a href="javascript:void(0);"><span class="ms-3"><i class="isax isax-arrow-right-3"></i></span></a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /Page Wrapper -->

        <!-- Footer -->
        <%@ include file="../../layout/footer.jsp" %>
        <!-- /Footer -->  

        <!-- Earnings Invoice Modal -->
        <div class="modal fade" id="earning_invoice" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog  modal-dialog-centered modal-lg invoice-modal">
                <div class="modal-content">
                    <div class="modal-body">
                        <div>
                            <div>
                                <div class="border-bottom mb-4">
                                    <div class="row justify-content-between align-items-center flex-wrap row-gap-4">
                                        <div class="col-md-6">
                                            <div class="mb-2 invoice-logo-dark">
                                                <img src="assets/img/logo-dark.svg" class="img-fluid" alt="logo">
                                            </div>
                                            <div class="mb-2 invoice-logo-white">
                                                <img src="assets/img/logo.svg" class="img-fluid" alt="logo">
                                            </div>
                                            <p class="fs-12">3099 Kennedy Court Framingham, MA 01702</p>
                                        </div>
                                        <div class="col-md-6">
                                            <div class=" text-end mb-3">
                                                <h6 class="text-default mb-1">Invoice No <span class="text-primary fw-medium">#INV0001</span></h6>
                                                <p class="fs-14 mb-1 fw-medium">Created Date : <span class="text-gray-9">Sep 24, 2023</span> </p>
                                                <p class="fs-14 fw-medium">Due Date : <span class="text-gray-9">Sep 30, 2023</span> </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="border-bottom mb-4">
                                    <div class="row align-items-center">
                                        <div class="col-md-5">
                                            <div class="mb-3">
                                                <h6 class="mb-3 fw-semibold fs-14">From</h6>
                                                <div>
                                                    <h6 class="mb-1">Thomas Lawler</h6>
                                                    <p class="fs-14 mb-1">2077 Chicago Avenue Orosi, CA 93647</p>
                                                    <p class="fs-14 mb-1">Email : <span class="text-gray-9"><a href="https://dreamstour.dreamstechnologies.com/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="047065766568653630303144617c65697468612a676b69">[email&#160;protected]</a></span></p>
                                                    <p class="fs-14">Phone : <span class="text-gray-9">+1 987 654 3210</span></p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="mb-3">
                                                <h6 class="mb-3 fw-semibold fs-14">To</h6>
                                                <div>
                                                    <h6 class="mb-1">Sara Inc,.</h6>
                                                    <p class="fs-14 mb-1">3103 Trainer Avenue Peoria, IL 61602</p>
                                                    <p class="fs-14 mb-1">Email : <span class="text-gray-9"><a href="https://dreamstour.dreamstechnologies.com/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="4f3c2e3d2e1026212c7c7b0f2a372e223f232a612c2022">[email&#160;protected]</a></span></p>
                                                    <p class="fs-14">Phone : <span class="text-gray-9">+1 987 471 6589</span></p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="mb-3">
                                                <h6 class="mb-1 fs-14 fw-medium">Payment Status </h6>
                                                <span class="badge badge-success align-items-center fs-10 mb-4"><i class="ti ti-point-filled "></i>Paid</span>
                                                <div>
                                                    <img src="assets/img/invoice/qr.svg" class="img-fluid" alt="QR">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <p class="fw-medium mb-3">Invoice For : <span class="text-dark fw-medium">Hotel Booking</span></p>
                                    <div class="table-responsive">
                                        <table class="table invoice-table">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th class="w-50 bg-light-400">Description</th>
                                                    <th class="text-center bg-light-400">Qty</th>
                                                    <th class="text-end bg-light-400">Cost</th>
                                                    <th class="text-end bg-light-400">Discount</th>
                                                    <th class="text-end bg-light-400">Total</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <h6 class="fs-14">Hotel Booking ( Hotel Plaza Athenee ) </h6>
                                                    </td>
                                                    <td class="text-gray fs-14 fw-medium text-center">1</td>
                                                    <td class="text-gray fs-14 fw-medium text-end">$2000</td>
                                                    <td class="text-gray fs-14 fw-medium text-end">$150</td>
                                                    <td class="text-gray fs-14 fw-medium text-end">$1800</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <h6 class="fs-14">Additional Service ( Airport Pickup, Breakfast )</h6>
                                                    </td>
                                                    <td class="text-gray fs-14 fw-medium text-center">1</td>
                                                    <td class="text-gray fs-14 fw-medium text-end">$200</td>
                                                    <td class="text-gray fs-14 fw-medium text-end">$50</td>
                                                    <td class="text-gray fs-14 fw-medium text-end">$150</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="border-bottom mb-3">
                                    <div class="row">
                                        <div class="col-md-7">
                                            <div class="py-4">
                                                <div class="mb-3">
                                                    <h6 class="fs-14 mb-1">Terms and Conditions</h6>
                                                    <p class="fs-12">Please pay within 15 days from the date of invoice, overdue interest @ 14% will be charged on delayed payments.</p>
                                                </div>
                                                <div class="mb-3">
                                                    <h6 class="fs-14 mb-1">Notes</h6>
                                                    <p class="fs-12">Please quote invoice number when remitting funds.</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="d-flex justify-content-between align-items-center border-bottom mb-2 pe-3">
                                                <p class="fs-14 fw-medium text-gray mb-0">Sub Total</p>
                                                <p class="text-gray-9 fs-14 fw-medium mb-2">$2000</p>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center border-bottom mb-2 pe-3">
                                                <p class="fs-14 fw-medium text-gray mb-0">Discount (0%)</p>
                                                <p class="text-gray-9 fs-14 fw-medium mb-2">$100</p>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mb-2 pe-3">
                                                <p class="fs-14 fw-medium text-gray mb-0">VAT (5%)</p>
                                                <p class="text-gray-9 fs-14 fw-medium mb-2">$55</p>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mb-2 pe-3">
                                                <h6>Total Amount</h6>
                                                <h6>$1955</h6>
                                            </div>
                                            <p class="fs-12">
                                                Amount in Words : Dollar Thousand Nine Fifty Five
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="border-bottom mb-3 me-2">
                                    <div class="row justify-content-end align-items-end text-end">
                                        <div class="col-md-3">
                                            <div class="text-end">
                                                <img src="assets/img/invoice/sign.svg" class="img-fluid" alt="sign">
                                            </div>
                                            <div class="text-end mb-3">
                                                <h6 class="fs-14 fw-medium pe-3">Ted M. Davis</h6>
                                                <p>Assistant Manager</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-center">
                                    <div class="mb-3 invoice-logo-dark">
                                        <img src="assets/img/logo-dark.svg" class="img-fluid" alt="logo">
                                    </div>
                                    <div class="mb-3 invoice-logo-white">
                                        <img src="assets/img/logo.svg" class="img-fluid" alt="logo">
                                    </div>
                                    <p class="text-gray-9 fs-12 mb-1">Payment Made Via bank transfer / Cheque in the name of Thomas Lawler</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /Earnings Invoice Modal -->

        <!-- Withdraw Invoice Modal -->
        <div class="modal fade" id="withdraw_invoice" aria-hidden="true">
            <div class="modal-dialog  modal-dialog-centered modal-lg invoice-modal">
                <div class="modal-content">
                    <div class="modal-body">
                        <div>
                            <div>
                                <div class="border-bottom mb-4">
                                    <div class="row justify-content-between align-items-center flex-wrap row-gap-4">
                                        <div class="col-md-6">
                                            <div class="mb-2 invoice-logo-dark">
                                                <img src="assets/img/logo-dark.svg" class="img-fluid" alt="logo">
                                            </div>
                                            <div class="mb-2 invoice-logo-white">
                                                <img src="assets/img/logo.svg" class="img-fluid" alt="logo">
                                            </div>
                                            <p class="fs-12">3099 Kennedy Court Framingham, MA 01702</p>
                                        </div>
                                        <div class="col-md-6">
                                            <div class=" text-end mb-3">
                                                <h6 class="text-default mb-1">Invoice No <span class="text-primary fw-medium">#WRV0001</span></h6>
                                                <p class="fs-14 mb-1 fw-medium">Date : <span class="text-gray-9">Sep 24, 2023</span> </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="border-bottom mb-4">
                                    <div class="row align-items-center">
                                        <div class="col-md-5">
                                            <div class="mb-3">
                                                <h6 class="mb-3 fw-semibold fs-14">From</h6>
                                                <div>
                                                    <h6 class="mb-1">Thomas Lawler</h6>
                                                    <p class="fs-14 mb-1">2077 Chicago Avenue Orosi, CA 93647</p>
                                                    <p class="fs-14 mb-1">Email : <span class="text-gray-9"><a href="https://dreamstour.dreamstechnologies.com/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="c9bda8bba8a5a8fbfdfdfc89acb1a8a4b9a5ace7aaa6a4">[email&#160;protected]</a></span></p>
                                                    <p class="fs-14">Phone : <span class="text-gray-9">+1 987 654 3210</span></p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="mb-3">
                                                <h6 class="mb-3 fw-semibold fs-14">To</h6>
                                                <div>
                                                    <h6 class="mb-1">Sara Inc,.</h6>
                                                    <p class="fs-14 mb-1">3103 Trainer Avenue Peoria, IL 61602</p>
                                                    <p class="fs-14 mb-1">Email : <span class="text-gray-9"><a href="https://dreamstour.dreamstechnologies.com/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="51223023300e383f326265113429303c213d347f323e3c">[email&#160;protected]</a></span></p>
                                                    <p class="fs-14">Phone : <span class="text-gray-9">+1 987 471 6589</span></p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="mb-3">
                                                <h6 class="mb-1 fs-14 fw-medium">Payment Status </h6>
                                                <span class="badge badge-success align-items-center fs-10 mb-4"><i class="ti ti-point-filled "></i>Completed</span>
                                                <div>
                                                    <img src="assets/img/invoice/qr.svg" class="img-fluid" alt="QR">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div>
                                    <p class="fw-medium mb-3">Invoice For : <span class="text-dark fw-medium">Hotel Booking</span></p>
                                    <div class="table-responsive">
                                        <table class="table invoice-table">
                                            <thead class="thead-light">
                                                <tr>
                                                    <th class="w-50 bg-light-400">Description</th>
                                                    <th class="text-end bg-light-400">Cost</th>
                                                    <th class="text-end bg-light-400">Total</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <h6 class="fs-14">Withdrawn payment (15 Jan 2025 - 12 Feb 2025)</h6>
                                                    </td>
                                                    <td class="text-gray fs-14 fw-medium text-end">$2000</td>
                                                    <td class="text-gray fs-14 fw-medium text-end">$1800</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="border-bottom mb-3">
                                    <div class="row">
                                        <div class="col-md-7">
                                            <div class="py-4">
                                                <div class="mb-3">
                                                    <h6 class="fs-14 mb-1">Terms and Conditions</h6>
                                                    <p class="fs-12">Please pay within 15 days from the date of invoice, overdue interest @ 14% will be charged on delayed payments.</p>
                                                </div>
                                                <div class="mb-3">
                                                    <h6 class="fs-14 mb-1">Notes</h6>
                                                    <p class="fs-12">Please quote invoice number when remitting funds.</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="d-flex justify-content-between align-items-center border-bottom mb-2 pe-3">
                                                <p class="fs-14 fw-medium text-gray mb-0">Sub Total</p>
                                                <p class="text-gray-9 fs-14 fw-medium mb-2">$2000</p>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center border-bottom mb-2 pe-3">
                                                <p class="fs-14 fw-medium text-gray mb-0">Discount (0%)</p>
                                                <p class="text-gray-9 fs-14 fw-medium mb-2">$100</p>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mb-2 pe-3">
                                                <p class="fs-14 fw-medium text-gray mb-0">VAT (5%)</p>
                                                <p class="text-gray-9 fs-14 fw-medium mb-2">$55</p>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mb-2 pe-3">
                                                <h6>Total Amount</h6>
                                                <h6>$1955</h6>
                                            </div>
                                            <p class="fs-12">
                                                Amount in Words : Dollar Thousand Nine Fifty Five
                                            </p>
                                        </div>
                                    </div>
                                </div>
                                <div class="border-bottom mb-3 me-2">
                                    <div class="row justify-content-end align-items-end text-end">
                                        <div class="col-md-3">
                                            <div class="text-end">
                                                <img src="assets/img/invoice/sign.svg" class="img-fluid" alt="sign">
                                            </div>
                                            <div class="text-end mb-3">
                                                <h6 class="fs-14 fw-medium pe-3">Ted M. Davis</h6>
                                                <p>Assistant Manager</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-center">
                                    <div class="mb-3 invoice-logo-dark">
                                        <img src="assets/img/logo-dark.svg" class="img-fluid" alt="logo">
                                    </div>
                                    <div class="mb-3 invoice-logo-white">
                                        <img src="assets/img/logo.svg" class="img-fluid" alt="logo">
                                    </div>
                                    <p class="text-gray-9 fs-12 mb-1">Payment Made Via bank transfer / Cheque in the name of Thomas Lawler</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /Withdraw Invoice Modal -->

        <!-- Withdraw Payment Modal -->
        <div class="modal fade" id="withdraw_payment" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Withdraw Payment</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/wallet" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="withdraw">
                            <div class="mb-3">
                                <label for="amount" class="form-label">Amount (USD)</label>
                                <input type="number" step="0.01" class="form-control" id="amount" name="amount" required>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Withdraw</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- /Withdraw Payment Modal -->

        <!-- Cursor -->
        <%@ include file="../../layout/cursor.jsp" %>
        <!-- /Cursor -->

        <!-- Back to top -->
        <%@ include file="../../layout/back-to-top.jsp" %>

        <!-- Script -->
        <%@ include file="../../layout/script.jsp" %>
    </body>
</html>
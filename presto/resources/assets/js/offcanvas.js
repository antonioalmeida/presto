$(function () {
    'use strict'

    $('[data-toggle="offcanvas"]').on('click', function () {
        $('.offcanvas-collapse').toggleClass('open')
    })
})

$("#checkAll").change(function () {
    $(".typeFilter input:checkbox").prop('checked', $(this).prop("checked"));
});
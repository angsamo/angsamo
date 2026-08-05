document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("form[data-confirm]").forEach(function (form) {
        form.addEventListener("submit", function (event) {
            if (!window.confirm(form.dataset.confirm)) event.preventDefault();
        });
    });

    var today = new Date().toISOString().slice(0, 10);
    document.querySelectorAll('input[name="deliveryDate"]').forEach(function (input) {
        input.min = today;
    });
});

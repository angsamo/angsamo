document.querySelectorAll('[data-table-search]').forEach(function (input) {
	var table = document.getElementById(input.dataset.tableSearch);
	input.addEventListener('input', function () {
		var keyword = input.value.trim().toLowerCase();
		table.querySelectorAll('tbody tr').forEach(function (row) {
			var values = row.textContent + ' ' + Array.from(row.querySelectorAll('input,select')).map(function (field) {
				return field.value + ' ' + (field.selectedOptions && field.selectedOptions[0] ? field.selectedOptions[0].text : '');
			}).join(' ');
			row.hidden = !values.toLowerCase().includes(keyword);
		});
	});
});

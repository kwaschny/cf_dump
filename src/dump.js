/* to be minified and put into dump.cfm */

document.addEventListener('DOMContentLoaded', function() {

	if (typeof window.__cf_dump_head !== 'undefined') { return; }
	window.__cf_dump_head = true;

	var i, b;

	var toggleVisibility = function() {

	};

	var colHeaders = document.querySelectorAll('.cf_dump .colheader');
	var toggleHeader = function(source, targets) {

		var n, child;

		if (source.getAttribute('data-cf_dump_collapsed') === null) {

			for (n = 0; n < targets.length; n++) {

				child = targets[n];

				if (
					child.classList.contains('row') ||
					child.classList.contains('colfooter')
				) {

					child.classList.add('hidden');
				}
			}

			source.setAttribute('data-cf_dump_collapsed', '');

		} else {

			for (n = 0; n < targets.length; n++) {

				child = targets[n];

				if (
					child.classList.contains('row') ||
					child.classList.contains('colfooter')
				) {

					child.classList.remove('hidden');
				}
			}

			source.removeAttribute('data-cf_dump_collapsed');
		}
	};

	for (i = 0; i < colHeaders.length; i++) {

		colHeaders[i].addEventListener('click', function(event) {

			if (event.target.nodeName === 'A') { return; }

			var source = this;
			var rows   = source.parentNode.children;

			toggleHeader(source, rows);
		});

		b = colHeaders[i].querySelector('a.toggle');
		if (b) {

			b.addEventListener('click', function() {

				var rows = this.parentNode.parentNode.children;

				for (var n = 1; n < rows.length; n++) {

					var row       = rows[n];
					var rowHeader = ( (row.children.length === 2) ? row.children[0] : undefined );
					var cellVar   = ( rowHeader ? row.children[1].children[0] : row.children[0].children[0] );

					if (rowHeader && cellVar.classList.contains('empty')) {

						toggleRowCell(rowHeader, row.children);

					} else if (cellVar.children.length > 0) {

						var toggle = cellVar.children[0].querySelector('a.toggle');
						if (toggle) {

							toggle.click();
						}
					}
				}
			});
		}
	}

	var rowHeaders = document.querySelectorAll('.cf_dump .rowheader');
	var toggleRowCell = function(source, targets) {

		var n, child;

		if (source.getAttribute('data-cf_dump_collapsed') === null) {

			for (n = 0; n < targets.length; n++) {

				child = targets[n];

				if (
					child.classList.contains('rowcell')
				) {

					child.classList.add('hidden');
				}
			}

			source.setAttribute('data-cf_dump_collapsed', '');

		} else {

			for (n = 0; n < targets.length; n++) {

				child = targets[n];

				if (
					child.classList.contains('rowcell')
				) {

					child.classList.remove('hidden');
				}
			}

			source.removeAttribute('data-cf_dump_collapsed');
		}
	};

	for (i = 0; i < rowHeaders.length; i++) {

		rowHeaders[i].addEventListener('click', function() {

			var source = this;
			var column = source.getAttribute('data-cf_dump_querycolumn');
			var cells;

			if (source.getAttribute('data-cf_dump_querycolumn') !== null) {

				var parent = source.parentNode.parentNode;
					cells  = parent.querySelectorAll('.rowcell[data-cf_dump_querycell="' + column + '"]');

				toggleRowCell(source, cells);

			} else {

				cells = source.parentNode.children;

				toggleRowCell(source, cells);
			}

		});
	}

});

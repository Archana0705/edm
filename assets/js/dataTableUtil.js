window.loadDataToTable = function ({
    tableId,
    apiUrl,
    httpMethod = 'GET',
    payload = {},
    rowBuilder
}) {
    debugger
    const tableBody = $(`#${tableId} tbody`);
    tableBody.html('<tr><td colspan="10" class="text-center">Loading...</td></tr>');

    const ajaxOptions = {
        url: apiUrl,
        method: httpMethod.toUpperCase(),
        contentType: 'application/json',
        success: function (response) {
            const tableData = response.data || [];
            tableBody.empty();

            if (tableData.length === 0) {
                tableBody.html('<tr><td colspan="10" class="text-center">No Data Found</td></tr>');
                return;
            }

            if ($.fn.DataTable && $.fn.DataTable.isDataTable(`#${tableId}`)) {
                $(`#${tableId}`).DataTable().clear().destroy();
            }

            let tableRows = '';
            tableData.forEach(item => {
                tableRows += rowBuilder(item);
            });

            tableBody.html(tableRows);

            $(`#${tableId}`).DataTable({
                paging: true,
                searching: true,
                ordering: true,
                responsive: true,
            });
        },
        error: function (xhr, status, error) {
            console.error("API Error: ", error);
            tableBody.html('<tr><td colspan="10" class="text-center">Failed to load data</td></tr>');
        }
    };

    if (httpMethod.toUpperCase() !== 'GET') {
        ajaxOptions.data = JSON.stringify(payload);
    } else if (Object.keys(payload).length > 0) {
        const params = new URLSearchParams(payload).toString();
        ajaxOptions.url += `?${params}`;
    }

    $.ajax(ajaxOptions);
};

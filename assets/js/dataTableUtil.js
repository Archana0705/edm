
import { decryptData } from './encrypt_decrypt.js';
window.loadDataToTable = function ({
    tableId,
    apiUrl,
    httpMethod = 'POST',
    payload,
    rowBuilder
}) {

    debugger
    const tableSelector = `#${tableId}`;
    const tableBody = $(`${tableSelector} tbody`);
    tableBody.html('<tr><td colspan="10" class="text-center">Loading...</td></tr>');

    $.ajax({
        url: apiUrl,
        method: httpMethod.toUpperCase(),
        headers: {
            'X-APP-Key': "edm",
            'X-APP-Name': "edm"
        },
        data: {
            data: payload
        },
        dataType: 'json',
        cache: false,
        success(response) {
            // const response = response.data || [];
            var data = decryptData(response.data);

            tableBody.empty();

            if (data.length === 0) {
                tableBody.html('<tr><td colspan="10" class="text-center">No Data Found</td></tr>');
                return;
            }

            if ($.fn.DataTable?.isDataTable(tableSelector)) {
                $(tableSelector).DataTable().clear().destroy();
            }

            const rows = data.map(rowBuilder).join('');
            tableBody.html(rows);

            $(tableSelector).DataTable({
                paging: true,
                searching: true,
                ordering: true,
                responsive: true,
            });
        },
        error(xhr, status, error) {
            console.error("API Error:", error);
            tableBody.html('<tr><td colspan="10" class="text-center">Failed to load data</td></tr>');
        }
    });
};

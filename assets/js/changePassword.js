// Only run this when popup already exists in DOM
const userDetailsEncrypted = localStorage.getItem('userDetails');
const secretKey = 'V7gN4dY8pT2xB3kRz';
let userId = '';
if (userDetailsEncrypted) {
    const decrypted = CryptoJS.AES.decrypt(userDetailsEncrypted, secretKey).toString(CryptoJS.enc.Utf8);
    const user = JSON.parse(decrypted);
    userId = user.user_id;
}

$(document).on('click', '#changePasswordSubmit', function () {
    const oldPassword = $('#Old_password_input').val();
    const newPassword = $('#New_password_input').val();

    if (!oldPassword || !newPassword) {
        showErrorToast("Please fill all required fields");
        return;
    }

    const formData = new FormData();
    formData.append('employee_id', userId);
    formData.append('old_password', oldPassword);
    formData.append('new_password', newPassword);

    $.ajax({
        url: 'https://tngis.tnega.org/lcap_api/jallikattu/v1/access/change_password',
        type: 'POST',
        headers: {
            'X-App-Key': 'j6ll!k@ttu',
            'X-App-Name': 'tn jallikattu',
        },
        data: formData,
        processData: false,
        contentType: false,
        success: function () {
            showSuccessToast("Password Changed Successfully");
            setTimeout(() => $('#popup-overlay').fadeOut(), 1000);
            $('.t-Header').css('z-index', '800');
        },
        error: function () {
            showErrorToast('Error occurred during password change');
        }
    });
});

$(document).on('click', '#close-popup, #popup-overlay', function () {
    $('#popup-overlay').fadeOut();
    $('.t-Header').css('z-index', '800');
});

$(document).on('click', '#popup-content', function (e) {
    e.stopPropagation();
});

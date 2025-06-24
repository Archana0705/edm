$(document).on('click', '#myProfileLink', function (e) {
    e.preventDefault();
    $('#profile-overlay').fadeIn();
    $('.t-Header').css('z-index', '0');

    // Load user details from localStorage
    const encrypted = localStorage.getItem('userDetails');
    const secretKey = 'V7gN4dY8pT2xB3kRz';

    if (encrypted) {
        const decrypted = CryptoJS.AES.decrypt(encrypted, secretKey).toString(CryptoJS.enc.Utf8);
        const user = JSON.parse(decrypted);

        $('#name').val(user.name || '');
        $('#district').val(user.district || '');
        $('#mobile').val(user.mobile || '');
        $('#email').val(user.email || '');
    }

    $('#close-profile, #profile-overlay').on('click', function () {
        $('#profile-overlay').fadeOut();
        $('.t-Header').css('z-index', '800');
    });

    $('#profile-content').on('click', function (e) {
        e.stopPropagation();
    });

    $('#profile-form').on('submit', function (e) {
        e.preventDefault();
        // You can add form validation and an API call here
        showSuccessToast('Profile updated successfully');
    });
});

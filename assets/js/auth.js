// auth.js
(function () {
    debugger
    const secretKey = 'V7gN4dY8pT2xB3kRz';

    // Create a sample user object
    const sampleUser = {
        user_id: 12345,
        name: "John Doe",
        role: "admin"
    };

    // Encrypt and store the user data if not already stored
    if (!localStorage.getItem('userDetails')) {
        const encrypted = CryptoJS.AES.encrypt(JSON.stringify(sampleUser), secretKey).toString();
        localStorage.setItem('userDetails', encrypted);
    }

    // Decrypt and load session
    const encryptedDataFromStorage = localStorage.getItem('userDetails');
    const bytes = CryptoJS.AES.decrypt(encryptedDataFromStorage, secretKey);
    const decryptedData = bytes.toString(CryptoJS.enc.Utf8);

    try {
        const user = JSON.parse(decryptedData);
        window.userSession = {
            userId: user.user_id,
            name: user.name,
            role: user.role
        };

        // Display user's name if the target element exists
        const userNameElement = document.querySelector('.t-Button-label');
        if (userNameElement && user.name) {
            userNameElement.textContent = user.name;
            window.location.href = "../dashboard.html";
        }

        console.log("User session loaded:", window.userSession);
    } catch (e) {
        console.error('Error decoding userDetails:', e);
        localStorage.clear();
        sessionStorage.clear();
        window.location.href = "../index.html";
    }
})();

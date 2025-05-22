function initializeUserSession() {
    debugger
    const secretKey = 'V7gN4dY8pT2xB3kRz';
    const sampleUser = {
        user_id: 101,
        name: "John Doe",
        role: "edistrict_manager"
    };

    const encrypted = CryptoJS.AES.encrypt(JSON.stringify(sampleUser), secretKey).toString();
    localStorage.setItem('userDetails', encrypted);

    const bytes = CryptoJS.AES.decrypt(encrypted, secretKey);
    const decrypted = bytes.toString(CryptoJS.enc.Utf8);
    const user = JSON.parse(decrypted);

    window.userSession = {
        userId: user.user_id,
        name: user.name,
        role: user.role
    };

    const userNameElement = document.querySelector('.t-Button-label');
    if (userNameElement) userNameElement.textContent = user.name;
}

// window.initializeUserSession = initializeUserSession;
export { initializeUserSession };
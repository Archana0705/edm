// function initializeUserSession() {
//     debugger
//     const secretKey = 'V7gN4dY8pT2xB3kRz';
//     const sampleUser = {
//         user_id: 101,
//         name: "John Doe",
//         role: "edistrict_manager"
//     };

//     const encrypted = CryptoJS.AES.encrypt(JSON.stringify(sampleUser), secretKey).toString();
//     localStorage.setItem('userDetails', encrypted);

//     const bytes = CryptoJS.AES.decrypt(encrypted, secretKey);
//     const decrypted = bytes.toString(CryptoJS.enc.Utf8);
//     const user = JSON.parse(decrypted);

//     window.userSession = {
//         userId: user.user_id,
//         name: user.name,
//         role: user.role
//     };

//     const userNameElement = document.querySelector('.t-Button-label');
//     if (userNameElement) userNameElement.textContent = user.name;
// }

// // window.initializeUserSession = initializeUserSession;
// export { initializeUserSession };

import { encryptData, decryptData } from './encrypt_decrypt.js';

function initializeUserSession(mobnumber, password) {
    console.log("mobile number", mobnumber);
    const payload = {
        action: "function_call",
        function_name: "get_user_authentication_fun",
        params: {
            mobnumber: parseInt(mobnumber),
            password: password
        }
    };

    //check
    const apiUrl = "https://tngis.tnega.org/lcap_api/edm/v1/commonfunction";

    $.ajax({
        url: apiUrl,
        method: "POST",
        headers: {
            'X-APP-Key': "edm",
            'X-APP-Name': "edm"
        },
        data: {
            data: encryptData(payload)
        },
        dataType: 'json',
        cache: false,
        success: function (response) {
            console.log("Raw API response:", response); // Log raw response

            try {
                if (response && response.data) {
                    console.log("Encrypted data received:", response.data);
                    var decryptedResponse = decryptData(response.data);
                    console.log(response);

                    if (!Array.isArray(decryptedResponse) || decryptedResponse.length === 0) {
                        throw new Error("Invalid decrypted data format");
                    }

                    const decrypted = decryptedResponse[0];
                    console.log("Decrypted user data:", decrypted);
                    window.userSession = {
                        userId: decrypted.user_id,
                        name: decrypted.name,
                        role: decrypted.designation || ''
                    };

                    localStorage.setItem('userRole', decrypted.designation || '');
                    localStorage.setItem('userId', decrypted.user_id || '');
                    const userNameElement = document.querySelector('.t-Button-label');
                    if (userNameElement) userNameElement.textContent = decrypted.name;
                } else {
                    console.error("Invalid response structure - missing data field");
                }
            } catch (error) {
                console.error("Error processing response:", error);
            }
        },
        error: function (xhr, status, error) {
            console.error("API call failed:", {
                status: xhr.status,
                statusText: xhr.statusText,
                responseText: xhr.responseText,
                error: error
            });
        }
    });
}

export { initializeUserSession };
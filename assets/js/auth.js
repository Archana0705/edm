async function initializeUserSession(mobnumber, password) {
    return new Promise((resolve, reject) => {
        const payload = {
            action: "function_call",
            function_name: "get_user_authentication_fun",
            params: {
                mobnumber: parseInt(mobnumber),
                password: password
            }
        };

        const apiUrl = "https://tngis.tnega.org/lcap_api/edm/v1/commonfunction";

        $.ajax({
            url: apiUrl,
            method: "POST",
            headers: {
                'X-APP-Key': "edm",
                'X-APP-Name': "edm"
            },
            data: {
                data: window.encryptData(payload)
            },
            dataType: 'json',
            cache: false,
            success: function (response) {
                try {
                    if (response && response.data) {
                        var decryptedResponse = window.decryptData(response.data);

                        if (!Array.isArray(decryptedResponse) || decryptedResponse.length === 0) {
                            throw new Error("Invalid decrypted data format");
                        }

                        const decrypted = decryptedResponse[0];
                        window.userSession = {
                            userId: decrypted.user_id,
                            name: decrypted.name,
                            role: decrypted.designation || ''
                        };

                        localStorage.setItem('userRole', decrypted.designation || '');
                        localStorage.setItem('userDistrict', decrypted.district);
                        localStorage.setItem('userName', decrypted.name);
                        localStorage.setItem('userId', decrypted.user_id || '');

                        const userNameElement = document.querySelector('.t-Button-label');
                        if (userNameElement) userNameElement.textContent = decrypted.name;

                        resolve();
                    } else {
                        console.error("Invalid response structure - missing data field");
                        reject(new Error("Invalid response structure"));
                    }
                } catch (error) {
                    console.error("Error processing response:", error);
                    reject(error);
                }
            },
            error: function (xhr, status, error) {
                console.error("API call failed:", {
                    status: xhr.status,
                    statusText: xhr.statusText,
                    responseText: xhr.responseText,
                    error: error
                });
                reject(new Error("API call failed"));
            }
        });
    });
}

// Make it globally accessible
window.initializeUserSession = initializeUserSession;

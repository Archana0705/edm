
$(document).ready(function () {
    function encryptData(data) {
        const secretKey = "xmcK|fbngp@!71L$";
        const key = CryptoJS.enc.Hex.parse(CryptoJS.SHA256(secretKey).toString()); // Derive 256-bit key
        const iv = CryptoJS.lib.WordArray.random(16); // Generate random IV

        const encrypted = CryptoJS.AES.encrypt(JSON.stringify(data), key, {
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7, // Ensure PKCS7 padding
        });

        // Combine IV and ciphertext
        const combinedData = iv.concat(encrypted.ciphertext);

        // Return Base64 encoded result
        return CryptoJS.enc.Base64.stringify(combinedData);
        // return data;
    }

    // Decryption Function

    function decryptData(encryptedData) {
        const secretKey = "xmcK|fbngp@!71L$"; // Same secret key
        const key = CryptoJS.enc.Hex.parse(CryptoJS.SHA256(secretKey).toString()); // Derive 256-bit key

        // Decode Base64 and split IV and ciphertext
        const decodedData = CryptoJS.enc.Base64.parse(encryptedData).toString(CryptoJS.enc.Hex);
        const ivHex = decodedData.slice(0, 32); // First 16 bytes (IV)
        const cipherHex = decodedData.slice(32); // Remaining bytes (Ciphertext)

        const iv = CryptoJS.enc.Hex.parse(ivHex); // Parse IV
        const ciphertext = CryptoJS.enc.Hex.parse(cipherHex); // Parse Ciphertext

        // Decrypt using AES-256-CBC
        const decrypted = CryptoJS.AES.decrypt(
            { ciphertext: ciphertext },
            key,
            {
                iv: iv,
                mode: CryptoJS.mode.CBC,
                padding: CryptoJS.pad.Pkcs7, // Default padding
            }
        );

        // Convert decrypted data to a string
        return JSON.parse(decrypted.toString(CryptoJS.enc.Utf8));
    }

    localStorage.getItem('userMob')
    const apiUrl = 'https://tngis.tnega.org/lcap_api/edm/v1/commonfunction';
    const userId = localStorage.getItem('userId');
    const secretKey = 'V7gN4dY8pT2xB3kRz';
    const district = localStorage.getItem('userDistrict');
    const username = localStorage.getItem('userName');
    const mobnumber = localStorage.getItem('userMob');
    const payload = {
        action: "function_call",
        function_name: "user_profile_fn",
        params: {
            p_mobile: mobnumber
        }
    };

    $.ajax({
        url: apiUrl,
        method: 'POST',
        headers: {
            'X-APP-Key': 'edm',
            'X-APP-Name': 'edm'
        },
        data: {
            data: encryptData(payload)
        },
        dataType: 'json',
        success(response) {
            const decrypted = decryptData(response.data);
            console.log("response:", decrypted);
            $('#P66_NAME').val(decrypted[0].name);
            $('#P66_MOBILE').val(decrypted[0].mobile);
            $('#P66_EMAIL').val(decrypted[0].email);

            // Populate the dropdown
            const $dropdown = $('#P7_LOCATION');
            $dropdown.empty().append('<option value="" class="placeholder">--Select Taluk--</option>');

            decrypted.forEach(item => {
                $dropdown.append(`<option value="${item.taluk_name}">${item.taluk_name}</option>`);
            });


        },
        error(xhr, status, error) {
            console.error("Taluk API Error:", error);
            alert("Failed to load Taluk data.");
        }
    });


    console.log(payload);

    $(document).on('click', '#submitBtn', function (event) {

        event.preventDefault();
        alert("hi")
        // Get form field values
        var name = $('#P66_NAME').val();
        var district = $('#P66_DISTRICT').val();
        var mobile = $('#P66_MOBILE').val();

        // Optional validation
        if (!name || !district || !mobile) {
            alert("Please fill all required fields.");
            return;
        }

        var payload = {
            action: "function_call",
            function_name: "save_profile_details",
            params: {
                name: name,
                district: district,
                mobile: mobile,
                updated_by: userId // Ensure this is defined globally
            }
        };

        console.log("Submitting profile payload:", payload);

        $.ajax({
            url: apiUrl, // Replace or define globally
            method: "POST",
            headers: {
                'X-APP-Key': "edm",
                'X-APP-Name': "edm"
            },
            data: {
                data: encryptData(payload) // Ensure encryptData() is defined globally
            },
            dataType: 'json',
            cache: false,
            success: function (response) {
                console.log("Profile updated successfully:", response);
                showSuccessToast("Profile updated successfully!");

                // Close modal and reset
                $('#profile-overlay').hide();
                $('#P66_NAME').val('');
                $('#P66_DISTRICT').val('').trigger('change');
                $('#P66_MOBILE').val('');
            },
            error: function (xhr, status, error) {
                console.error("Profile update failed:", {
                    status: xhr.status,
                    statusText: xhr.statusText,
                    responseText: xhr.responseText,
                    error: error
                });
                alert("An error occurred while updating profile.");
            }
        });
    });


    // Close button handler
    $('#closeBtn').on('click', function () {
        $('#profile-overlay').hide();
    });
});


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
            const preselectedTaluk = decrypted[0].district;
            if (preselectedTaluk) {
                $('#P51_DISTRICT_NAME').val(preselectedTaluk);
            }

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

    $(document).on('change', '#P7_UPLOAD_DROPZONE_input', function () {
        console.log("Delegated file input change:", this.files);
    });
    function checkFile(selector) {
        const fileInput = $(selector);

        if (fileInput.length === 0) {
            console.error("No file input found for selector:", selector);
            return null;
        }

        const files = fileInput[0].files;
        const validTypes = ['application/pdf', 'image/jpeg'];
        const maxSize = 2 * 1024 * 1024; // 2MB
        const maxFiles = 5;

        const errorSpanId = selector.replace('#', '') + '_error_placeholder';
        const errorSpan = $('#' + errorSpanId);

        // Reset error
        errorSpan.text('');

        if (files.length === 0) {
            errorSpan.text("Please select at least one file.");
            return null;
        }

        if (files.length > maxFiles) {
            errorSpan.text(`You can upload a maximum of ${maxFiles} files.`);
            return null;
        }

        for (let file of files) {
            if (!validTypes.includes(file.type)) {
                errorSpan.text("Invalid file type. Allowed: PDF, JPG, JPEG.");
                return null;
            }

            if (file.size > maxSize) {
                errorSpan.text("Each file must be 2MB or less.");
                return null;
            }
        }

        return files;
    }

    async function processFile(selector) {
        debugger
        console.log("File input element:", $(selector));
        console.log("Selected files:", $(selector)[0]?.files);
        const files = checkFile(selector);
        if (!files) return;

        const readAsBase64 = file =>
            new Promise((resolve, reject) => {
                const reader = new FileReader();
                reader.onload = () =>
                    resolve({
                        filename: file.name,
                        fileBase64: reader.result.split(',')[1], // Remove data:*/*;base64,
                        fileType: file.type,
                        fileSize: file.size,
                    });
                reader.onerror = error => reject(error);
                reader.readAsDataURL(file);
            });

        const resultList = await Promise.all(
            Array.from(files).map(file => readAsBase64(file))
        );

        renderFileList(resultList);
        return resultList;
    }
    function renderFileList(files) {
        const preview = $('#filePreviewList');
        preview.empty();

        files.forEach(file => {
            const item = $('<div>').text(`✔️ ${file.filename} (${(file.fileSize / 1024).toFixed(1)} KB)`);
            preview.append(item);
        });
    }

    // $(document).on('click', '#submitBtn', async function (event) {
    //     event.preventDefault();
    //     debugger;

    //     const uploadedFiles = await processFile('#P7_UPLOAD_DROPZONE_input');
    //     if (!uploadedFiles || uploadedFiles.length === 0) {
    //         alert("Please upload a valid file.");
    //         return;
    //     }

    //     const uploadFile = uploadedFiles[0]; // Safe now

    //     // Get form field values
    //     const name = $('#P66_NAME').val();
    //     const district = $('#P51_DISTRICT_NAME').val();
    //     const mobile = $('#P66_MOBILE').val();

    //     const payload = {
    //         action: "function_call",
    //         function_name: "save_profile_details",
    //         params: {
    //             name: name,
    //             district: district,
    //             mobile: mobile,
    //             updated_by: userId,
    //             p_attachment: uploadFile.fileBase64,
    //             p_file_name: uploadFile.filename,
    //             p_mime_type: uploadFile.fileType,
    //             p_created_by: userId,
    //         }
    //     };

    //     console.log("Submitting profile payload:", payload);

    //     $.ajax({
    //         url: apiUrl,
    //         method: "POST",
    //         headers: {
    //             'X-APP-Key': "edm",
    //             'X-APP-Name': "edm"
    //         },
    //         data: {
    //             data: encryptData(payload)
    //         },
    //         dataType: 'json',
    //         cache: false,
    //         success: function (response) {
    //             console.log("Profile updated successfully:", response);
    //             showSuccessToast("Profile updated successfully!");

    //             // Close modal and reset
    //             $('#profile-overlay').hide();
    //             $('#P66_NAME').val('');
    //             $('#P66_DISTRICT').val('').trigger('change');
    //             $('#P66_MOBILE').val('');
    //             $('#P7_UPLOAD_DROPZONE_input').val(''); // Clear file input
    //             $('#filePreviewList').empty(); // Clear preview
    //         },
    //         error: function (xhr, status, error) {
    //             console.error("Profile update failed:", {
    //                 status: xhr.status,
    //                 statusText: xhr.statusText,
    //                 responseText: xhr.responseText,
    //                 error: error
    //             });
    //             alert("An error occurred while updating profile.");
    //         }
    //     });
    // });



    // Close button handler
    $('#closeBtn').on('click', function () {
        $('#profile-overlay').hide();
    });
});

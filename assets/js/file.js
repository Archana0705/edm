
function checkFile(selector) {
    var fileInput = $(selector).find('input[type="file"]');
    const validTypes = ['application/pdf', 'image/jpeg', 'image/jpg'];
    const maxSize = 2 * 1024 * 1024; // 2MB in bytes
    var file = fileInput[0].files[0];

    // Check if a file has been selected
    if (file) {
        // Check file type
        if (!validTypes.includes(file.type)) {
            errors = true;
            $('#' + selector.replace('#', '') + '_error_placeholder').text('Invalid file type. Supported types are .pdf, .jpg, .jpeg.').css('color', 'red');
            return;
        }

        // Check file size
        if (file.size > maxSize) {
            errors = true;
            $('#' + selector.replace('#', '') + '_error_placeholder').text("File size exceeds the 2MB limit.").css('color', 'red');
            return;
        }
    }
}
function processFile(selector) {
    return new Promise((resolve, reject) => {
        var fileInput = $(selector)[0];
        var file = fileInput.files[0];
        if (file === undefined) showErrorToast('Please upload all the required files');
        if (file) {
            const reader = new FileReader();
            const fileData = {};

            reader.onload = function (event) {
                // File processed as Base64 string
                fileData.fileBase64 = event.target.result.split(',')[1];
                fileData.mimetype = file.type;
                fileData.filename = file.name;

                resolve(fileData); // Resolve the promise with fileData
            };

            reader.onerror = function (error) {
                reject(error); // Reject the promise in case of error
            };

            reader.readAsDataURL(file); // Read the file as a data URL (Base64)
        }
    });
}

export { processFile, checkFile }
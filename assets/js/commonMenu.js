

// const menuItems = [
//     { label: "Home", file: "dashboard.html", folder: "", icon: "fa fa-tachometer", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "call-center-operator", "operator"] },
//     {
//         label: "All Requests", file: "allrequest.html", folder: "", icon: "fa fa-tasks", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "General Helpdesk Operator", "operator"],
//         subMenu: [
//             {
//                 label: "All Requests with Reassign Options",
//                 file: "request-reassign.html",
//                 folder: "",
//                 roles: ["helpdesk_operator"]
//             }
//         ]
//     },
//     { label: "New Requests", file: "new-request.html", folder: "", icon: "fa fa-plus-circle", roles: ["edistrict_manager", "helpdesk_operator", "general helpdesk operator", "operator"] },
//     { label: "In Progress Requests", file: "inprogress-request.html", folder: "", icon: "fa fa-spinner", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "operator"] },
//     { label: "Resolved Requests", file: "resolved-request.html", folder: "", icon: "fa fa-check-circle", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "operator"] },
//     { label: "Closed Requests", file: "closed-request.html", folder: "", icon: "fa fa-times-circle", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "operator"] },
//     { label: "Reopened Requests", file: "re-opened-request.html", folder: "", icon: "fa fa-refresh", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "operator"] },
//     { label: "Operator Details", file: "operator-details.html", folder: "", icon: "fa fa-user", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator"] },
//     { label: "Diary for EDM Inspection Report", file: "dairy-for-inspection.html", folder: "", icon: "fa fa-book", roles: ["helpdesk_operator"] },
//     { label: "EDM Instruction Report", file: "edm-instruction-request.html", folder: "", icon: "fa fa-file", roles: ["helpdesk_operator"] },
//     { label: "Instructions Received Report", file: "instructions-recieved-report.html", folder: "", icon: "fa fa-inbox", roles: ["edistrict_manager"] },
//     { label: "Helpdesk Tickets", file: "helpdesk-report.html", folder: "", icon: "fa fa-ticket", roles: ["edistrict_manager"] },
//     { label: "Ticket Updates", file: "allrequest.html", folder: "", icon: "fa fa-pencil", roles: ["call-center-operator"] },
//     { label: "Ticket Raise Request", file: "ticket-updates.html", folder: "", icon: "fa fa-upload", roles: ["helpdesk", "helpdesk_operator"] },
//     { label: "Helpdesk Ticket Updates", file: "helpdesk-ticket-update.html", folder: "", icon: "fa fa-refresh", roles: ["helpdesk", "helpdesk_operator"] },
//     {
//         label: "Helpdesk Tickets Reports", file: "", folder: "", icon: "fa fa-list", roles: ["helpdesk", "helpdesk_operator", "call-center-operator"],
//         subMenu: [
//             { label: "Helpdesk Instruction Open Report", file: "helpdeskopen.html", folder: "", roles: ["helpdesk_operator", "call-center-operator"] },
//             { label: "Helpdesk Instruction In Progress Report", file: "helpdesk-inprogress.html", folder: "", roles: ["helpdesk_operator", "call-center-operator"] },
//             { label: "Helpdesk Instruction Closed Report", file: "helpdesk-closed.html", folder: "", roles: ["helpdesk_operator", "call-center-operator"] }
//         ]
//     },
//     { label: "eSevai Operator Change Request Form", file: "esevai-request-form.html", folder: "", icon: "fa fa-lock", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator"] },
//     { label: "eSevai Operator Change Request Report", file: "esevai-request-report.html", folder: "", icon: "fa fa-lock", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator",] },
//     { label: "Approved / Rejected Operator Change Report", file: "approve-reject-operator-request.html", folder: "", icon: "fa fa-check", roles: ["helpdesk", "helpdesk_operator"] },
//     { label: "Public Petitions", file: "publicpetitions.html", folder: "", icon: "fa fa-envelope", roles: ["helpdesk", "helpdesk_operator"] }
// ];

// function normalizeRole(role) {
//     if (!role) return null;
//     const lower = role.toLowerCase();
//     if (lower.includes("general helpdesk operator")) return "call-center-operator";
//     if (lower.includes("helpdesk_operator")) return "helpdesk_operator";
//     if (lower.includes("edistrict manager")) return "edistrict_manager";
//     if (lower.includes("operator")) return "operator";
//     if (lower.includes("helpdesk")) return "helpdesk";
//     return lower;
// }

// function encryptData(data) {
//     const secretKey = "xmcK|fbngp@!71L$";
//     const key = CryptoJS.enc.Hex.parse(CryptoJS.SHA256(secretKey).toString());
//     const iv = CryptoJS.lib.WordArray.random(16);

//     const encrypted = CryptoJS.AES.encrypt(JSON.stringify(data), key, {
//         iv: iv,
//         mode: CryptoJS.mode.CBC,
//         padding: CryptoJS.pad.Pkcs7
//     });

//     const combined = iv.concat(encrypted.ciphertext);
//     return CryptoJS.enc.Base64.stringify(combined);
// }

// function decryptData(encryptedData) {
//     const secretKey = "xmcK|fbngp@!71L$";
//     const key = CryptoJS.enc.Hex.parse(CryptoJS.SHA256(secretKey).toString());

//     const decodedHex = CryptoJS.enc.Base64.parse(encryptedData).toString(CryptoJS.enc.Hex);
//     const iv = CryptoJS.enc.Hex.parse(decodedHex.slice(0, 32));
//     const cipher = CryptoJS.enc.Hex.parse(decodedHex.slice(32));

//     const decrypted = CryptoJS.AES.decrypt({ ciphertext: cipher }, key, {
//         iv: iv,
//         mode: CryptoJS.mode.CBC,
//         padding: CryptoJS.pad.Pkcs7
//     });

//     return JSON.parse(decrypted.toString(CryptoJS.enc.Utf8));
// }

// async function renderDynamicMenu(containerId) {
//     const ul = document.getElementById(containerId);
//     if (!ul) return;

//     const rawUserRole = localStorage.getItem("userRole");
//     const userRole = normalizeRole(rawUserRole);
//     if (!userRole) return;

//     const filteredMenu = menuItems.filter(item => item.roles.includes(userRole));
//     ul.innerHTML = "";

//     const pathParts = window.location.pathname.split('/');
//     const currentFile = pathParts.pop();
//     const currentFolder = pathParts.pop();

//     filteredMenu.forEach(item => {
//         const li = document.createElement("li");
//         li.className = "main-menu-item";
//         li.style.padding = "10px";

//         const itemHref = (item.folder === currentFolder || item.folder === "") ? item.file : `../${item.folder}/${item.file}`;
//         const a = document.createElement("a");
//         a.href = itemHref;
//         a.style.textDecoration = "none";
//         a.style.color = "#333";
//         a.innerHTML = `<span class="${item.icon}" style="margin-right:10px;"></span>${item.label}`;

//         const badge = document.createElement("span");
//         badge.className = "menu-count-badge";
//         badge.id = `badge-${item.label.replace(/\s+/g, '-')}`;
//         badge.style.cssText = "background:#e74c3c;color:#fff;border-radius:10px;padding:2px 6px;margin-left:8px;font-size:12px;display:none;";
//         badge.innerText = "0";
//         a.appendChild(badge);

//         if (item.file === currentFile) {
//             li.classList.add("active");
//             li.style.backgroundColor = "#2083b2";
//             a.style.color = "#fff";
//             a.style.fontWeight = "bold";
//         }

//         li.appendChild(a);

//         if (item.subMenu) {
//             const subItems = item.subMenu.filter(sub => sub.roles.includes(userRole));
//             if (subItems.length > 0) {
//                 const toggle = document.createElement("span");
//                 toggle.innerHTML = "&#9660;";
//                 toggle.className = "submenu-toggle";
//                 toggle.style.marginLeft = "10px";
//                 toggle.style.cursor = "pointer";
//                 li.appendChild(toggle);

//                 const subUl = document.createElement("ul");
//                 subUl.className = "submenu";
//                 subUl.style.cssText = "margin-top:10px;margin-left:20px;padding-left:10px;border-left:2px solid #ccc;display:none;";

//                 subItems.forEach(sub => {
//                     const subLi = document.createElement("li");
//                     const subA = document.createElement("a");
//                     subA.href = sub.file;
//                     subA.style.cssText = "text-decoration:none;display:flex;justify-content:space-between;margin-bottom:8px;color:#555;align-items:center;";

//                     const labelSpan = document.createElement("span");
//                     labelSpan.textContent = sub.label;

//                     const badge = document.createElement("span");
//                     badge.className = "menu-count-badge";
//                     badge.id = `badge-${sub.label.replace(/\s+/g, '-')}`;
//                     badge.style.cssText = "background:#e74c3c;color:#fff;border-radius:10px;padding:2px 6px;margin-left:8px;font-size:12px;display:none;";
//                     badge.textContent = "0";

//                     subA.appendChild(labelSpan);
//                     subA.appendChild(badge);

//                     subLi.appendChild(subA);
//                     subUl.appendChild(subLi);
//                 });


//                 toggle.onclick = (e) => {
//                     e.preventDefault();
//                     const visible = subUl.style.display === "block";
//                     subUl.style.display = visible ? "none" : "block";
//                     toggle.style.transform = visible ? "rotate(0deg)" : "rotate(180deg)";
//                 };

//                 li.appendChild(subUl);
//             }
//         }

//         ul.appendChild(li);
//     });

//     // Fetch API badge counts
//     const mobnumber = localStorage.getItem("userMob");
//     if (!mobnumber) return;

//     const payload = {
//         action: "function_call",
//         function_name: "edm_dashboard_counts_fn",
//         params: {
//             p_mobnumber: mobnumber
//         }
//     };

//     $.ajax({
//         url: "https://tngis.tnega.org/lcap_api/edm/v1/commonfunction",
//         method: "POST",
//         headers: {
//             'X-APP-Key': "edm",
//             'X-APP-Name': "edm"
//         },
//         data: {
//             data: encryptData(payload)
//         },
//         dataType: "json",
//         success: function (res) {
//             try {
//                 if (!res || !res.data) return;
//                 const result = decryptData(res.data);
//                 const counts = result[0];

//                 const labelMap = {
//                     "All Requests": counts.app_open_count,
//                     "New Requests": counts.app_new_count,
//                     "In Progress Requests": counts.app_inprogress_count,
//                     "Resolved Requests": counts.app_resolved_count,
//                     "Closed Requests": counts.app_closed_count,
//                     "Reopened Requests": counts.app_reopen_count,
//                     "Public Petitions": counts.petition_count,
//                     "Helpdesk Tickets": counts.helpdesk_count,
//                     "Helpdesk Tickets Reports": counts.ticket_updates_count,
//                     "Helpdesk Instruction Open Report": counts.app_open_count,
//                     "Helpdesk Instruction In-Progress Report": counts.app_progress_count,
//                     "Helpdesk Instruction Closed Report": counts.app_close_count,
//                     "Instruction received Report": counts.app_edm_service_assaign_count,
//                     "Approved/Rejected Operator change report": counts.closed_req_count
//                 };

//                 for (const [label, count] of Object.entries(labelMap)) {
//                     const badge = document.getElementById(`badge-${label.replace(/\s+/g, '-')}`);
//                     if (badge) {
//                         badge.textContent = count;
//                         badge.style.display = count > 0 ? "inline-block" : "none";
//                     }
//                 }
//             } catch (e) {
//                 console.error("Decryption failed", e);
//             }
//         },
//         error: function (xhr, status, error) {
//             console.error("Count fetch failed", xhr.responseText);
//         }
//     });
// }

// renderDynamicMenu("commonMenuContainer");

const menuItems = [
    { label: "Home", file: "dashboard.html", folder: "", icon: "fa fa-tachometer", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "call-center-operator", "operator"] },
    {
        label: "All Requests", file: "allrequest.html", folder: "", icon: "fa fa-tasks", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "General Helpdesk Operator", "operator"],
        subMenu: [
            {
                label: "All Requests with Reassign Options",
                file: "request-reassign.html",
                folder: "",
                roles: ["helpdesk_operator"]
            }
        ]
    },
    { label: "New Requests", file: "new-request.html", folder: "", icon: "fa fa-plus-circle", roles: ["edistrict_manager", "helpdesk_operator", "general helpdesk operator", "operator"] },
    { label: "In Progress Requests", file: "inprogress-request.html", folder: "", icon: "fa fa-spinner", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "operator"] },
    { label: "Resolved Requests", file: "resolved-request.html", folder: "", icon: "fa fa-check-circle", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "operator"] },
    { label: "Closed Requests", file: "closed-request.html", folder: "", icon: "fa fa-times-circle", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "operator"] },
    { label: "Reopened Requests", file: "re-opened-request.html", folder: "", icon: "fa fa-refresh", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator", "operator"] },
    { label: "Operator Details", file: "operator-details.html", folder: "", icon: "fa fa-user", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator"] },
    { label: "Diary for EDM Inspection Report", file: "dairy-for-inspection.html", folder: "", icon: "fa fa-book", roles: ["helpdesk_operator"] },
    { label: "EDM Instruction Report", file: "edm-instruction-request.html", folder: "", icon: "fa fa-file", roles: ["helpdesk_operator"] },
    { label: "Instructions Received Report", file: "instructions-recieved-report.html", folder: "", icon: "fa fa-inbox", roles: ["edistrict_manager"] },
    { label: "Helpdesk Tickets", file: "helpdesk-report.html", folder: "", icon: "fa fa-ticket", roles: ["edistrict_manager"] },
    { label: "Ticket Updates", file: "allrequest.html", folder: "", icon: "fa fa-pencil", roles: ["call-center-operator"] },
    { label: "Ticket Raise Request", file: "ticket-updates.html", folder: "", icon: "fa fa-upload", roles: ["helpdesk", "helpdesk_operator"] },
    { label: "Helpdesk Ticket Updates", file: "helpdesk-ticket-update.html", folder: "", icon: "fa fa-refresh", roles: ["helpdesk", "helpdesk_operator"] },
    {
        label: "Helpdesk Tickets Reports", file: "", folder: "", icon: "fa fa-list", roles: ["helpdesk", "helpdesk_operator", "call-center-operator"],
        subMenu: [
            { label: "Helpdesk Instruction Open Report", file: "helpdeskopen.html", folder: "", roles: ["helpdesk_operator", "call-center-operator"] },
            { label: "Helpdesk Instruction In Progress Report", file: "helpdesk-inprogress.html", folder: "", roles: ["helpdesk_operator", "call-center-operator"] },
            { label: "Helpdesk Instruction Closed Report", file: "helpdesk-closed.html", folder: "", roles: ["helpdesk_operator", "call-center-operator"] }
        ]
    },
    { label: "eSevai Operator Change Request Form", file: "esevai-request-form.html", folder: "", icon: "fa fa-lock", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator"] },
    { label: "eSevai Operator Change Request Report", file: "esevai-request-report.html", folder: "", icon: "fa fa-lock", roles: ["edistrict_manager", "helpdesk", "helpdesk_operator",] },
    { label: "Approved / Rejected Operator Change Report", file: "approve-reject-operator-request.html", folder: "", icon: "fa fa-check", roles: ["helpdesk", "helpdesk_operator"] },
    { label: "Public Petitions", file: "publicpetitions.html", folder: "", icon: "fa fa-envelope", roles: ["helpdesk", "helpdesk_operator"] }
];

function normalizeRole(role) {
    if (!role) return null;
    const lower = role.toLowerCase();
    if (lower.includes("general helpdesk operator")) return "call-center-operator";
    if (lower.includes("helpdesk_operator")) return "helpdesk_operator";
    if (lower.includes("edistrict manager")) return "edistrict_manager";
    if (lower.includes("operator")) return "operator";
    if (lower.includes("helpdesk")) return "helpdesk";
    return lower;
}

function encryptData(data) {
    const secretKey = "xmcK|fbngp@!71L$";
    const key = CryptoJS.enc.Hex.parse(CryptoJS.SHA256(secretKey).toString());
    const iv = CryptoJS.lib.WordArray.random(16);

    const encrypted = CryptoJS.AES.encrypt(JSON.stringify(data), key, {
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    });

    const combined = iv.concat(encrypted.ciphertext);
    return CryptoJS.enc.Base64.stringify(combined);
}

function decryptData(encryptedData) {
    const secretKey = "xmcK|fbngp@!71L$";
    const key = CryptoJS.enc.Hex.parse(CryptoJS.SHA256(secretKey).toString());

    const decodedHex = CryptoJS.enc.Base64.parse(encryptedData).toString(CryptoJS.enc.Hex);
    const iv = CryptoJS.enc.Hex.parse(decodedHex.slice(0, 32));
    const cipher = CryptoJS.enc.Hex.parse(decodedHex.slice(32));

    const decrypted = CryptoJS.AES.decrypt({ ciphertext: cipher }, key, {
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    });

    return JSON.parse(decrypted.toString(CryptoJS.enc.Utf8));
}

async function renderDynamicMenu(containerId) {
    const ul = document.getElementById(containerId);
    if (!ul) return;

    const rawUserRole = localStorage.getItem("userRole");
    const userRole = normalizeRole(rawUserRole);
    if (!userRole) return;

    const filteredMenu = menuItems.filter(item => item.roles.includes(userRole));
    ul.innerHTML = "";

    const pathParts = window.location.pathname.split('/');
    let currentFile = pathParts.pop();
    const currentFolder = pathParts.pop();

    const aliasMap = {
        "allrequest-info.html": "allrequest.html",
        "inprogress-request-info.html": "inprogress-request.html",
        "resolved-info.html": "resolved-request.html",
        "closed-info.html": "closed-request.html",
        "re-opened-request-info.html": "re-opened-request.html"
    };
    if (aliasMap[currentFile]) {
        currentFile = aliasMap[currentFile];
    }

    filteredMenu.forEach(item => {
        const li = document.createElement("li");
        li.className = "main-menu-item";
        li.style.padding = "10px";

        const itemHref = (item.folder === currentFolder || item.folder === "") ? item.file : `../${item.folder}/${item.file}`;
        const a = document.createElement("a");
        a.href = itemHref;
        a.style.textDecoration = "none";
        a.style.color = "#333";
        a.innerHTML = `<span class="${item.icon}" style="margin-right:10px;"></span>${item.label}`;

        const badge = document.createElement("span");
        badge.className = "menu-count-badge";
        badge.id = `badge-${item.label.replace(/\s+/g, '-')}`;
        badge.style.cssText = "background:#e74c3c;color:#fff;border-radius:10px;padding:2px 6px;margin-left:8px;font-size:12px;display:none;";
        badge.innerText = "0";
        a.appendChild(badge);

        // ✅ Active menu highlight
        if (item.file === currentFile) {
            li.classList.add("active");
            li.style.backgroundColor = "#2083b2";
            a.style.color = "#fff";
            a.style.fontWeight = "bold";
        }

        li.appendChild(a);

        if (item.subMenu) {
            const subItems = item.subMenu.filter(sub => sub.roles.includes(userRole));
            if (subItems.length > 0) {
                const toggle = document.createElement("span");
                toggle.innerHTML = "&#9660;";
                toggle.className = "submenu-toggle";
                toggle.style.marginLeft = "10px";
                toggle.style.cursor = "pointer";
                li.appendChild(toggle);

                const subUl = document.createElement("ul");
                subUl.className = "submenu";
                subUl.style.cssText = "margin-top:10px;margin-left:20px;padding-left:10px;border-left:2px solid #ccc;display:none;";

                subItems.forEach(sub => {
                    const subLi = document.createElement("li");
                    const subA = document.createElement("a");
                    subA.href = sub.file;
                    subA.style.cssText = "text-decoration:none;display:flex;justify-content:space-between;margin-bottom:8px;color:#555;align-items:center;";

                    const labelSpan = document.createElement("span");
                    labelSpan.textContent = sub.label;

                    const badge = document.createElement("span");
                    badge.className = "menu-count-badge";
                    badge.id = `badge-${sub.label.replace(/\s+/g, '-')}`;
                    badge.style.cssText = "background:#e74c3c;color:#fff;border-radius:10px;padding:2px 6px;margin-left:8px;font-size:12px;display:none;";
                    badge.textContent = "0";

                    subA.appendChild(labelSpan);
                    subA.appendChild(badge);

                    subLi.appendChild(subA);
                    subUl.appendChild(subLi);
                });

                toggle.onclick = (e) => {
                    e.preventDefault();
                    const visible = subUl.style.display === "block";
                    subUl.style.display = visible ? "none" : "block";
                    toggle.style.transform = visible ? "rotate(0deg)" : "rotate(180deg)";
                };

                li.appendChild(subUl);
            }
        }

        ul.appendChild(li);
    });

    // 🔄 Fetch API badge counts
    const mobnumber = localStorage.getItem("userMob");
    if (!mobnumber) return;

    const payload = {
        action: "function_call",
        function_name: "edm_dashboard_counts_fn",
        params: {
            p_mobnumber: mobnumber
        }
    };

    $.ajax({
        url: "https://tngis.tnega.org/lcap_api/edm/v1/commonfunction",
        method: "POST",
        headers: {
            'X-APP-Key': "edm",
            'X-APP-Name': "edm"
        },
        data: {
            data: encryptData(payload)
        },
        dataType: "json",
        success: function (res) {
            try {
                if (!res || !res.data) return;
                const result = decryptData(res.data);
                const counts = result[0];

                const labelMap = {
                    "All Requests": counts.app_open_count,
                    "New Requests": counts.app_new_count,
                    "In Progress Requests": counts.app_inprogress_count,
                    "Resolved Requests": counts.app_resolved_count,
                    "Closed Requests": counts.app_closed_count,
                    "Reopened Requests": counts.app_reopen_count,
                    "Public Petitions": counts.petition_count,
                    "Helpdesk Tickets": counts.helpdesk_count,
                    "Helpdesk Tickets Reports": counts.ticket_updates_count,
                    "Helpdesk Instruction Open Report": counts.app_open_count,
                    "Helpdesk Instruction In-Progress Report": counts.app_progress_count,
                    "Helpdesk Instruction Closed Report": counts.app_close_count,
                    "Instruction received Report": counts.app_edm_service_assaign_count,
                    "Approved/Rejected Operator change report": counts.closed_req_count
                };

                for (const [label, count] of Object.entries(labelMap)) {
                    const badge = document.getElementById(`badge-${label.replace(/\s+/g, '-')}`);
                    if (badge) {
                        badge.textContent = count;
                        badge.style.display = count > 0 ? "inline-block" : "none";
                    }
                }
            } catch (e) {
                console.error("Decryption failed", e);
            }
        },
        error: function (xhr, status, error) {
            console.error("Count fetch failed", xhr.responseText);
        }
    });
}

renderDynamicMenu("commonMenuContainer");

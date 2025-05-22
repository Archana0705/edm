// assets/js/commonMenu.js
import { initializeUserSession } from "./auth.js";
const userRole = initializeUserSession() || "helpdesk";

const menuItems = [
    { label: "Home", file: "dashboard.html", folder: "", icon: "fa fa-tachometer", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "All Requests", file: "allrequest.html", folder: "", icon: "fa fa-tasks", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "New Requests", file: "new-request.html", folder: "", icon: "fa fa-plus-circle", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "In Progress Requests", file: "inprogress-request.html", folder: "", icon: "fa fa-spinner", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "On-Hold Requests", file: "onhold-request.html", folder: "", icon: "fa fa-pause-circle", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "Resolved Requests", file: "resolved-request.html", folder: "", icon: "fa fa-check-circle", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "Closed Requests", file: "closed-request.html", folder: "", icon: "fa fa-times-circle", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "Reopened Requests", file: "re-opened-request.html", folder: "", icon: "fa fa-refresh", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "Operator Details", file: "operator-details.html", folder: "", icon: "fa fa-refresh", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "Overall EDM Report", file: "re-opened-request.html", folder: "", icon: "fa fa-refresh", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "Instructions Received Report", file: "instructions-recieved-report.html", folder: "", icon: "fa fa-refresh", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "Helpdesk Tickets", file: "helpdesk-report.html", folder: "", icon: "fa fa-list", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "eSevai Operator Change Request Form", file: "esevai-request-form.html", folder: "", icon: "fa fa-lock", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },
    { label: "eSevai Operator Change Request Report", file: "esevai-request-report.html", folder: "", icon: "fa fa-lock", roles: ["edistrict_mananger", "helpdesk", "helpdesk_operator"] },

];

// function renderDynamicMenu(containerId) {
//     debugger
//     const ul = document.getElementById(containerId);
//     if (!ul) return;
//     const userRole = sessionStorage.getItem("userRole") || "operator";
//     const pathParts = window.location.pathname.split('/');
//     const currentFile = pathParts.pop();
//     const currentFolder = pathParts.pop();
//     const filteredMenu = menuItems.filter(item => item.roles.includes(userRole));
//     // menuItems.forEach(item => {
//     //     const isInSameFolder = (item.folder === "" && !["helpdesk"].includes(currentFolder)) || (item.folder === currentFolder);
//     //     const href = isInSameFolder
//     //         ? item.file
//     //         : item.folder === "" ? `../${item.file}` : `${item.folder}/${item.file}`;

//     //     const isCurrent = item.file === currentFile && (item.folder === currentFolder || (item.folder === "" && !["helpdesk"].includes(currentFolder)));

//     //     const li = document.createElement('li');
//     //     li.setAttribute('data-id', '');
//     //     li.setAttribute('data-disabled', '');
//     //     li.setAttribute('data-icon', '');
//     //     li.setAttribute('data-shortcut', '');
//     //     li.setAttribute('data-current', isCurrent ? 'true' : 'false');

//     //     //     li.innerHTML = `
//     //     //   <a href="${href}" style="display: none;" target="">${item.label}</a>
//     //     //   <div class="a-TreeView-node a-TreeView-node--topLevel" aria-hidden="true">
//     //     //     <div role="none" class="a-TreeView-row"></div>
//     //     //     <div role="none" class="a-TreeView-content">
//     //     //         <span class="${item.icon}" style="margin-right: 8px;"></span>
//     //     //       <span class="a-TreeView-label">${item.label}</span>
//     //     //     </div>
//     //     //   </div>
//     //     // `;

//     //     const aTag = document.createElement('a');
//     //     aTag.href = href;
//     //     aTag.style.display = 'none';
//     //     aTag.target = '';
//     //     aTag.textContent = item.label;

//     //     // TreeView content
//     //     const iconSpan = document.createElement('span');
//     //     iconSpan.className = item.icon || 'fa fa-file'; // fallback if missing
//     //     iconSpan.style.marginRight = '8px';

//     //     const labelSpan = document.createElement('span');
//     //     labelSpan.className = 'a-TreeView-label';
//     //     labelSpan.textContent = item.label;

//     //     const contentDiv = document.createElement('div');
//     //     contentDiv.setAttribute('role', 'none');
//     //     contentDiv.className = 'a-TreeView-content';
//     //     contentDiv.appendChild(iconSpan);
//     //     contentDiv.appendChild(labelSpan);

//     //     const rowDiv = document.createElement('div');
//     //     rowDiv.setAttribute('role', 'none');
//     //     rowDiv.className = 'a-TreeView-row';

//     //     const nodeDiv = document.createElement('div');
//     //     nodeDiv.className = 'a-TreeView-node a-TreeView-node--topLevel';
//     //     nodeDiv.setAttribute('aria-hidden', 'true');
//     //     nodeDiv.appendChild(rowDiv);
//     //     nodeDiv.appendChild(contentDiv);

//     //     // Final LI
//     //     li.appendChild(aTag);
//     //     li.appendChild(nodeDiv);


//     //     ul.appendChild(li);
//     //     console.log("Rendering menu item:", item.label, "| Icon:", item.icon);
//     filteredMenu.forEach(item => {
//         const li = document.createElement("li");

//         let href = "";

//         if (item.folder === currentFolder || item.folder === "") {
//             href = item.file;
//         } else {
//             href = `../${item.folder}/${item.file}`;
//         }

//         const a = document.createElement("a");
//         a.href = href;
//         a.innerHTML = `<span class="${item.icon}" style="margin-right: 8px;"></span>${item.label}`;

//         li.appendChild(a);
//         ul.appendChild(li);
//     });
// }
function renderDynamicMenu(containerId) {
    debugger
    const ul = document.getElementById(containerId);
    if (!ul) return;

    const currentPath = window.location.pathname;
    const currentFolder = currentPath.split("/").slice(-2, -1)[0];

    const filteredMenu = menuItems.filter(item => item.roles.includes(userRole));

    filteredMenu.forEach(item => {
        const li = document.createElement("li");

        let href = "";
        if (item.folder === currentFolder || item.folder === "") {
            href = item.file;
        } else {
            href = `../${item.folder}/${item.file}`;
        }

        const a = document.createElement("a");
        a.href = href;
        a.innerHTML = `<span class="${item.icon}" style="margin-right: 8px;"></span>${item.label}`;

        li.appendChild(a);
        ul.appendChild(li);
    });
}

renderDynamicMenu("commonMenuContainer");
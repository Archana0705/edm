document.addEventListener('DOMContentLoaded', function () {
    fetch('../assets/partials/globalHeader.html')
        .then(response => {
            if (!response.ok) {
                throw new Error('Header file not found: ' + response.status);
            }
            return response.text();
        })
        .then(html => {
            const container = document.getElementById('globalHeader');
            if (container) {
                container.innerHTML = html;

                // Set dynamic username
                const username = localStorage.getItem('userName') || 'User';
                const usernameElement = document.getElementById('dynamicUsername');
                if (usernameElement) {
                    usernameElement.textContent = username;
                }

                const lastLogin = localStorage.getItem('lastLogin');
                const lastLoginElement = document.getElementById('lastLoggedIn');
                if (lastLogin && lastLoginElement) {
                    lastLoginElement.textContent = lastLogin;
                }
            }
            const signOutBtn = document.getElementById('signOutBtn');
            if (signOutBtn) {
                signOutBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    localStorage.clear();
                    window.location.href = '/index.html';
                });
            }
        })
        .catch(error => {
            console.error('Error loading global header:', error);
        });
});

document.addEventListener('click', function (event) {
    const toggleBtn = document.querySelector('[data-menu="menu_L8804321173964414"]');
    const menu = document.getElementById('menu_L8804321173964414');

    if (!toggleBtn || !menu) return;

    // If the click was on the toggle button
    if (toggleBtn.contains(event.target)) {
        const isVisible = menu.style.display === 'block';
        menu.style.display = isVisible ? 'none' : 'block';
    } else {
        // If clicked outside, hide the menu
        if (!menu.contains(event.target)) {
            menu.style.display = 'none';
        }
    }
});


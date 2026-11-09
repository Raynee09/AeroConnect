/**
 * AeroConnect — Main JavaScript
 * Minimal, vanilla JS utilities shared across the application.
 */

document.addEventListener('DOMContentLoaded', function () {

    // Auto-dismiss alerts after 5 seconds
    document.querySelectorAll('.alert[data-auto-dismiss]').forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.4s ease';
            alert.style.opacity = '0';
            setTimeout(function () { alert.remove(); }, 400);
        }, 5000);
    });

    // Mobile nav toggle
    const navToggle = document.getElementById('nav-toggle');
    const navMenu   = document.getElementById('nav-menu');
    if (navToggle && navMenu) {
        navToggle.addEventListener('click', function () {
            navMenu.classList.toggle('nav-open');
            navToggle.setAttribute('aria-expanded',
                navMenu.classList.contains('nav-open'));
        });
    }

    // Set today's date as the minimum for date pickers
    document.querySelectorAll('input[type="date"][data-min-today]').forEach(function (input) {
        var today = new Date().toISOString().split('T')[0];
        input.setAttribute('min', today);
    });

    // Confirm-before-submit for destructive actions
    document.querySelectorAll('[data-confirm]').forEach(function (el) {
        el.addEventListener('click', function (e) {
            var message = el.getAttribute('data-confirm') || 'Are you sure?';
            if (!window.confirm(message)) {
                e.preventDefault();
            }
        });
    });

    // Highlight the active navigation link
    var currentPath = window.location.pathname;
    document.querySelectorAll('.navbar-nav a, .sidebar-nav a').forEach(function (link) {
        if (link.getAttribute('href') && currentPath.startsWith(link.getAttribute('href'))) {
            link.classList.add('active');
        }
    });
});

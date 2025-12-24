(function () {
  function resetWebflowNav() {
    try {
      var overlays = document.querySelectorAll('.w-nav-overlay');
      for (var i = 0; i < overlays.length; i++) {
        overlays[i].style.display = 'none';
        overlays[i].style.height = '0px';
      }

      var openMenus = document.querySelectorAll('[data-nav-menu-open]');
      for (var j = 0; j < openMenus.length; j++) {
        openMenus[j].removeAttribute('data-nav-menu-open');
        openMenus[j].style.display = '';
        openMenus[j].style.height = '';
      }

      var openButtons = document.querySelectorAll('.w-nav-button.w--open');
      for (var k = 0; k < openButtons.length; k++) {
        openButtons[k].classList.remove('w--open');
        openButtons[k].setAttribute('aria-expanded', 'false');
      }

      var navs = document.querySelectorAll('.w-nav');
      for (var n = 0; n < navs.length; n++) {
        navs[n].classList.remove('w--open');
      }

      var openDropdowns = document.querySelectorAll('.w-dropdown-list.w--open');
      for (var d = 0; d < openDropdowns.length; d++) {
        openDropdowns[d].classList.remove('w--open');
        openDropdowns[d].style.display = '';
      }

      document.documentElement.style.overflow = '';
      document.body.style.overflow = '';
      document.body.style.position = '';
      document.body.style.width = '';
    } catch (e) {
      // no-op
    }
  }

  function bindNavLinkClose() {
    try {
      var navLinks = document.querySelectorAll('.w-nav a');
      for (var i = 0; i < navLinks.length; i++) {
        navLinks[i].addEventListener(
          'click',
          function () {
            setTimeout(resetWebflowNav, 0);
          },
          { passive: true }
        );
      }
    } catch (e) {
      // no-op
    }
  }

  window.addEventListener('DOMContentLoaded', function () {
    resetWebflowNav();
    bindNavLinkClose();
  });

  window.addEventListener('pageshow', function () {
    resetWebflowNav();
  });
})();

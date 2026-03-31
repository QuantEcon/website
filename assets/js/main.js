(function() {
  "use strict";

  /**
   * Sponsor announcement bar — show unless previously dismissed
   */
  const sponsorBar = document.getElementById('sponsor-bar');
  if (sponsorBar && !sessionStorage.getItem('sponsor-bar-dismissed')) {
    sponsorBar.style.display = '';
    document.body.classList.add('sponsor-bar-visible');
    // Set CSS variable for actual bar height
    const barHeight = sponsorBar.offsetHeight;
    document.documentElement.style.setProperty('--sponsor-bar-height', barHeight + 'px');

    const closeBtn = sponsorBar.querySelector('.sponsor-bar-close');
    if (closeBtn) {
      closeBtn.addEventListener('click', function() {
        sponsorBar.style.display = 'none';
        document.body.classList.remove('sponsor-bar-visible');
        document.documentElement.style.removeProperty('--sponsor-bar-height');
        sessionStorage.setItem('sponsor-bar-dismissed', '1');
      });
    }
  }

  const select = (el, all = false) => {
    el = el.trim()
    if (all) {
      return [...document.querySelectorAll(el)]
    } else {
      return document.querySelector(el)
    }
  }

  /**
   * Toggle .header-scrolled class to #header when page is scrolled
   */
  let selectHeader = select('#header')
  if (selectHeader) {
    const headerScrolled = () => {
      if (window.scrollY > 100) {
        selectHeader.classList.add('header-scrolled')
      } else {
        selectHeader.classList.remove('header-scrolled')
      }
    }
    window.addEventListener('load', headerScrolled)
    document.addEventListener('scroll', headerScrolled)
  }

  /**
   * Back to top button
   */
  let backtotop = select('.back-to-top')
  if (backtotop) {
    const toggleBacktotop = () => {
      if (window.scrollY > 100) {
        backtotop.classList.add('active')
      } else {
        backtotop.classList.remove('active')
      }
    }
    window.addEventListener('load', toggleBacktotop)
    document.addEventListener('scroll', toggleBacktotop)
  }

  /**
   * Mobile nav toggle
   */
  const navToggle = select('.mobile-nav-toggle')
  if (navToggle) {
    navToggle.addEventListener('click', function(e) {
      select('#navbar').classList.toggle('navbar-mobile')
      this.classList.toggle('bi-list')
      this.classList.toggle('bi-x')
    })
  }

  /**
   * Mobile nav dropdowns activate
   */
  select('.navbar .dropdown > .dropdown-toggle', true).forEach(el => {
    el.addEventListener('click', function(e) {
      if (select('#navbar').classList.contains('navbar-mobile')) {
        e.preventDefault()
        this.nextElementSibling.classList.toggle('dropdown-active')
      }
    })
  })

  /**
   * Smooth scroll for anchor links
   */
  select('a[href^="#"]', true).forEach(el => {
    el.addEventListener('click', function(e) {
      if (!this.hash || this.hash === '#') return
      const target = select(this.hash)
      if (target) {
        e.preventDefault()
        let header = select('#header')
        let offset = header ? header.offsetHeight : 0
        window.scrollTo({
          top: target.offsetTop - offset,
          behavior: 'smooth'
        })
      }
    })
  })

})()

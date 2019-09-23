// Mobile navigation menu toggle
var navbarToggle = document.getElementsByClassName('navbar-toggle')[0];
var siteNav = document.getElementsByClassName('site-nav')[0];

navbarToggle.addEventListener('click', function(){
  if (this.classList.contains('collapsed')) {
     siteNav.style.display = 'block';
     navbarToggle.classList.remove('collapsed');
  } else {
     siteNav.style.display = 'none';
     navbarToggle.classList.add('collapsed');
  }
}, false);

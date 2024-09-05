// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


document.addEventListener('DOMContentLoaded', function () {
    document.body.classList.add('fade-in');
  
    setTimeout(function () {
      document.body.classList.add('fade-in-active');
    },200);
  
    const links = document.querySelectorAll('a[href]');
    let isTransitioning = false;
  
    links.forEach(link => {
      link.addEventListener('click', function (e) {
        if (isTransitioning) return;
        isTransitioning = true;
  
        e.preventDefault();
        const href = this.href;
  
        document.body.classList.add('fade-out');
  
        setTimeout(function () {
          window.location.href = href;
        }, 50);
      });
    });
  });
  
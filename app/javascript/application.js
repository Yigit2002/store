// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

document.addEventListener('turbolinks:load', function() {
  // Butonlara click olayı ekle
  var decreaseButtons = document.querySelectorAll('.quantity-selector .decrease');
  var increaseButtons = document.querySelectorAll('.quantity-selector .increase');
  
  decreaseButtons.forEach(function(button) {
    button.addEventListener('click', function() {
      var input = this.nextElementSibling;
      var value = parseInt(input.value, 10);
      if (value > 1) {
        input.value = value - 1;
      }
    });
  });
  
  increaseButtons.forEach(function(button) {
    button.addEventListener('click', function() {
      var input = this.previousElementSibling;
      var value = parseInt(input.value, 10);
      var max = parseInt(input.getAttribute('max') || 99, 10);
      if (value < max) {
        input.value = value + 1;
      }
    });
  });
});
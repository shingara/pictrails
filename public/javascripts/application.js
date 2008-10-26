// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function load_click() {
  if ($('random_front_picture') != null) {
    Event.observe('random_front_picture', 'click', function(e) {
      e.stop()
      to = $('random_front_picture').href 
      new Ajax.Request(to)
    })
  }
}

Event.observe(window, 'load', function() {
    load_click()
})

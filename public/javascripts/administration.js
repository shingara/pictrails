// Javascript use by Pictrails administration

Event.observe(window, 'load', function() {
    if ($$('a#copy_picture')) {
      Event.observe('copy_picture', 'click', function(e) {
        Event.stop(e)
        new Ajax.Request($$('a#copy_picture'), {asynchronous:true, evalScripts:true}); 
      })
    }
})

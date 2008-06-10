function refresh_import(){
  new Ajax.Request('/admin/galleries/follow_import')
}

Event.observe(window, 'load', function() {
    refresh_import()
})

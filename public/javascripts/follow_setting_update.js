function refresh_setting_update(){
  new Ajax.Request('/admin/settings/follow_setting_update')
}

Event.observe(window, 'load', function() {
    refresh_setting_update()
})

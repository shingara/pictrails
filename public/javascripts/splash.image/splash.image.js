// +------------------------------------------------------------------------+
// | Affichage des image en plein écran
// +------------------------------------------------------------------------+
// | Javascript
// |
// | @author		 		Xuan Nguyen <xuxu.fr@gmail.com>
// | @version 				1.91
// | Last update			2007/11/02
// |
// | Licensed under the Creative Commons Attribution 3 License - http://creativecommons.org/licenses/by-sa/3.0/
// +------------------------------------------------------------------------+

//Valeur de rel pour signifier que ce lien va être soumis au splash
var rel_value = 'splash';
//Distance en pixel entre le haut de l'image et le top.
var margin_top = 40;
//Distance en pixel entre la droite de l'image et le right si l'image dépasse du body initial.
var margin_right = 40;
//Distance en pixel entre le bas de l'image et le bottom si l'image dépasse du body initial.
var margin_bottom = 40;
//Distance en pixel entre la gauche de l'image et le right si l'image dépasse du body initial.
var margin_left = 40;
// Tableau comprenant les groupes d'images
var splash_groups = new Array();
// Tableau comprenant les liens splashed
var splash_as = new Array();
// Tableau comprenant les ids des liens
var splash_ids = new Array();
// Tableau comprenant les titles des liens
var splash_titles = new Array();
//Variable contenant le timeout
var slide_timeout;
//Variable contenant le timeout de la disparition de la notification de play/pause
var slide_timeout_notification;
//Durée timeout pour le slide
var slide_timeout_value = 4000;
//Groupe courant
var current_group;
//Position actuelle de l'image dans le groupe
var current_position;
//Flag is true si slide
var is_sliding = false;
//Flag is true si splash prend la place de lightbox
var lightbox_replace = true;
//Flag is true si background à la place de la couleur du fond
var set_bg = false;
//z-index minimum des éléments
var z_index_mini = 100000;
//Objets à cacher
var objects_2_hide = new Array();
//Activer l'autostart
var splash_auto_start = false;
//Indice de l'image de départ
var splash_auto_start_rank = 0;
//Groupe de l'image de départ
var splash_auto_start_group = 'splash';


// -----------------------------------------------------------------------------------
//  Affiche l'image concernée en plein écran
function splash_image(a) {
	//On cache les éléments embed et object
    hide_and_show('hidden');
    //On récupère l'indice
	obj_body = document.getElementsByTagName('body').item(0);
	//Ini la variable current_group le groupe de cette image si celle ci est groupée
	rel_attr = new String(a.getAttribute('rel'));
	val = rel_attr.replace(rel_value+'|', '');
	splash_id = (a.getAttribute('class')) ? new String(a.getAttribute('class').match(new RegExp(/splash[0-9]+$/))) : '';
	if (val != rel_value && splash_groups[val].length > 0) {
		current_group = val;
		current_position = in_array(splash_groups[val], splash_id);
	}
	else {
		current_group = current_position = '';
	}
	if (!document.getElementById('splash_screen')) {
		//Création du fond
		obj_splash_screen = document.createElement('a');
		obj_splash_screen.setAttribute('id', 'splash_screen');
		obj_splash_screen.setAttribute('title', 'Close the splash');
       	obj_splash_screen.style.zIndex = z_index_mini;
		array_page_size = getPageSize();
		obj_splash_screen.style.width = '100%';
		obj_splash_screen.style.height = array_page_size[1]+'px';
		obj_splash_screen.onclick = function() { splash_bye(); return false; }
		if (set_bg) { obj_splash_screen.setAttribute('class', 'bg'); }
		obj_body.appendChild(obj_splash_screen);
       	obj_splash_screen.style.zIndex = z_index_mini;

		//Création du container image et du loading
		obj_content = document.createElement('div');
		obj_content.setAttribute('id', 'image_content');
		obj_content.style.width = '200px';
		obj_content.style.height = '200px';
		obj_content.className = 'ajax-loading';
		obj_body.appendChild(obj_content);
       	obj_content.style.zIndex = z_index_mini+1;

		//Positionnement
		array_page_scroll = getPageScroll();
		array_page_size = getPageSize();
		obj_content.style.top = array_page_scroll[1]+margin_top+'px';
		obj_content.style.left = array_page_size[0]/2-(parseInt(obj_content.style.width)/2)+'px';
	}
	else {
		obj_splash_screen = document.getElementById('splash_screen');
		obj_content = document.getElementById('image_content');
		obj_content.removeChild(document.getElementById('splash_img'));
		obj_content.className = 'ajax-loading';
	}

	//Supprime le title_content
	if (document.getElementById('title_content')) {
		obj_title = document.getElementById('title_content');
		//Supprime la navigation si elle existe
		if (document.getElementById('splash_previous')) {
			obj_title.removeChild(document.getElementById('splash_previous'));
			obj_title.removeChild(document.getElementById('splash_next'));
			if (document.getElementById('splash_notification')) { obj_content.removeChild(document.getElementById('splash_notification')); }
			what = (is_sliding) ? 'splash_pause' : 'splash_play';
			obj_title.removeChild(document.getElementById(what));
		}
		obj_content.removeChild(obj_title);
	}

	//Charge l'image
	ini_image(a);
}

// -----------------------------------------------------------------------------------
//  Charge l'image
function ini_image(a) {
	//Objet image pour récupérer la taille de l'image
	img = new Image();
	img.src = a.href;

	//Si l'image n'est pas encore chargée
	if (!img.complete) {
		img.onload = function() {
			image_display(a);
		}
	}
	//Si l'image a déjà été chargée une fois
	else {
		image_display(a);
	}
}

// -----------------------------------------------------------------------------------
// Affiche l'image
function image_display(a) {
	obj_body = document.getElementsByTagName('body').item(0);
	obj_content = document.getElementById('image_content');
	obj_splash_screen = document.getElementById('splash_screen');

	//Création image
	obj_image = document.createElement('img');
	obj_image.setAttribute('id', 'splash_img');
	obj_image.onclick = function() { splash_bye(); return false; }
	obj_content.appendChild(obj_image);
    obj_image.style.zIndex = z_index_mini+2;

	//Resize du container de l'image
	obj_content.style.width = img.width+'px';
	obj_content.style.height = img.height+'px';

	//Replacement du container de l'image
	array_page_scroll = getPageScroll();
	array_page_size = getPageSize();
	obj_content.style.top = array_page_scroll[1]+margin_top+'px';
	obj_content.style.left = array_page_size[0]/2-(parseInt(img.width)/2)+'px';

	//On affiche l'image
	obj_content = document.getElementById('image_content');
	obj_content.className = '';
	obj_image.setAttribute('src', a.href);
	obj_image.style.display = 'block';

	//Création container title
	obj_close = document.createElement('a');
	obj_close.setAttribute('id', 'splash_close');
	obj_close.onclick = function() { splash_bye(); return false; }
	obj_content.appendChild(obj_close);
    obj_close.style.zIndex = z_index_mini+3;

	//Création container title
	obj_title = document.createElement('div');
	obj_title.setAttribute('id', 'title_content');
	obj_content.appendChild(obj_title);
    obj_title.style.zIndex = z_index_mini+4;

	//Libellé position
	str_position = (current_group != '') ? 'Image '+(current_position+1)+' sur '+splash_groups[current_group].length+' :' : '';
	obj_text = document.createTextNode(str_position);
	obj_title.appendChild(obj_text);

	//Description
	obj_description = document.createElement('div');
	obj_description.setAttribute('id', 'splash_description');
	obj_title.appendChild(obj_description);
    obj_description.style.zIndex = z_index_mini+5;
	splash_id = (a.getAttribute('class')) ? new String(a.getAttribute('class').match(new RegExp(/splash[0-9]+$/))) : '';
	obj_text = document.createTextNode(splash_titles[splash_id]);
	obj_description.appendChild(obj_text);

	//Resize le fond si l'image est trop grande
	array_page_size = getPageSize();
	total_width = margin_left+parseInt(obj_content.style.width)+margin_right;
	if (total_width > array_page_size[0]) { obj_splash_screen.style.width = total_width+'px'; obj_content.style.left = margin_left+'px'; obj_title.style.left = margin_left+'px'; };
	total_height = margin_top+parseInt(obj_content.style.top)+parseInt(obj_image.height)+parseInt(obj_title.offsetHeight)+margin_bottom;
	if (total_height > array_page_size[1]) { obj_splash_screen.style.height = total_height+'px'; };

	//Initialise la navigation si l'image fait partie d'un groupe
	ini_nav(a);
}

// -----------------------------------------------------------------------------------
//  Affiche la navigation si l'image fait partie d'un groupe
function ini_nav(a) {
	clearTimeout(slide_timeout);
	obj_title = document.getElementById('title_content');

	//Check si l'image fait partie d'un groupe
	rel_attr = new String(a.getAttribute('rel'));
	val = rel_attr.replace(rel_value+'|', '');

	if (splash_groups[val] && document.getElementById('splash_img')) {
		//Création de l'objet splash_previous
		obj_previous = document.createElement('a');
		obj_previous.setAttribute('id', 'splash_previous');
		obj_previous.setAttribute('title', 'Jump to the previous image');
		obj_previous.onmouseover = function() { obj_previous.className = 'over'; }
		obj_previous.onmouseout = function() { obj_previous.className = ''; }
		obj_previous.onclick = function() { splash_previous(); }
		obj_title.appendChild(obj_previous);
        obj_previous.style.zIndex = z_index_mini+6;

		//Création de l'objet splash_next
		obj_next = document.createElement('a');
		obj_next.setAttribute('id', 'splash_next');
		obj_next.setAttribute('title', 'Jump to the next image');
		obj_next.onmouseover = function() { obj_next.className = 'over'; }
		obj_next.onmouseout = function() { obj_next.className = ''; }
		obj_next.onclick = function() { splash_next(); }
		obj_title.appendChild(obj_next);
        obj_next.style.zIndex = z_index_mini+6;

		//Création de l'objet slide_play
		var obj_play = document.createElement('a');
		if (!is_sliding) {
			obj_play.setAttribute('id', 'splash_play');
			obj_play.setAttribute('title', 'Start the slide');
		}
		else {
			obj_play.setAttribute('id', 'splash_pause');
			obj_play.setAttribute('title', 'Pause the slide');
		}
		obj_play.onclick = function() { splash_pause(); }
		obj_play.onmouseover = function() { obj_play.className = 'over'; }
		obj_play.onmouseout = function() { obj_play.className = ''; }
		obj_title.appendChild(obj_play);
        obj_play.style.zIndex = z_index_mini+6;

		//
		if (is_sliding) { slide_timeout = window.setTimeout(splash_next, slide_timeout_value); }
	}
}

// -----------------------------------------------------------------------------------
// To previous image
function splash_previous() {
	current_position = (current_position-1 < 0) ? splash_groups[current_group].length-1 : current_position-1;
	splash_image(splash_as[splash_groups[current_group][current_position]]);
}

// -----------------------------------------------------------------------------------
// To next image
function splash_next() {
	current_position = (current_position+1 == splash_groups[current_group].length) ? 0 : current_position+1;
	splash_image(splash_as[splash_groups[current_group][current_position]]);
}

// -----------------------------------------------------------------------------------
// Pause the slide (ou pas)
function splash_pause() {
	if (!is_sliding) {
		is_sliding = true;
		document.getElementById('splash_play').setAttribute('id', 'splash_pause');
		document.getElementById('splash_pause').setAttribute('title', 'Pause the slide');
		current_position = (current_position == splash_groups[current_group].length) ? 0 : current_position;
		slide_timeout = window.setTimeout(splash_next, slide_timeout_value/4);
	}
	else {
		is_sliding = false;
		document.getElementById('splash_pause').setAttribute('id', 'splash_play');
		document.getElementById('splash_play').setAttribute('title', 'Start the slide');
		clearTimeout(slide_timeout);
	}
}

// -----------------------------------------------------------------------------------
// Notification d'action
function notification() {
	clearTimeout(slide_timeout_notification);
	obj_content = document.getElementById('image_content');
	if (!document.getElementById('splash_notification')) {
		//Création du petit icone playing/paused
		obj_slide = document.createElement('a');
		obj_slide.setAttribute('id', 'splash_notification');
		obj_slide.setAttribute('title', 'Sliding (ou pas)');
		obj_content.appendChild(obj_slide);
        obj_slide.style.zIndex = z_index_mini+6;
		obj_slide.style.top = (parseInt(obj_content.style.height)/2)-25+'px'; //25 car largeur de l'image play/pause divisée par 2
		obj_slide.style.left = (parseInt(obj_content.style.width)/2)-25+'px'; //25 car hauteur de l'image play/pause divisée par 2
		obj_slide.style.width = '50px'; // 50 largeur de l'image play/pause
		obj_slide.style.height = '50px'; // 50 hauteur de l'image play/pause
	}
	else {
		obj_slide = document.getElementById('splash_notification');
	}
	if (is_sliding) {
		obj_slide.className = 'playing';
	}
	else {
		obj_slide.className = 'paused';
		slide_timeout_notification = setTimeout(splash_notification_bye, 2000);
	}
}

// -----------------------------------------------------------------------------------
// Slide notification
function splash_notification_bye() {
	if (document.getElementById('image_content')) {
		obj_content = document.getElementById('image_content');
		obj_content.removeChild(document.getElementById('splash_notification'));
	}
	clearTimeout(slide_timeout_notification);
}

// -----------------------------------------------------------------------------------
// Au revoir Splash
function splash_bye() {
	clearTimeout(slide_timeout);
	clearTimeout(slide_timeout_notification);
	is_sliding = false;
	obj_body = document.getElementsByTagName('body').item(0);
	obj_body.removeChild(document.getElementById('splash_screen'));
	obj_body.removeChild(document.getElementById('image_content'));
	if (document.getElementById('title_content')) { obj_content.removeChild(document.getElementById('title_content')); }
	//On réaffiche les éléments embed et object
    hide_and_show('visible');
}

// -----------------------------------------------------------------------------------
// Check la touche clavier enfoncé
function key_check(e) {
	if (document.getElementById('splash_img')) {
		clearTimeout(slide_timeout);
		what = (e == null) ? event.keyCode : e.which;
		if (in_array(new Array(27, 38, 46, 88), what) >= 0) { //Esc, Suppr, flèche haut, x
			splash_bye();
			return false;
		}
		if (splash_groups[current_group]) {
			if (in_array(new Array(13, 32, 40), what) >= 0) { //Entrée, espace, flèche bas
				splash_pause();
				notification();
				return false;
			}
			if (in_array(new Array(33, 37, 109), what) >= 0) { // Page Up , flèche gauche, -
				splash_previous();
				return false;
			}
			if (in_array(new Array(34, 39, 107), what) >= 0) { // Page Down, flèche droite, +
				splash_next();
				return false;
			}
		}
	}
}

// -----------------------------------------------------------------------------------
// Cache/Affiche les éléments de type Embed/object
function hide_and_show(todo){
	for (i=0; i<objects_2_hide.length; i++) { objects_2_hide[i].style.visibility = todo; }
}

// -----------------------------------------------------------------------------------
// Initialise les liens concernés
function ini_splash_images() {
    //On récupère les objets à cacher
	objs = document.getElementsByTagName('object');
	for (i=0; i<objs.length; i++) {
	    if (objs[i].style.visibility == 'visible' || objs[i].style.visibility == '') { objects_2_hide[objects_2_hide.length] = objs[i]; }
    }
	objs = document.getElementsByTagName('embed');
	for (i=0; i<objs.length; i++) {
	    if (objs[i].style.visibility == 'visible' || objs[i].style.visibility == '') { objects_2_hide[objects_2_hide.length] = objs[i]; }
    }

	splash_groups = new Array();
	splash_as = new Array();
	splash_titles = new Array();
	as = document.getElementsByTagName('a');
	for (i=0; i<as.length; i++) {
		a = as[i];
		rel_attr = new String(a.getAttribute('rel'));
		if (rel_attr.match('splash.image')) { rel_attr = rel_attr.replace('splash.image', 'splash'); a.setAttribute('rel', rel_attr); }
		if (lightbox_replace && rel_attr.match('lightbox')) {
            rel_attr = rel_attr.replace('lightbox', 'splash');
            rel_attr = rel_attr.replace('splash[', 'splash|');
            rel_attr = rel_attr.replace(/]$/, '');
            a.setAttribute('rel', rel_attr);
        }
		rel_attr = new String(a.getAttribute('rel'));
		if (rel_attr.match('splash')) {
			splash_id = 'splash'+i;
			klass = (a.getAttribute('class')) ? a.getAttribute('class')+' '+splash_id : splash_id;
			a.setAttribute('class', klass);
			a.onclick = function () { splash_image(this); return false; }
			val = rel_attr.replace(rel_value+'|', '');
			if (val != rel_value) {
				var array = (!splash_groups[val] || typeof splash_groups[val] != 'object') ? new Array() : splash_groups[val];
				array.push(splash_id);
				splash_groups[val] = array;
			}
			splash_as[splash_id] = a;
			var array = (typeof splash_ids[val] == 'object') ? splash_ids[val] : new Array();
			array.push(splash_id);
			splash_ids[val] = array;
			splash_titles[splash_id] = (a.getAttribute('title')) ? a.getAttribute('title') : 'Image '+i;
		}
	}
	// -----------------------------------------------------------------------------------
	// On lance le check de la touche clavier enfoncée
	document.onkeydown = key_check;
	if (splash_auto_start) { splash_image(splash_as[splash_ids[splash_auto_start_group][splash_auto_start_rank]]); }
}

// -----------------------------------------------------------------------------------
//
// Fonctions annexes
//
// -----------------------------------------------------------------------------------

// -----------------------------------------------------------------------------------
// getPageScroll()
// Returns array with x,y page scroll values.
// Core code from - quirksmode.org
// Code by Lokesh Dhakar
function getPageScroll(){
	var yScroll;
	if (self.pageYOffset) {
		yScroll = self.pageYOffset;
	} else if (document.documentElement && document.documentElement.scrollTop){	 // Explorer 6 Strict
		yScroll = document.documentElement.scrollTop;
	} else if (document.body) {// all other Explorers
		yScroll = document.body.scrollTop;
	}
	arrayPageScroll = new Array('',yScroll)
	return arrayPageScroll;
}

// -----------------------------------------------------------------------------------
// getPageSize()
// Returns array with page width, height and window width, height
// Core code from - quirksmode.org
// Code by Lokesh Dhakar
// Edit for Firefox by pHaez
//
function getPageSize(){
	var xScroll, yScroll;
	if (window.innerHeight && window.scrollMaxY) {
		xScroll = document.body.scrollWidth;
		yScroll = window.innerHeight + window.scrollMaxY;
	} else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
		xScroll = document.body.scrollWidth;
		yScroll = document.body.scrollHeight;
	} else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
		xScroll = document.body.offsetWidth;
		yScroll = document.body.offsetHeight;
	}
	var windowWidth, windowHeight;
	if (self.innerHeight) {	// all except Explorer
		windowWidth = self.innerWidth;
		windowHeight = self.innerHeight;
	} else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
		windowWidth = document.documentElement.clientWidth;
		windowHeight = document.documentElement.clientHeight;
	} else if (document.body) { // other Explorers
		windowWidth = document.body.clientWidth;
		windowHeight = document.body.clientHeight;
	}
	// for small pages with total height less then height of the viewport
	if(yScroll < windowHeight){
		pageHeight = windowHeight;
	} else {
		pageHeight = yScroll;
	}
	// for small pages with total width less then width of the viewport
	if(xScroll < windowWidth){
		pageWidth = windowWidth;
	} else {
		pageWidth = xScroll;
	}
	arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight)
	return arrayPageSize;
}

// -----------------------------------------------------------------------------------
// Core code from - quirksmode.org
function addEvent(obj, evType, fn, useCapture){
	if (obj.addEventListener) {
		obj.addEventListener(evType, fn, useCapture);
		return true;
	}
	else if (obj.attachEvent){
		var r = obj.attachEvent("on"+evType, fn);
		return r;
	}
	else {
		alert("Handler could not be attached");
	}
}

// -----------------------------------------------------------------------------------
//  Check si val est présent dans le tableau ar
// Last update 2007-04-03
// Code by Xuan NGUYEN
function in_array (ar, val) {
	if (ar.length == 0) { return -1; }
	for (i=0; i<ar.length; i++) { if (ar[i] == val) { return i; } }
	return -1;
}

// +------------------------------------------------------------------------+
// + isie()
// +------------------------------------------------------------------------+
function isie() {
	if (navigator.appName == 'Microsoft Internet Explorer') {
		var reg_exp = new RegExp('MSIE [0-9]*.[0-9]*', 'gi');
		var str = new String(navigator.appVersion);
		var result = new String(str.match(reg_exp));
		var array_version = result.split(' ');
		var version = array_version[1];
		return version;
	}
	else {
		return false;
	}
}

//Lance l'ini au chargement de la page
addEvent(window, 'load', ini_splash_images);

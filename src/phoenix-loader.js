$(function() {

    var cssLoader = [{
        file: 'css/metro-bootstrap.css'
    }, {
        file: 'css/metro-bootstrap-responsive.css'
    }, {
        file: 'css/iconFont.css'
    }, {
        file: 'css/docs.css'
    }, {
        file: 'lib/prettify/prettify.css'
    }, {
        file: 'px/system/css/phoenix.css'
    }, {
        file: 'px/system/css/login.css'
    }, {
        file: 'px/system/css/pxGridSearch.css'
    }];
    
    // loop em cssLoader
    $.each(cssLoader, function(i, item) {
        console.log(document.location.pathname + item.file);
        $('<link rel="stylesheet"/>').attr('href', phoenixPackage() + item.file).appendTo($('head'));
    });

    // Overwrite style
    $('<link rel="stylesheet"/>').attr('href', document.location.pathname + 'style.css').appendTo($('head'));


    // JS
    var jsLoader = [{
        file: 'lib/jquery/jquery-ui.min.js'
    }, {
        file: 'lib/jquery/jquery.widget.min.js'
    }, {
        file: 'lib/jquery/jquery.mousewheel.js'
    }, {
        file: 'lib/jquery/jquery.dataTables.js'
    }, {
        file: 'lib/prettify/prettify.js'
    }, {
        file: 'lib/load-metro.js'
    }, {
        file: 'lib/docs.js'
    }, {
        file: 'lib/angular/angular-route.js'
    }, {
        file: 'lib/angular/angular-sanitize.js'
    }, {
        file: 'px/custom/js/directives/customDrc.js'
    }, {
        file: 'px/system/js/controller/loginCtrl.js'
    }, {
        file: 'px/system/js/controller/homeCtrl.js'
    }, {
        file: 'px/system/js/services/loginService.js'
    }, {
        file: 'px/system/js/services/sessionService.js'
    }, {
        file: 'px/system/js/px-top-menu.js'
    }, {
        file: 'px/system/js/px-view-header.js'
    }, {
        file: 'px/system/js/px-grid.js'
    }];

    // loop em jsLoader
    $.each(jsLoader, function(i, item) {
        $("<script/>").attr('src', phoenixPackage() + item.file).appendTo($('head'));
    });


    // HTML
    var htmlLoader = [{
        file: 'lib/polymer/components/core-icons/core-icons.html'
    }, {
        file: 'lib/polymer/components/sampler-scaffold/sampler-scaffold.html'
    }, {
        file: 'lib/polymer/components/font-roboto/roboto.html'
    }, {
        file: 'lib/polymer/components/core-item/core-item.html'
    }, {
        file: 'lib/polymer/components/core-menu/core-submenu.html'
    }, {
        file: 'lib/polymer/components/paper-icon-button/paper-icon-button.html'
    }, {
        file: 'lib/polymer/components/paper-fab/paper-fab.html'
    }];

    // loop em htmlLoader
    $.each(htmlLoader, function(i, item) {
        $('<link rel="import"/>').attr('href', phoenixPackage() + item.file).appendTo($('head'));
    });

});

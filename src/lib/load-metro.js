$(function() {
	if ((document.location.host.indexOf('.dev') > -1) || (document.location.host.indexOf('modernui') > -1)) {
		$("<script/>").attr('src', phoenixPackage() + 'lib/metro/metro-loader.js').appendTo($('head'));
	} else {
		$("<script/>").attr('src', phoenixPackage() + 'lib/metro.min.js').appendTo($('head'));
	}
})

/*
Original:

$(function(){
    if ((document.location.host.indexOf('.dev') > -1) || (document.location.host.indexOf('modernui') > -1) ) {
        $("<script/>").attr('src', 'js/metro/metro-loader.js').appendTo($('head'));
    } else {
        $("<script/>").attr('src', 'js/metro.min.js').appendTo($('head'));
    }
})

 */
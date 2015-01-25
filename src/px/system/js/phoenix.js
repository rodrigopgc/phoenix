// Phoenix App
'use strict';

// Declara níveis de módulos que depende de fitros e serviços
var app = angular.module('phoenixApp', ['ngRoute', 'ngSanitize']);

app.config(['$routeProvider', function($routeProvider) {
    $routeProvider.when('/login', {
        templateUrl: phoenixPackage() + 'px/system/view/login.html',
        controller: 'loginCtrl'
    });
    $routeProvider.when('/home', {
        templateUrl: phoenixPackage() + 'px/system/view/home.html',
        controller: 'homeCtrl'
    });
    $routeProvider.otherwise({
        redirectTo: '/login'
    });
}]);

//[?]
/*
app.run(function($rootScope, $location, loginService){
	var routespermission=['/home'];  //route that require login
	$rootScope.$on('$routeChangeStart', function(){
		if( routespermission.indexOf($location.path()) !=-1)
		{
			var connected=loginService.islogged();
			connected.then(function(msg){
				if(!msg.data) $location.path('/login');
			});
		}
	});
});
*/
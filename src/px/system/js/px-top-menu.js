// Componente <px-top-menu>
// Directive: Menu superior
app.directive('pxTopMenu', function() {
    return {
        restrict: 'E',
        replace: true,
        transclude: false,
        templateUrl: phoenixPackage() + 'px/system/view/topMenu.cfm',
        link: function(scope, element, attrs) {
            // Manipulação e Eventos DOM
            scope.logo = phoenixPackage() + 'px/system/assets/richsolutions/richsolutions_bola_200x200.jpg';
        }
    }
});

// Componente <px-top-menu>
// Controller
app.controller('pxTopMenuCtrl', ['$scope', '$http', function($scope, $http) {

    $scope.templates =
        [{
            name: 'phoenixAction.html',
            url: phoenixPackage() + 'px/custom/view/phoenixAction.html'
        }, {
            name: '',
            url: ''
        }];

    $scope.template = $scope.templates[1];

    //console.log($scope.template);

    $scope.apresentarView = function(componente) {

        console.log('apresentarView');
        console.log(componente);

        var params = new Object();
        params.com_id = componente;
        params.projectRootFolder = document.location.pathname;


        $http({
            method: 'POST',
            url: phoenixPackage() + 'px/system/model/menu.cfc?method=recuperaComponente',
            params: params
        }).success(function(result) {

            console.info('apresentarView.success', result);

            var headerView = result.QCOMPONENTE[0].MEN_NOMECAMINHO.split(result.QCOMPONENTE[0].MEN_NOMECAMINHO.split('»')[result.QCOMPONENTE[0].MEN_NOMECAMINHO.split('»').length - 1])

            $scope.view = new Object();
            $scope.view.result = result;
            $scope.view.men_id = result.QCOMPONENTE[0].MEN_ID;
            $scope.view.caminho = result.QCOMPONENTE[0].MEN_NOMECAMINHO;
            $scope.view.header = headerView[0];
            $scope.view.titulo = result.QCOMPONENTE[0].MEN_NOMECAMINHO.split('»')[result.QCOMPONENTE[0].MEN_NOMECAMINHO.split('»').length - 1];
            $scope.view.icon = result.QCOMPONENTE[0].COM_ICON;

            console.log($scope.view);

            $scope.templates[1].name = result.QCOMPONENTE[0].COM_VIEW;
            $scope.templates[1].url = result.QCOMPONENTE[0].COM_VIEW;

        }).
        error(function(data, status, headers, config) {
            // Erro
            alert('Ops! Ocorreu um erro inesperado.\nPor favor contate o administrador do sistema!');
        });
    }
}]);
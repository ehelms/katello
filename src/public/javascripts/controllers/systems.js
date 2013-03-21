'use strict';

var Katello = angular.module('Katello', ['alchemy', 'ngResource']);

Katello.config(['$httpProvider', function($httpProvider){
    $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content');
}]);

angular.module('Katello').factory('System', ['$resource', '$location', function($resource, $location){
    var query_params = $location.search().search;

    var System = $resource('/katello/api/systems/', { 'search' : query_params });

    return System;
}]);

angular.module('Katello').controller('SystemsController', ['$scope', 'System', '$location', function($scope, System, $location){
    var systems = System.query({ 'organization_id' : 'ACME_Corporation' }, function(){
        var table_data = {};
        table_data.row_headers = ['Name', 'Service Level'];

        table_data.rows = [];
        angular.forEach(systems, 
            function(system){
                var row = {
                    'id' : system.id,
                    'cells': [system.name, system.serviceLevel]
                };
                table_data.rows.push(row);
            });

        $scope.table_data = table_data;
    });

}]);

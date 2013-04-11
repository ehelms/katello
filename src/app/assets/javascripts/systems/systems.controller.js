'use strict';

Katello.config(['$httpProvider', function($httpProvider){
    $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content');
}]);

angular.module('Katello').factory('SystemTable', ['$location', '$http', function($location, $http){
    var SystemTable = {};

    SystemTable.get = function(sort, callback){
        return $http.get('/katello/api/systems/', {
            params : {
                'organization_id' : 'ACME_Corporation', 
                'search' : $location.search().search,
                'sort_by' : sort.by, 
                'sort_order' : sort.order, 
                'paged' : true
            }
        })
        .then(function(response){
            callback(SystemTable.transform(response.data));
        });
    };

    SystemTable.transform = function(data){
        var table_data = {};

        table_data.rows = [];
        angular.forEach(data.systems,
            function(system){
                var row = {
                    'row_id' : system.id,
                    'show'  : true,
                    'cells': [{ 
                        display: system.name,
                        column_id: 'name'
                    },{ 
                        display: system.environment.name,
                        column_id: 'environment'
                    },{ 
                        display: system.content_view_id ? system.content_view_id : "",
                        column_id: 'content_view_id'
                    }]
                };
                table_data.rows.push(row);
            });

        return {
            data    : table_data,
            total   : data.total,
            subtotal: data.subtotal
        };
    };

    return SystemTable;

}]);

angular.module('Katello').controller('SystemsController', ['$scope', 'SystemTable', '$location', function($scope, SystemTable, $location){
    var sort = { by: 'name', order: 'ASC' };

    $scope.table        = {};
    $scope.table.data   = {};
    $scope.table.start  = 0;
    $scope.table.offset = 0;
    $scope.table.total  = 0;
    $scope.table.model  = 'Systems';
    $scope.table.search_string = $location.search().search;

    $scope.table.data.columns = [{
            id: 'name',
            display: 'Name', 
            show: true
        },{
            id: 'environment',
            display: 'Environment',
            show: true
        },{
            id: 'content_view_id',
            display: 'Content View',
            show: true
        }];

    var fetch = function(callback){
        $scope.table.working = true;

        SystemTable.get(sort, function(data){
            $scope.table.data.rows  = data.data.rows;
            $scope.table.total      = data.total;
            $scope.table.start      = data.data.rows.length;
            $scope.table.offset     = data.subtotal;

            if ( callback ){ 
                callback();
            }

            $scope.table.working    = false;
        });
    };

    $scope.table.sort = function(column){
        if (column.id === sort.by){
            sort.order = (sort.order === 'ASC') ? 'DESC' : 'ASC';
        } else {
            sort.order = 'ASC';
            sort.by = column.id;
        }

        angular.forEach($scope.table.data.columns, function(column){
            if( column.active ){
                column.active = false;
            }
        });

        column.active = true;

        fetch(function(){
            angular.forEach($scope.table.data.columns, function(column){
                if( column.active ){
                    column.active = false;
                }
            });

            column.active = true;
        });
    };

    $scope.table.search = function(search_term){
        $location.search('search', search_term);

        fetch();
    };

    fetch();

}]);

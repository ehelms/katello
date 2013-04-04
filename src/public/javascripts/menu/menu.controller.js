'use strict';

Katello.controller('MenuController', ['$scope', '$sanitize', function($scope, $sanitize){

    $scope.menu = KT.main_menu;
    $scope.user_menu = KT.user_menu;
    $scope.admin_menu = KT.admin_menu;
    $scope.notices = KT.notices;

    if( $('body').attr('id') === 'systems' ){
        KT.main_menu['items'][2].active = true;
    } else if( $('body').attr('id') === 'contents' || $('body').attr('id') === 'subscriptions' ){
        KT.main_menu['items'][1].active = true;
    } else if( $('body').attr('id') === 'operations' ){
        KT.admin_menu['items'][0].active = true;
    } else {
        KT.main_menu['items'][0].active = true;
    }

}]);

'use strict';

Katello.controller('MenuController', ['$scope', '$sanitize', function($scope, $sanitize){

    $scope.menu = {
        left : {
            items : [
                { 
                    display : 'Dashboard',
                    href    : 'dashboard'
                },{ 
                    display : 'Content',
                    href    : 'subscriptions',
                    type    : 'dropdown',
                    items   : ''
                },{ 
                    display : 'Systems',
                    href    : 'systems',
                    active  : true
                },{ 
                    display : 'Setup',
                    href    : 'smart_proxies'
                }
            ]
        },
        right: {
            items: [
                {
                    display : 'Configure'
                },{ 
                    display : $sanitize('<a href=""><i class="warning_icon-grey"></i>41</a>')
                }
            ]
        }
    };

    $scope.user_menu = {
        right : {
            items : [
                {
                    display: 'admin',
                    type: 'dropdown',
                    hover: false,
                    items: [
                        {
                            display : 'Admin'
                        },{ 
                            display : 'Notifications'
                        }
                    ]
                }
            ]
        }
    };

    $scope.sub_nav = {
        left : {
            items : [
                { 
                    display : 'Subscriptions',
                    href    : 'subscriptions'
                },{ 
                    display : 'Repositories',
                    href    : 'providers',
                    type    : 'dropdown',
                    items   : ''
                },{ 
                    display : 'Sync Management',
                    href    : 'sync_management'
                },{ 
                    display : 'Content Search',
                    href    : 'content_search'
                }
            ]
        },
    }

}]);

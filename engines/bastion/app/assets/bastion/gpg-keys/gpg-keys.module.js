/**
 Copyright 2013 Red Hat, Inc.

 This software is licensed to you under the GNU General Public
 License as published by the Free Software Foundation; either version
 2 of the License (GPLv2) or (at your option) any later version.
 There is NO WARRANTY for this software, express or implied,
 including the implied warranties of MERCHANTABILITY,
 NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
 have received a copy of GPLv2 along with this software; if not, see
 http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 **/

/**
 * @ngdoc module
 * @name  Bastion.gpg-keys
 *
 * @description
 *   Module for GPG key related functionality.
 */
angular.module('Bastion.gpg-keys', [
    'ngResource',
    'alchemy',
    'alch-templates',
    'ui.state',
    'Bastion.widgets'
]);

/**
 * @ngdoc object
 * @name Bastion.gpg-keys.config
 *
 * @requires $stateProvider
 *
 * @description
 *   Used for systems level configuration such as setting up the ui state machine.
 */
angular.module('Bastion.gpg-keys').config(['$stateProvider', function($stateProvider) {
    $stateProvider.state('gpgKeys', {
        abstract: true,
        controller: 'GPGKeysController',
        templateUrl: 'gpg-keys/views/gpg-keys.html'
    })
    .state('gpgKeys.index', {
        url: '/gpg_keys',
        views: {
            'table': {
                templateUrl: 'gpg-keys/views/gpg-keys-table-full.html'
            }
        }
    })

    .state('gpgKeys.new', {
        url: '/gpg_keys/new',
        collapsed: true,
        views: {
            'table': {
                templateUrl: 'gpg-keys/views/gpg-keys-table-collapsed.html'
            },
            'action-panel': {
                controller: 'NewGPGKeyController',
                templateUrl: 'gpg-keys/new/views/gpg-key-new.html'
            }
        }
    })

    .state("gpgKeys.details", {
        abstract: true,
        url: '/gpg_keys/:gpgKeyId',
        collapsed: true,
        views: {
            'table': {
                templateUrl: 'gpg-keys/views/gpg-keys-table-collapsed.html'
            },
            'action-panel': {
                controller: 'GPGKeyDetailsController',
                templateUrl: 'gpg-keys/details/views/gpg-key-details.html'
            }
        }
    })
    .state('gpgKeys.details.info', {
        url: '/info',
        collapsed: true,
        controller: 'GPGKeyDetailsInfoController',
        templateUrl: 'gpg-keys/details/views/gpg-key-info.html'
    })

    /*.state('products.details.repositories', {
        abstract: true,
        controller: 'ProductRepositoriesController',
        template: '<div ui-view></div>'
    })
    .state('products.details.repositories.index', {
        collapsed: true,
        url: '/repositories',
        templateUrl: 'products/views/product-repositories.html'
    })
    .state('products.details.repositories.new', {
        url: '/repositories/new',
        collapsed: true,
        controller: 'NewRepositoryController',
        templateUrl: 'repositories/views/new.html'
    })
    .state('products.details.repositories.info', {
        url: '/repositories/:repositoryId',
        collapsed: true,
        controller: 'RepositoryDetailsInfoController',
        templateUrl: 'repositories/views/repository-info.html'
    });*/

}]);

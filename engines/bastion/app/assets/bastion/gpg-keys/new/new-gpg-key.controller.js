/**
 * Copyright 2013 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public
 * License as published by the Free Software Foundation; either version
 * 2 of the License (GPLv2) or (at your option) any later version.
 * There is NO WARRANTY for this software, express or implied,
 * including the implied warranties of MERCHANTABILITY,
 * NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
 * have received a copy of GPLv2 along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
*/

/**
 * @ngdoc object
 * @name  Bastion.gpg-keys.controller:NewGPGKeyController
 *
 * @requires $scope
 * @requires GPGKey
 *
 * @description
 *   Controls the creation of an empty GPGKey object for use by sub-controllers.
 */
angular.module('Bastion.gpg-keys').controller('NewGPGKeyController',
    ['$scope', 'GPGKey',
    function($scope, GPGKey) {

        $scope.panel = {loading: false};
        $scope.gpgKey = new GPGKey();

        $scope.save = function(gpgKey) {
            gpgKey.$save(success, error);
        };

        function success(response) {
            $scope.table.addRow(response);
            $scope.transitionTo('gpgKeys.index');
        }

        function error(response) {
            angular.forEach(response.data.errors, function(errors, field) {
                $scope.gpgKeyForm[field].$setValidity('', false);
                $scope.gpgKeyForm[field].$error.messages = errors;
            });
        }

    }]
);

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
 * @name  Bastion.gpgKeys.controller:GPGKeyDetailsInfoController
 *
 * @requires $scope
 * @requires GPGKey
 *
 * @description
 *   Provides the functionality for the gpgKey details action pane.
 */
angular.module('Bastion.gpg-keys').controller('GPGKeyDetailsInfoController',
    ['$scope', '$q', 'GPGKey', function($scope, $q, GPGKey) {

        $scope.saveSuccess = false;
        $scope.saveError = false;
        $scope.panel = $scope.panel || {loading: false};

        $scope.gpgKey = $scope.gpgKey || GPGKey.get({id: $scope.$stateParams.gpgKeyId}, function() {
            $scope.panel.loading = false;
        });

        $scope.save = function(gpgKey) {
            var deferred = $q.defer();

            gpgKey.$update(function(response) {
                deferred.resolve(response);
                $scope.saveSuccess = true;
            }, function(response) {
                deferred.reject(response);
                $scope.saveError = true;
                $scope.errors = response.data.errors;
            });

            return deferred.promise;
        };

        $scope.uploadContent = function(content, completed) {
            var returnData;

            if (content !== "Please wait...") {
                try {
                    returnData = JSON.parse(angular.element(content).html());
                } catch(err) {
                    returnData = content;
                }

                if (!returnData) {
                    returnData = content;
                }

                if (completed && returnData !== null && returnData['status'] === 'success') {
                    $scope.uploadStatus = 'success';
                    $scope.gpgKey.$get();
                } else {
                    $scope.errorMessage = returnData;
                    $scope.uploadStatus = 'error';
                }

                $scope.uploading = false;
            }
        };

    }]
);

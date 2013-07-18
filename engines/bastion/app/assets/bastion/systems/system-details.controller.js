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
 * @name  Bastion.systems.controller:SystemDetailsController
 *
 * @requires $scope
 * @requires Systems
 * @requires Environments
 * @requires ContentViews
 *
 * @description
 *   Provides the functionality for the system details action pane.
 */
angular.module('Bastion.systems').controller('SystemDetailsController', 
    ['$scope', 'Systems', 'Environments', 'ContentViews',
    function($scope, Systems, Environments, ContentViews) {
        var populateExcludedFacts = function () {
            $scope.advancedInfoLeft = {};
            $scope.advancedInfoRight = {};
            var index = 0;
            angular.forEach($scope.systemFacts, function(value, key) {
                if (index % 2 === 0) {
                    $scope.advancedInfoLeft[key] = value;
                } else {
                    $scope.advancedInfoRight[key] = value;
                }
                index = index + 1;
            });
            $scope.hasAdvancedInfo = Object.keys($scope.advancedInfoLeft).length > 0 ||
                Object.keys($scope.advancedInfoRight).length > 0;

        };

        var dotNotationToObj = function(dotString) {
            var dotObject = {}, tempObject, parts, part, key;
            for (var property in dotString) {
                if (dotString.hasOwnProperty(property)) {
                    tempObject = dotObject;
                    parts = property.split('.');
                    key = parts.pop();
                    while (parts.length) {
                        part = parts.shift();
                        tempObject = tempObject[part] = tempObject[part] || {};
                    }
                    tempObject[key] = dotString[property];
                }
            }
            return dotObject;
        };

        $scope.system = {};

        Systems.get({ id: $scope.$stateParams.systemId }).then(function(system) {
            $scope.system = system;
            $scope.systemFacts = dotNotationToObj(system.facts);
            populateExcludedFacts();
        });
        
        $scope.environmentPaths = Environments.paths();

        $scope.releaseVersions = function() {
            return Systems.releaseVersions({ id: $scope.$stateParams.systemId });
        };

        $scope.contentViews = function() {
            return ContentViews.get({ environment_id: $scope.system.environment_id });
        };

        $scope.setContentView = function() {
            $scope.editContentView = false;
            $scope.system.content_view_id = value;
            $scope.system.$update(function() { 
                $scope.currentContentView = $scope.system.content_view;
            });
        };

        $scope.setEnvironment = function(environment_id) {
            $scope.system.environment_id = environment_id;
            $scope.editContentView = true;
        };

        // TODO upgrade to Angular 1.1.4 so we can move this into a directive
        // and use dynamic templates (http://code.angularjs.org/1.1.4/docs/partials/guide/directive.html)
        $scope.getTemplateForType = function(value) {
            var template = 'systems/views/partials/system-detail-value.html';
            if (typeof(value) === 'object') {
                template = 'systems/views/partials/system-detail-object.html';
            }
            return template;
        };
    }]
);

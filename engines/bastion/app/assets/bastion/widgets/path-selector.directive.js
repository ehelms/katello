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
 * @ngdoc directive
 * @name Bastion.widgets.directive:pathSelector
 *
 * @description
 *
 * @example
 */
angular.module('Bastion.widgets').directive('pathSelector',
    ['$document', function($document) {
    return {
        restrict: 'AE',
        scope: {
            pathSelector: '=',
            paths: '=',
            onChange: '&'
        },
        link: function(scope, element, attrs) {

            scope.$watch('paths', function(paths) {
                var path_select,
                    options = {
                        inline: true,
                        select_mode: 'single',
                        expand: false,
                        selected: scope.pathSelector
                    };

                if (paths) {
                    path_select = KT.path_select(
                        'environment_path_selector',
                        'system_details_path_selector',
                        paths,
                        options
                    );

                    $document.bind(path_select.get_select_event(), function(event){
                        var environments = path_select.get_selected();

                        scope.pathSelector = Object.keys(environments)[0];
                        scope.onChange({ environment_id: scope.pathSelector });
                    });
                }
            });
        },
    };
}]);

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
 **/

/**
 * @ngdoc service
 * @name  Bastion.utils.factory:Collection
 *
 * @requires $q
 *
 * @description
 *   Provides a basic Collection factory that knows how to handle the basics
 *   of Katello API objects.
 */
angular.module('Bastion.utils').factory('Collection',
    ['$q', function($q) {
        var Collection = function(resource) {
            var self = this;

            self.records  = [];
            self.offset   = 0;
            self.total    = 0;
            self.subtotal = 0;
            self.resource = resource;

            self.find = function(id) {
                var item;

                angular.forEach(self.records, function(record) {
                    if (record.id === id) {
                        item = record;
                    }
                });

                return item;
            };

            self.get = function(args) {
                var deferred = $q.defer();
                args = args || {};

                if (args['id']) {
                    self.resource.get(args, function(record) {
                        replaceInCollection(record);
                        deferred.resolve(record);
                    });
                } else {
                    if (!args['offset'] || args['offset'] === 0) {
                        self.offset = 0;
                    } else {
                        self.offset = args['offset'];
                    }

                    args['paged'] = true;

                    self.resource.query(args, function(data) {
                        if (self.offset === 0) {
                            self.records = data.records;
                        } else {
                            updateCollection(data.records);
                        }

                        self.offset = self.records.length;
                        self.total = data.total;
                        self.subtotal = data.subtotal;
                        
                        deferred.resolve(data);
                    });
                }

                return deferred.promise;
            };

            function updateCollection(records) {
                angular.forEach(self.records, function(record) {
                    angular.forEach(records, function(newRecord, index) {
                        if (record.id === newRecord.id) {
                            records.splice(index, 1);
                        }
                    });
                });

                self.records = self.records.concat(records);
            };

            function replaceInCollection(record) {
                var index = findIndex(record);

                if (index !== undefined) {
                    self.records[index] = record;
                } else {
                    self.records.push(record);
                    updateCounts(1);
                }
            };


            function findIndex(record) {
                var index;

                angular.forEach(self.records, function(item, itemIndex) {
                    if (item.id === record.id) {
                        index = itemIndex;
                    }
                });

                return index;
            };

            function updateCounts(count) {
                self.offset += count;
                self.total  += count;
                self.subtotal += count;
            };
        };

        return Collection;
    }]
);

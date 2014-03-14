#
# Copyright 2014 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

module Katello
module Validators
  class ContentViewErratumFilterRuleValidator < ActiveModel::Validator
    def validate(record)
      if record.errata_id.blank? && record.start_date.blank? && record.end_date.blank? && record.types.blank?
        invalid_parameters = _("Invalid erratum filter rule specified, Must specify at least one of the following:" +
                                   " 'errata_id', 'start_date', 'end_date' or 'types'")
        record.errors[:base] << invalid_parameters
        return
      end

      if !record.errata_id.blank? && (!record.start_date.blank? ||
                                      !record.end_date.blank? ||
                                      !record.types.blank?)
        invalid_parameters = _("Invalid erratum filter rule specified, 'errata_id' cannot be specified in the" +
                               " same tuple as 'start_date', 'end_date' or 'types'")
        record.errors[:base] << invalid_parameters
        return
      end

      _check_single_date_range(record)
      _check_date_range(record)
      _check_types(record)
    end

    def _check_single_date_range(record)
      if record.start_date || record.end_date || !record.types.empty?
        unless record.filter.erratum_rules.empty?
          invalid_parameters = _("May not add a type or date range rule to a filter that has existing rules.")
          record.errors[:base] << invalid_parameters
        end

      else
        unless record.filter.erratum_rules.with_date_or_type.empty?
          invalid_parameters = _("May not add an id rule to a filter that has an existing type or date range rule.")
          record.errors[:base] << invalid_parameters
        end

      end
    end

    def _check_date_range(record)
      start_date_int = record.start_date.to_time.to_i if !record.start_date.blank?
      end_date_int = record.end_date.to_time.to_i if !record.end_date.blank?

      if start_date_int && (!(start_date_int.is_a?(Fixnum)) || !(record.start_date.is_a?(String)))
        record.errors[:base] <<  _("The erratum filter rule start date is in an invalid format or type.")
      end
      if end_date_int && (!(end_date_int.is_a?(Fixnum)) || !(record.end_date.is_a?(String)))
        record.errors[:base] << _("The erratum filter rule end date is in an invalid format or type.")
      end

      if start_date_int && end_date_int && !(start_date_int <= end_date_int)
        record.errors[:base] << _("Invalid date range. The erratum filter rule start date must come before the end date")
      end
    end

    def _check_types(record)
      if record.types.is_a?(Array)
        invalid_types = record.types.collect(&:to_s) - ContentViewErratumFilter::ERRATA_TYPES.keys
        unless invalid_types.empty?
          record.errors[:base] <<
                            _("Invalid erratum types %{invalid_types} provided. Erratum type can be any of %{valid_types}") %
                            { :invalid_types => invalid_types.join(","),
                              :valid_types => ContentViewErratumFilter::ERRATA_TYPES.keys.join(",")}
        end
      else
        record.errors[:base] << _("The erratum type must be an array. Invalid value provided")
      end
    end

  end
end
end

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
 */
$(document).ready(function(){
  var form_id = $('#new_subpanel'),
      form_submit_id = form_id.find('.subpanel_create'),
      url_after_submit = form_submit_id.data('url_after_submit');

  KT.panel.registerSubPanelSubmit(form_id, form_submit_id, url_after_submit);
});

function content_view_selected(element) {
    var attrs = attribute_hash(['operatingsystem_id', 'organization_id', 'location_id']);

    if (attrs["operatingsystem_id"] !== "") {
        os_selected(element);
    }
};

function os_selected(element){
  var attrs = attribute_hash(['operatingsystem_id', 'organization_id', 'location_id', 'content_view_id']);
  var url = $(element).attr('data-url');
  $(element).indicator_show();
  $.ajax({
    data: attrs,
    type:'post',
    url: url,
    complete: function(){  $(element).indicator_hide();},
    success: function(request) {
      $('#media_select').html(request);
      reload_host_params();
    }
  });
  update_provisioning_image();
}

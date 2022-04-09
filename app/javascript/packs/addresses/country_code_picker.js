$("[id*='country']").change(function(){
	var phone_field = $(this).parent().next().find("[id*='phone']");
  var code = $(this).find("option:selected").data('country-code');
  phone_field.attr('placeholder','+' + code);
});

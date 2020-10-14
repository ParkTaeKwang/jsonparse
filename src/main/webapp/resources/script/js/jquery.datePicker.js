/**
 * Datepicker
 */
var datepicker = function () {

	var buttonImage = '/resources/image/calendar.png';
	var monthNames = [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ];
	var monthShort = [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ];
	var datNamesMin = [ '일', '월', '화', '수', '목', '금', '토' ];
	
	var minDate = new Date();
	minDate.setMonth(minDate.getMonth()-12);

	var defaultOptions = {
		dateFormat           : 'yy.mm.dd'
		, buttonImage        : buttonImage
		, monthNames         : monthNames
		, monthNamesShort    : monthShort
		, dayNamesMin        : datNamesMin
		, closeText          : "닫기"
		, currentText        : "오늘"
		, prevText           : '이전 달'
		, nextText           : '다음 달'
		, yearSuffix         : '년'
		, currentDate        : new Date()
		, showOn             : 'both'
		, showMonthAfterYear : true
		, changeYear         : false
		, changeMonth        : false
		, showButtonPanel    : true
		, showAnim           : 'slideDown'
		, yearRange          : '-100:+1'
		, minDate : minDate
		, maxDate : new Date()
		, onClose : onClose
	};
	
	$('.datepicker').datepicker(defaultOptions);

	function onClose() {
		var event = arguments.callee.caller.caller.arguments[0];
		if ($(event.delegateTarget).hasClass('ui-datepicker-close')) {
//			$(this).val('');
		}
	}
};
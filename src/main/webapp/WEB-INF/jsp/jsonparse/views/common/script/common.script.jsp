<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="scheme" value="${pageContext.request.scheme}"/>
<script type="text/javascript" src="${scheme}://ajax.googleapis.com/ajax/libs/webfont/1.4.10/webfont.js"></script>

<%-- <script type="text/javascript" src="${contextPath}/resources/script/js/alertbox.js"></script> --%>

<script type="text/javascript">
	"use strict";
	var console = window.console || { log : function() {} };

	var CommonUtils = (function() {

		function alert(message, options) {

			var alertOptions = {
				focus : undefined,
				onOk : function(target) {
					if (target) {
						if (typeof target == "string") {
							target = $(target);
						}
						target.focus();
					}
				}
			};

			options = $.extend(true, ($.extend({}, alertOptions)), options);

			var HTML = "<div class='chkState'></div><p class='txt'>" + message + "</p>";

			csscody.alert(HTML, {
				onComplete : function() {
					if (options.onOk && false != options.onOk(options.focus)) {
						options.onOk(options.focus);
					}
				}
			});
		}

/* 		function confirm(message, options) {

			var confirmOptions = {
				onOk : function() {}
			};

			options = $.extend(true, ($.extend({}, confirmOptions)), options);

			var HTML = "<p style='font-family:dotum,tahoma;font-weight:bold;font-size:13px; margin-top:10px;'>" + message + "<br /><br /></p>";

			csscody.confirm(HTML, {
				onComplete : function() {
					if (options.onOk && false != options.onOk()) {
						options.onOk();
					}
				}
			});
		} */
		
		function checkBoxToStr(className) {
			var valueList = [];
			$('.' + className + ':checked').each(function() {
				valueList.push($(this).val());
			});
			return valueList.toString();
		}
		
		function checkBoxToStr2(className) {
			var valueList = [];
			$('.' + className + ':checked').each(function() {
				valueList.push('\'' + $(this).val() + '\'');
			});
			return valueList.toString();
		}

		function linkPage(obj, pageNo) {

			var $form = $("#" + obj) || null;
			$('#currentPageNo').val(pageNo);
			
			if (CheckUtils.isNotEmpty($form)) {
				$form.submit();
			}

		}

		return {
			alert : alert,
			//confirm : confirm,
			checkBoxToStr : checkBoxToStr,
			checkBoxToStr2 : checkBoxToStr2,
			linkPage : linkPage
		}
	})();

	var Const = (function() {

		var YN = {
			Y : "Y",
			N : "N"
		};

		var METHOD = {
			GET : "GET",
			POST : "POST"
		};

		var KEYCODE = {
			ENTER : 13,
			TAB : 9,
			SPACE : 32,
			DELETE : [
				46, // Delete
				8 // Backspace
			],
			DIRECTION : [
				37, // 좌
				38, // 상
				39, // 우
				40 // 하
			],
			CONTROL : [
				16, // Shift
				17, // Ctrl
				18, // Alt
				65, // a
				67, // c
				86 // v
			]
		};

		return {
			YN : YN,
			METHOD : METHOD,
			KEYCODE : KEYCODE
		}
	})();

	var ObjectUtils = (function() {

		function propCount(obj) {
			if (typeof obj !== "object") {
				return false;
			}

			var count = 0;
			for (var $property in obj) {
				if (obj.hasOwnProperty($property)) {
					count++;
				}
			}
			return count;
		}

		function isEmpty(obj) {
			if (typeof obj !== "object") {
				return CheckUtils.isNull(obj, true);
			}

			return 0 === ObjectUtils.propCount(obj);
		}

		function isNotEmpty(obj) {
			return !ObjectUtils.isEmpty(obj);
		}

		function toString(obj) {
			var result = [];

			if (typeof obj !== "object") return obj;

			else {
				for (var property in obj) {
					if (!obj.hasOwnProperty(property)) continue;
					var $info = obj[property];
					result.push(JSON.stringify(property) + ":" + JSON.stringify($info));
				}

				return "{" + result.join(",") + "}";
			}
		}

		function hasName(obj, name) {
			if (typeof obj !== "object") {
				return false;
			}

			for (var property in obj) {
				if (!obj.hasOwnProperty(property)) continue;
				if (property === name) {
					return true;
				}
			}

			return false;
		}

		function hasValue(obj, value) {
			if (typeof obj !== "object") {
				return false;
			}

			for (var property in obj) {
				if (!obj.hasOwnProperty(property)) continue;
				var $info = obj[property];
				if (ObjectUtils.toString($info) == StringUtils.toString(value)) {
					return true;
				}
			}

			return false;
		}

		function getValue(obj, name) {
			if (typeof obj !== "object") {
				return undefined;
			}

			for (var property in obj) {
				if (!obj.hasOwnProperty(property)) continue;
				if (property == name) {
					return obj[property];
				}
			}

			return undefined;
		}

		function equals(value1, value2) {
			if (typeof value1 !== typeof value2) {
				return false;
			}

			if (typeof value1 === "function") {
				return value1.toString() === value2.toString();
			}

			if (value1.isPrototypeOf(value2) || value2.isPrototypeOf(value1)) {
				return false;
			}

			if (value1.constructor !== value2.constructor) {
				return false;
			}

			if (value1.prototype !== value2.prototype) {
				return false;
			}

			if (value1 instanceof Object && value2 instanceof Object) {
				if (ObjectUtils.propCount(value1) !== ObjectUtils.propCount(value2)) {
					return false;
				}

				for (var property in value1) {
					var isEquals = ObjectUtils.equals(value1[property], value2[property]);

					if (!isEquals) {
						return false;
					}
				}
				return true;
			}
			else {
				return value1 === value2;
			}
		}

		return {
			propCount : propCount,
			isEmpty : isEmpty,
			isNotEmpty : isNotEmpty,
			toString : toString,
			hasName : hasName,
			hasValue : hasValue,
			getValue : getValue,
			equals : equals
		}
	})();

	var StringUtils = (function() {

		function isEmpty(value) {
			return CheckUtils.isNull(value) || (CheckUtils.isNotNull(value) && 0 == value.length);
		}

		function isNotEmpty(value) {
			return !StringUtils.isEmpty(value);
		}

		function toString(value) {
			if (CheckUtils.isNull(value)) {
				return "";
			}

			if (typeof value === "object") {
				return ObjectUtils.toString(value);
			}

			return value.toString();
		}

		function equalsIgnoreCase(value1, value2) {
			if (typeof value1 !== "string" || typeof value2 !== "string") {
				return false;
			}
			return String(value1).toUpperCase() === String(value2).toUpperCase();
		}

		function trim(value) {
			if (CheckUtils.isEmpty(value)) {
				return "";
			}
			value = String(value);
			return StringUtils.replace(value, /(^\s*)|(\s*$)/g);
		}

		function replace(value, from, to) {
			if (typeof value !== "string") {
				return value;
			}

			to = to || "";
			return value.replace(from, to);
		}

		function replaceAll(value, from, to) {
			if (typeof value !== "string") {
				return value;
			}

			to = to || "";
			return value.split(from).join(to);
		}

		function toTag(value) {
			/* 	if (typeof value !== "string") {
			 return value;
			 }

			 value = StringUtils.replace(value, /&(lt|gt);/g, function(match, p1) {
			 return (p1 == "lt")? "<" : ">";
			 }); */
			return value;
		}

		function stripTag(value) {
			value = StringUtils.toTag(value);

			return StringUtils.replace(value, /<\/?[^>]+(>|$)/g);
		}

		function nlToBr(value) {
			return StringUtils.replace(value, /(?:\r\n|\r|\n|\\r\\n|\\r|\\n)/g, "<br />");
		}

		function breakingWhitespace(value, to) {
			to = to || " ";
			return StringUtils.replace(value, /\r+|\n+|\t+|\s+/g, to);
		}

		function toNumber(value) {
			if (CheckUtils.isEmpty(value)) {
				return 0;
			}

			return Number(StringUtils.replace(value, /[^+\-\d.]/g, ""));
		}

		function contains(target, value) {
			return target.indexOf(value) >= 0;
		}

		return {
			isEmpty : isEmpty,
			isNotEmpty : isNotEmpty,
			toString : toString,
			equalsIgnoreCase : equalsIgnoreCase,
			trim : trim,
			replace : replace,
			replaceAll : replaceAll,
			toTag : toTag,
			stripTag : stripTag,
			nlToBr : nlToBr,
			breakingWhitespace : breakingWhitespace,
			toNumber : toNumber,
			contains : contains
		}
	})();

	var NumberUtils = (function() {

		function sum(obj, callback) {
			var result = 0;

			obj.each(function() {
				var $this = $(this);
				var value = $this.val() || $this.html() || 0;

				value = StringUtils.toNumber(value);

				if (typeof value != "number") {
					value = Number(value) || 0;
				}

				result += value;
			});

			if (callback && typeof callback === "function") {
				callback(result);
			}
			return result;
		}

		function random(options) {

			var defaultOptions = {
				min : 1,
				max : 99999999999
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			var min = Number(options.min) || 1;
			var max = Number(options.max) || 99999999999;

			if (min > max) {
				max = min;
			}

			return Math.floor((Math.random() * (max - min + 1)) + min);
		}

		return {
			sum : sum,
			random : random
		}
	})();

	var DateUtils = (function() {

		function get(value, origin) {

			origin = origin || false;

			if (typeof value === "string" || typeof value === "number") {
				value = new Date(value);
			}

			var year = value.getFullYear().toString();
			var month = value.getMonth().toString();
			var date = value.getDate().toString();
			var hour = value.getHours().toString();
			var minute = value.getMinutes().toString();
			var second = value.getSeconds().toString();

			if (false == origin) {
				month = (Number(month) + 1).toString();
			}

			return {
				year : year,
				month : month[1] ? month : "0" + month[0],
				date : date[1] ? date : "0" + date[0],
				hour : hour[1] ? hour : "0" + hour[0],
				minute : minute[1] ? minute : "0" + minute[0],
				second : second[1] ? second : "0" + second[0]
			}
		}

		function format(value, pattern) {

			pattern = pattern || "YYYY-MM-DD";

			if (CheckUtils.isNull(value, true)) {
				return "";
			}

			var $info = DateUtils.get(value);
			var yyyy = $info.year;
			var mm = $info.month;
			var dd = $info.date;
			var hh = $info.hour;
			var ii = $info.minute;
			var ss = $info.second;

			pattern = pattern.toString();

			pattern = StringUtils.replace(pattern, /yyyy/gi, yyyy);
			pattern = StringUtils.replace(pattern, /mm/gi, mm);
			pattern = StringUtils.replace(pattern, /dd/gi, dd);
			pattern = StringUtils.replace(pattern, /hh/gi, hh);
			pattern = StringUtils.replace(pattern, /ii/gi, ii);
			pattern = StringUtils.replace(pattern, /ss/gi, ss);

			if (StringUtils.contains(pattern, "NaN")) {
				return "";
			}

			return pattern;
		}

		function diffDay(start, end) {

			var $start = DateUtils.get(start);
			var $end = DateUtils.get(end);

			try {
				start = new Date($start.year, $start.month, $start.date);
				end = new Date($end.year, $end.month, $end.date);

				if (start > end) {
					return -1;
				}

				return Math.ceil((end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24));
			}
			catch (e) {
				return -1;
			}
		}

		function diffMonth(startYear, startMonth, endYear, endMonth) {
			try {
				var start = new Date(startYear, startMonth - 1, 1);
				var end = new Date(endYear, endMonth - 1, 1);

				if (start > end) {
					return -1;
				}

				var monthDiff = (end.getFullYear() - start.getFullYear()) * 12 + (end.getMonth() - start.getMonth());

				if (end.getDate() < start.getDate()) {
					--monthDiff;
				}

				return Math.ceil(monthDiff);
			}
			catch (e) {
				return -1;
			}
		}

		return {
			get : get,
			format : format,
			diffDay : diffDay,
			diffMonth : diffMonth
		}
	})();

	var CheckUtils = (function() {

		function isNull(value, deep) {
			deep = deep || false;

			var isNull = "" === value || null === value || undefined === value;

			if (true === deep) {
				isNull = isNull || "null" === value || "undefined" === value;
			}

			return isNull;
		}

		function isNotNull(value, deep) {
			return !CheckUtils.isNull(value, deep);
		}

		function isEmpty(value) {
			if (CheckUtils.isNull(value, true)) {
				return true;
			}

			return ObjectUtils.isEmpty(value);
		}

		function isNotEmpty(value) {
			return !CheckUtils.isEmpty(value);
		}

		function isPattern(value, pattern) {
			value = StringUtils.trim(value);

			if (CheckUtils.isNull(pattern)) {
				return false;
			}

			return new RegExp(pattern).test(value);
		}

		function isNumberType(value, type) {
			if (CheckUtils.isNull(type, true)) {
				type = /^[+\-]?[0-9]*$/g;
			}

			return CheckUtils.isPattern(value, type);
		}

		function isDateType(value, type) {
			if (CheckUtils.isNull(type, true)) {
				type = /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/;
			}

			return CheckUtils.isPattern(value, type);
		}

		function isKorean(value) {
			return CheckUtils.isPattern(value, /^[가-힣ㄱ-ㅎㅏ-ㅣ]+$/);
		}

		function isEnglish(value) {
			return CheckUtils.isPattern(value, /^[a-zA-Z]+$/);
		}

		function isUrl(value) {
			return CheckUtils.isPattern(value, /^http:|https:\/\/([\w\-]+\.)+/);
		}

		function isEmail(value) {
			return CheckUtils.isPattern(value,  /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i);
		}

		function isPassword(value) {
			return CheckUtils.isPattern(value, /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,16}$/);
		}

		function isPhone(value) {
			return CheckUtils.isPattern(value, /^[0-9]{1,4}[0-9]{3,4}[0-9]{4}$/);
		}

		function isReferer(referrerList, url) {

			var referrer = document.referrer;

			var checkReferrer = referrer.replace("${REQUEST_SERVER}", "");

			var isInvalidReferrer = $.inArray(checkReferrer, referrerList) < 0;

			if (!isInvalidReferrer) {
				CommonUtils.alert("정상적이지 않은 접근 입니다.", {
					onOk : function() {
						var returnUrl = contextPath + "/error?code=E998";

						if (CheckUtils.isNotEmpty(url)) {
							returnUrl += "&url=" + url;
						}

						location.href = returnUrl;
					}
				});
			}
		}
		
		function isFile(file) {
			var ext = file.split('.').pop().toLowerCase();
			if($.inArray(ext, ['zip']) == -1) {
				return false;
			}
			return true;
		}
		
		function isFileSize(fileSize) {
			
			var maxSize  = 10240000;	//10MB
			if (fileSize > maxSize) {
				return false;
			}
			return true;
		}

		return {
			isNull : isNull,
			isNotNull : isNotNull,
			isEmpty : isEmpty,
			isNotEmpty : isNotEmpty,
			isPattern : isPattern,
			isNumberType : isNumberType,
			isDateType : isDateType,
			isKorean : isKorean,
			isEnglish : isEnglish,
			isUrl : isUrl,
			isEmail : isEmail,
			isPassword : isPassword,
			isPhone : isPhone,
			isReferer : isReferer,
			isFile : isFile,
			isFileSize : isFileSize
		}
	})();

	var FormUtils = (function() {

		function getTag(obj) {
			if (typeof obj !== "object") {
				return undefined;
			}

			var target = obj[0] || {};
			var tagName = target.tagName || "";
			var tagType = obj.attr("type") || "";


			return {
				name : tagName.toUpperCase(),
				type : tagType
			}
		}

		function submit(obj, options) {

			var defaultOptions = {
				event : "click",
				form : null,
				before : function(){}
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			var $form = options.form || $("#" + obj.data("form")) || null;

			obj.on(options.event, function() {
				if (!FormUtils.isCorrectPeriod()) {
					return false;
				}
				if (options.before && false === options.before()) {
					return false;
				}
				if (CheckUtils.isNotEmpty($form)) {
					$form.submit();
				}
			});

			// Enter Event
			// $form.find("input").on("keydown", function (e) {
			// 	var checkCode = e.keyCode || e.which;
			// 	if (Const.KEYCODE.ENTER == checkCode) {
			// 		obj.trigger(options.event);
			// 	}
			// });
		}

		function resetValue(obj, options) {

			var defaultOptions = {
				exclude : "no-reset",
				value : ""
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			var ENTRY_TYPE = ["INPUT", "TEXTAREA", "SELECT"];

			obj.not("." + options.exclude).each(function() {
				var $this = $(this);
				var $info = FormUtils.getTag($this);
				var $name = ($info.name || "").toUpperCase();
				var isEntryType = $.inArray($name, ENTRY_TYPE) >= 0;

				if (isEntryType) {
					$this.val(options.value);
				}
				else {
					$this.html(options.value);
				}
			});
		}

		function resetClass(obj, options) {

			var defaultOptions = {
				exclude : "no-reset",
				add : "",
				remove : ""
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			obj.not("." + options.exclude).each(function() {
				var $this = $(this);

				// add class
				var add = options.add;
				if (CheckUtils.isNotEmpty(add, true)) {
					$this.addClass(add);
				}

				// remove class
				var remove = options.remove;
				if (CheckUtils.isNotEmpty(remove, true)) {
					$this.removeClass(remove);
				}
			});
		}

		function resetProp(obj, options) {

			var defaultOptions = {
				exclude : "no-reset",
				name : "",
				prop : true
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			obj.not("." + options.exclude).each(function() {
				var $this = $(this);
				var name = options.name;
				var prop = options.prop;

				if (CheckUtils.isNotEmpty(name, true)) {
					$this.prop(name, prop);
				}
			});
		}

		function clean(obj, options) {

			var defaultOptions = {
				exclude : "no-clean",
				event : "click",
				value : ""
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			obj.on(options.event, function() {
				var $this = $(this);
				var target = $this.data("target") || "clean-target";
				FormUtils.resetValue($("." + target), {exclude : options.exclude, value : options.value});
			});
		}

		function isRequiredAll(options) {

			var defaultOptions = {
				target : "required-check",
				hide : "hide"
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			var $target = $(document.getElementsByClassName(options.target));
			var isRequired = true;

			$target.each(function() {
				var $this = $(this);
				var name = $this.data("required-name");
				var isHidden = $this.is(":hidden") || $this.hasClass(options.hide);

				if (!isHidden && CheckUtils.isEmpty($this.val())) {

					var message = "[" + name + "] " + getCheckText($this) + "은 필수 입니다.";
					alert(message);
					$this.focus();
// 					CommonUtils.alert(message, {focus : $this});

					isRequired = false;
					return isRequired;
				}
			});

			return isRequired;
		}

		function isCorrectPeriod(options) {

			var defaultOptions = {
				wrap : "period-wrap",
				start : "period-start",
				end : "period-end"
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			var $wrap = $(document.getElementsByClassName(options.wrap));
			var isCheck = true;

			$wrap.each(function() {
				var $this = $(this);

				var $start = $this.find("." + options.start);
				var $end = $this.find("." + options.end);

				var startValue = $start.val(), endValue = $end.val();
				var isNotEmpty = CheckUtils.isNotEmpty(startValue) && CheckUtils.isNotEmpty(endValue);

				if (isNotEmpty && startValue > endValue) {
					isCheck = false;

					CommonUtils.alert("기간이 올바르지 않습니다.", {focus : $end});

					return false;
				}
			});

			return isCheck;
		}

		function getCheckText(obj) {

			var TEXT_TAG = ["INPUT", "TEXTAREA"];
			var TEXT_TYPE = ["TEXT", "PASSWORD"];

			var $info = FormUtils.getTag(obj);

			// var isFileType = StringUtils.equalsIgnoreCase("FILE", info.type);
			var isTextTag = $.inArray($info.name, TEXT_TAG) >= 0;
			var isTextType = $.inArray(($info.type).toUpperCase(), TEXT_TYPE) >= 0;
			var isTextArea = $.inArray("TEXTAREA", TEXT_TAG) >= 0;
			/*if (isFileType) return "첨부";
			 else*/
			if (isTextTag && isTextType) return "입력";
			else if (isTextArea) return "입력";
			else return "선택";
		}

		return {
			getTag : getTag,
			submit : submit,
			resetValue : resetValue,
			resetClass : resetClass,
			resetProp : resetProp,
			clean : clean,
			isRequiredAll : isRequiredAll,
			isCorrectPeriod : isCorrectPeriod
		}
	})();

	var FormatUtils = (function() {

		function toNumber(value, options) {

			var defaultOptions = {
				comma : false,
				plus : false,
				minus : true,
				fixed : false,
				point : 2
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			value = StringUtils.trim(value);

			var pattern1 = /[^\-\d.]*/gi;
			var pattern2 = /[+\-]/g;

			value = StringUtils.replace(value, pattern1);
			value = Number(value) || 0;

			// 소수점 자리수
			if (true === options.fixed) {
				value = value.toFixed(options.point);
			}

			var result = String(value);

			// 천단위 여부
			if (true === options.comma) {
				result = toThousand(String(value));
			}

			result = StringUtils.replace(result, pattern2);

			// + 표기 여부
			if (true === options.plus && 0 < value) {
				result = "+" + result;
			}

			// - 표기 여부
			if (true === options.minus && 0 > value) {
				result = "-" + result;
			}

			return String(result);
		}

		function toThousand(value) {
			var pattern1 = /[-|.,:\/]/gi;
			var pattern2 = /(\d)(?=(?:\d{3})+(?!\d))/g;

			if (value.indexOf(".") > -1) {
				var tmp = value.split(".");
				tmp[0] = StringUtils.replace(tmp[0], pattern1);
				tmp[0] = StringUtils.replace(tmp[0], pattern2, "$1,");
				return tmp.join(".");
			}
			else {
				value = StringUtils.replace(value, pattern1);
				value = StringUtils.replace(value, pattern2, "$1,");
				return value;
			}
		}

		return {
			toNumber : toNumber
		}
	})();

	var BrowserUtils = (function() {

		function checkSupport() {
			if (BrowserUtils.isIE(10)) {
				toNotSupportedPage();
			}
		}

		function match(ua) {
			ua = ua.toLowerCase();

			var match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
				/(webkit)[ \/]([\w.]+)/.exec( ua ) ||
				/(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
				/(msie) ([\w.]+)/.exec( ua ) ||
				ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
				[];

			return {
				browser: match[ 1 ] || "",
				version: match[ 2 ] || "0"
			};
		}

		function browser() {
			var matched = match(navigator.userAgent);
			var browser = {};

			if (matched.browser) {
				browser[ matched.browser ] = true;
				browser.version = matched.version;
			}

			// Chrome is Webkit, but Webkit is also Safari.
			if (browser.chrome) {
				browser.webkit = true;
			}
			else if ( browser.webkit ) {
				browser.safari = true;
			}

			return browser;
		}

		function isIE(limit) {
			var browser = BrowserUtils.browser();
			var isIE = browser.msie || false;

			if (CheckUtils.isNotEmpty(limit)) {
				var version = parseInt(browser.version) || 0;
				isIE = isIE && version < Number(limit);
			}

			return isIE;
		}

		function toNotSupportedPage() {
			location.href = "/page/not_supported_browser.html";
		}

		function getName() {
			var data = [
				{string : navigator.userAgent, subString : "Chrome", identity : "Chrome"},
				{string : navigator.userAgent, subString : "Edge", identity : "MS Edge"},
				{string : navigator.userAgent, subString : "MSIE", identity : "Explorer"},
				{string : navigator.userAgent, subString : "Trident", identity : "Explorer"},
				{string : navigator.userAgent, subString : "Firefox", identity : "Firefox"},
				{string : navigator.userAgent, subString : "Opera", identity : "Opera"},
				{string : navigator.userAgent, subString : "OPR", identity : "Opera"},
				{string : navigator.userAgent, subString : "Safari", identity : "Safari"}
			];

			for (var i = 0; i < data.length; i++) {
				var dataString = data[i].string;
				var dataProp = data[i].prop;

				var versionSearchString = data[i].versionSearch || data[i].identity;

				if (dataString) {
					if (dataString.indexOf(data[i].subString) != -1)
						return data[i].identity;
				} else if (dataProp) {
					return data[i].identity;
				}
			}

			if (!!window.chrome && !window.opera) {
				return "Chrome";
			}
			else if (typeof InstallTrigger !== "undefined") {
				return "Firefox";
			}
			else if (Object.prototype.toString.call(window.HTMLElement).indexOf("Constructor") > 0) {
				return "Safari";
			}
			else if (!!document.documentMode) {
				return "Explorer";
			}
			else if (!!window.opera) {
				return "Opera";
			}
			else {
				return "Unknown";
			}
		}

		function reload(openerFlag) {
			openerFlag = openerFlag || false;

			var $window = window;
			if (true === openerFlag && PopupUtils.hasOpener($window)) {
				$window.opener.location.reload();
			}
			$window.location.reload();
		}

		return {
			checkSupport : checkSupport,
			browser : browser,
			isIE : isIE,
			getName : getName,
			reload : reload
		}
	})();

	var CookieUtils = (function() {

		function set(name, value, options) {

			var defaultOptions = {
				path : "/",
				domain : null,
				secure : false,
				encode : true,
				expires : ""
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			var expires = "" , path = "", domain = "", secure = "";

			if (CheckUtils.isNotEmpty(options.encode) && true == options.encode) {
				value = escape(value);
			}
			if (CheckUtils.isNotEmpty(options.expires)) {
				var expireDate = new Date();
				var expireDays = expireDate.getDate() + Number(options.expires);
				expireDate.setDate(expireDays);

				expires = ";expires=" + expireDate.toGMTString();
			}
			if (CheckUtils.isNotEmpty(options.path)) {
				path = ";path=" + options.path;
			}
			if (CheckUtils.isNotEmpty(options.domain)) {
				domain = ";domain=" + options.domain;
			}
			if (CheckUtils.isNotEmpty(options.secure) && true === options.secure) {
				secure = ";secure";
			}

			document.cookie = name + "=" + value + expires + path + domain + secure;
		}

		function get(name) {

			var cookieInfo = document.cookie;
			var cookieName = name + "=";
			var cookieLength = cookieInfo.length;
			var init = 0;
			while (init < cookieLength) {

				var begin = init + cookieName.length;

				if (cookieInfo.substring(init, begin) == cookieName) {
					var end = cookieInfo.indexOf (";", begin);

					if (-1 == end) {
						end = cookieLength;
					}

					return unescape(cookieInfo.substring(begin, end));
				}
				init = cookieInfo.indexOf(" ", init) + 1;

				if (init == 0) {
					break;
				}
			}
			return "";
		}

		function remove(name) {
			var cookieValue = CookieUtils.get(name);

			if (CheckUtils.isNotEmpty(cookieValue)) {
				CookieUtils.set(name, "", {domain : "", expires : -1});
			}
		}

		return {
			set : set,
			get : get,
			remove : remove
		}
	})();

	var PopupUtils = (function() {

		function open(options, callback) {

			var defaultOptions = {
				method : "GET",
				objFrom : null,
				url : "",
				name : "",
				width : 500,
				height : 500,
				top : 0,
				left : 0,
				center : 0,
				location : 0,
				menubar : 0,
				toolbar : 0,
				status : 0,
				scrollbars : 0,
				resizable : 0
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			var top = options.top;
			var left = options.left;

			if (options.center) {
				if (BrowserUtils.isIE()) {
					top  = (window.screenTop - 120) + ((((document.documentElement.clientHeight + 120)/2) - (options.height/2)));
					left = window.screenLeft + ((((document.body.offsetWidth + 20)/2) - (options.width/2)));
				}
				else {
					top = window.screenY + (((window.outerHeight/2) - (options.height/2)));
					left = window.screenX + (((window.outerWidth/2) - (options.width/2)));
				}
			}

			var features = "width=" + options.width
				+ ",height=" + options.height
				+ ",location=" + options.location
				+ ",menuBar=" + options.menubar
				+ ",toolbar=" + options.toolbar
				+ ",status=" + options.status
				+ ",scrollbars=" + options.scrollbars
				+ ",resizable=" + options.resizable
				+ ",top=" + top
				+ ",left=" + left;

			var $popup = null;

			if (StringUtils.equalsIgnoreCase(Const.METHOD.POST, options.method)) {
				$popup = window.open("", options.name, features);

				$(options.objFrom).attr("method", "post");
				$(options.objFrom).attr("target", options.name);
				$(options.objFrom).attr("action", options.url);
				$(options.objFrom).submit();

			}
			else {
				$popup = window.open(options.url, options.name, features);
			}

			if (null == $popup) {
				CommonUtils.alert("차단된 팝업창을 허용 후, 이용하실 수 있습니다.");
			}
			else {
				$popup.focus();
			}

			if (callback && typeof callback === "function") {
				callback();
			}
		}

		function direct(obj) {
			if (typeof obj === "object") {
				window.open(obj.href);
				return false;
			}
		}

		function close() {
			var browser = BrowserUtils.browser();
			if (browser.msie && browser.version >= 7) {
				window.open("about:blank", "_self").close();
			}
			else {
				window.opener = self;
				self.close();
			}
		}

		function hasOpener(target) {
			target = target || window;

			var opener = target.opener;
			return CheckUtils.isNotEmpty(opener);
		}

		return {
			open : open,
			direct : direct,
			close : close,
			hasOpener : hasOpener
		}
	})();

	var HttpUtils = (function() {

		function responseSuccess(r) {
			var message = r.message || ""; 
			var url = r.url || "";

			if (CheckUtils.isNotEmpty(message)) {

				CommonUtils.alert(message);

				// Hide loading bar..
			}

			if (CheckUtils.isNotEmpty(url)) {
				if ("reload" === url) {
					BrowserUtils.reload();
				}
				else {
					window.location.href = url;
				}
			}
		}

		function responseError(e) {
			console.log(e);
			// Hide loading bar..
			var responseJson = e.responseJSON;
			var message = responseJson ? responseJson.message : e.message;
			console.log(e.status + " : " + e.statusText);

			if (CheckUtils.isNotEmpty(message)) {
				CommonUtils.alert(message);
			}
			if (e.statusText === "timeout") {
				CommonUtils.alert("서버의 상태가 원활하지 않습니다.");
			}
		}

		var response = {
			success : responseSuccess,
			error : responseError
		};

		var ajaxDataOptions = {
			type : "POST",
			success : response.success,
			error : response.error,
			block : true,
			before : function(){}
		};

		function ajaxData(url, data, options) {

			options = $.extend(true, $.extend({}, ajaxDataOptions), options);

			if (data && typeof data === "object") {
				data = JSON.stringify(data);
			}

			$.ajax({
				data : data? data : null,
				url : url,
				contentType : "application/json",
				dataType : "json",
				type : options.type,
				success : options.success,
				error : options.error,
				beforeSend : function (xmlHttpRequest) {
					if (options.before && typeof options.before === "function") {
						options.before();
					}

					if (true === options.block) {
						// Show loading bar..
					}
					
					var csrfName = "${_csrf.headerName}";
					var csrfValue = "${_csrf.token}";
					xmlHttpRequest.setRequestHeader(csrfName, csrfValue);
					xmlHttpRequest.setRequestHeader("AJAX", "true");
				}
			});
		}

		function ajaxFormData(formId, options) {
			
			options = $.extend(true, $.extend({}, ajaxDataOptions), options);
			
			$('#' + formId).ajaxForm({
				dataType		: 'json',
				type			: options.type,
				beforeSerialize	: options.before,
				success			: options.success,
				error			: options.error
			}).submit();
			
		}
		
		return {
			response : response,
			ajaxData: ajaxData,
			ajaxFormData: ajaxFormData
		}
	})();

	var LinkUtils = (function() {

		function view(param) {
			PopupUtils.open({
				url : "${REQUEST_SERVER}" + "/someting/urls/" + param,
				name : "POPUP_VIEW_SOMETHING_TITLE",
				width : 1200,
				height : 800,
				center : 1
			});
		}

		return {
			view : view
		}
	})();

	var EventUtils = (function() {

		function isNormalKey(event) {
			var keyCode = Number(event.keyCode.toString());
			var isNotDelete = $.inArray(keyCode, Const.KEYCODE.DELETE) < 0;
			var isNotDirection = $.inArray(keyCode, Const.KEYCODE.DIRECTION) < 0;

			var isControlKey = event.ctrlKey || event.altKey || event.shiftKey;
			var isCopyNPasteKey = $.inArray(keyCode, Const.KEYCODE.CONTROL) >= 0;

			return isNotDelete && isNotDirection && !(isControlKey && isCopyNPasteKey);
		}

		function onlyType(target, options) {

			var filterOptions = {
				type : /[^\d]/g,
				event : "keyup",
				filter : false,
				target : 0,
				func : null
			};

			options = $.extend(true, ($.extend({}, filterOptions)), options);

			target.on(options.event, function(e) {
				var $this = $(this);
				var value = String($this.val() || "");
				if (isNormalKey(e) && !$this.prop("readonly")) {

					value = StringUtils.replace(value, options.type);

					if (options.func && typeof options.func === "function") {
						value = options.func(value);
					}

					// 첫글자 제외 여부
					if (true === options.filter && CheckUtils.isNotEmpty(value)) {
						var first = value.substring(0, 1);
						if (String(options.target) == String(first)) {
							value = value.substring(1, value.length);
						}
					}

					value = StringUtils.replace(value, options.type);
					$this.val(value);
				}
			});
		}

		function onKeys(target, options) {

			var defaultOptions = {
				keys : [],
				func : function(){}
			};

			options = $.extend(true, $.extend({}, defaultOptions), options);

			target.on("keydown", function (e) {
				var checkCode = e.keyCode || e.which;

				if ($.inArray(checkCode, options.keys) >= 0) {
					e.preventDefault();
					options.func();
				}
			});
		}

		function onMoney(target, options) {

			var filterOptions = {
				filter : false,
				target : 0
			};

			options = $.extend(true, ($.extend({}, filterOptions)), options);

			// Number to money
			target.on("focusout", function() {
				var $this = $(this);
				var thisValue = $this.val() || 0;
				var moneyValue = FormatUtils.toNumber(thisValue, {comma : true});
				$this.val(moneyValue);
			});

			// Filter
			if (true === options.filter) {
				target.on("focusin", function() {
					var $this = $(this);
					var thisValue = $this.val();
					thisValue = FormatUtils.toNumber(thisValue);

					if (options.target == thisValue || String(options.target) == thisValue) {
						thisValue = "";
					}

					$this.val(thisValue);
				});
			}
		}

		function onCheckbox(all, target) {

			target = target.not(":disabled");

			onLoadCheckbox(all, target);
			onCheckboxByAll(all, target);
			onCheckboxByTarget(all, target);
		}

		function onLoadCheckbox(all, target) {
			var targetLength = target.length;
			var checkedLength = target.filter(":checked").length;

			var isEqualCheckedLength = targetLength == checkedLength;
			if (0 < targetLength && isEqualCheckedLength) {
				all.prop("checked", true);
			}
		}

		function onCheckboxByAll(all, target) {
			all.on("change", function () {
				$(this).prop("checked", function (index, oldProp) {
					target.prop("checked", oldProp);
				});
			});
		}

		function onCheckboxByTarget(all, target) {
			target.on("change", function () {
				var isAllChecked = true;

				target.each(function() {
					var thisChecked = $(this).prop("checked");

					if (thisChecked != all.prop("checked")) {
						all.prop("checked", false);
					}
					if (false === thisChecked) {
						isAllChecked = false;
						return isAllChecked;
					}
				});

				all.prop("checked", isAllChecked);
			});
		}

		function showHide($obj, options) {

			var defaultOptions = {
				event : "click",
				show : "control-show",
				hide : "control-hide",
				control : "hide"
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			$obj.on(options.event, function () {
				var controlClass = options.control;
				var $showTarget = $("." + options.show);
				var $hideTarget = $("." + options.hide);

				$($showTarget).addClass(controlClass);
				$($hideTarget).removeClass(controlClass);
			});
		}

		function toggle(obj, options) {

			var defaultOptions = {
				event : "change",
				target : "toggle-target",
				toggle : "hide"
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			obj.on(options.event, function () {
				$("." + options.target).toggleClass(options.toggle);
			});
		}

		return {
			onlyType : onlyType,
			onKeys : onKeys,
			onMoney : onMoney,
			onCheckbox : onCheckbox,
			showHide : showHide,
			toggle : toggle
		}
	})();

	var CloneUtils = (function() {

		function append(target, options) {

			var defaultOptions = {
				event : "click",
				wrap : "append-wrap",
				area : "append-area",
				reset : true,
				func : function(obj){}
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			target.on(options.event, function() {
				var $this = $(this);
				var $appendWrap = $this.closest("." + options.wrap);
				var $appendArea = $this.closest("." + options.area);

				var $cloneObj = $appendArea.clone(true, true);

				if (true === options.reset) {
					FormUtils.resetValue($cloneObj.find("input, select, textarea, span"));
				}

				if (options.func && typeof options.func === "function") {
					options.func($cloneObj);
				}

				$appendWrap.find("." + options.area).last().after($cloneObj);
			});
		}

		function remove(target, options) {

			var defaultOptions = {
				event : "click",
				wrap : "remove-wrap",
				area : "remove-area",
				hide : true,
				func : function(obj){}
			};

			options = $.extend(true, ($.extend({}, defaultOptions)), options);

			target.on(options.event, function() {
				var $this = $(this);
				var $removeWrap = $this.closest("." + options.wrap);
				var $removeArea = $this.closest("." + options.area);

				var count = $removeWrap.find("." + options.area).not(":hidden").length;

				// Reset
				FormUtils.resetValue($removeArea.find("input, select, textarea, span"));

				if (options.func && typeof options.func === "function") {
					options.func($removeArea);
				}

				if (1 < count) {
					true === options.hide ? $removeArea.hide() : $removeArea.remove();
				}
			});
		}

		return {
			append : append,
			remove : remove
		}
	})();

	var BlockUtils = (function() {

		// BLOCK UI LIST : 메세지 HTML
		// 기준선 이하 수정금지

		var defaultOptions = {
			message : "",
			css: {
				padding: 0,
				margin: 0,
				width: "100%",
				height: "100%",
				top: "0%",
				left: "0%",
				textAlign: "center",
				color: "#000",
				border: "",
				backgroundColor: "#fff",
				cursor: "wait"
			},
			overlayCSS:  {
				backgroundColor: ""
			}
		};

		function blockShow(options) {
			$.blockUI(options);
		}

		function blockHide(options) {
			$.unblockUI(options);
		}

		//////// ======= 기준선 ======= ///////

		/**
		 * BLOCK UI
		 * @param callback
		 */
		function init(callback) {

			var blockOptions = $.extend($.extend({}, defaultOptions), { message : $("#block_loading_wrap").html() });

			blockShow(blockOptions); // SHOW

			var time = 1; // 기본 1초
			time = Number(time) * 1000;

			// 해당 시간 뒤 실행
			setTimeout(function() {

				// 콜백 있을 경우 실행
				if (callback && typeof callback == "function") {
					callback();
				}

				// blockHide(blockOptions); // HIDE
				
			}, time);
		}

		return {
			init : init
		}
	})();
	
	//엑셀 다운로드
	var ExcelUtils = (function() {
		/**
		 * 엑셀 다운로드
		 */
		function download() {
			
			var paramObj = $('.excelParamObj');
			var excelType = paramObj.data('excel');
			window.location.href = contextPath + '/' + excelType + '?type=' + excelType + paramObj.val();
		}
		
		return {
			download : download
		}
	})();
	
</script>

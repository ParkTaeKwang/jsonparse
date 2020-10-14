/**
 * 
 */
var contextPath = "${contextPath}";

function noticeList() {
	location.href = "/help/notice/list";
}

function back() {
	history.back();
}

// 폼 검사 후 안내문구 처리
function checkInput(element, msg, color) {
	if(color == "red") {
		$(element).data("flag", false);
	} else {
		$(element).data("flag", true);
	}
	$(element).empty();
	$(element).append(msg);
	$(element).css({
		"color" : color,
		"font-size" : "13px"
	});
}


/**********문서 업로드 START *****************/
const MAX_FILE_SIZE = 4194304; // 4MB
const MAX_TOTAL_FILE_SIZE = 41943040; // 40MB

var totalFileSize = 0;
var fileList = new Array();
var browserChk = "";
$(function() {
	var userAgent = window.navigator.userAgent.toLowerCase(); 
	var checkChrome = userAgent.indexOf('chrome'); 
	var checkEdge = userAgent.indexOf('edge'); 
	var checkIE = userAgent.indexOf('trident'); 
	if(checkChrome > -1){ 
		if(checkEdge > -1){ 
			//Edge는 Chrome과 Edge 모두의 값을 가지고 있기 때문에 
			//Edge 브라우저
			alert("DocuChain 사이트는 Chrome과 IE를 권장합니다. \n 다른 브라우저 이용시 기능이 제한될 수 있습니다.");
		} else { 
			//Chrome 브라우저
			browserChk = "Chrome"
		}
	} else { 
		//크롬아님
		 if(checkIE > -1) {
			 //IE
			 browserChk = "IE";
		 } else {
			 alert("DocuChain 사이트는 Chrome과 IE를 권장합니다.\n다른 브라우저 이용시 기능이 제한될 수 있습니다.");
		 }
	}
	fileDragUploader();
});

function fileDragUploader() {
	var page = $("#file_upload_page");
	var box = $("#file_upload_box");
	var text = $(".upload_txt");
	
	page.on("dragenter", function(e) {
		e.stopPropagation();
		e.preventDefault();
		
		box.css("border-color", "#1bb1e8");
		text.css("color", "#1bb1e8");
	});
	page.on("dragleave", function(e) {
		e.stopPropagation();
		e.preventDefault();
		
		box.css("border-color", "#d3d3d3");
		text.css("color", "#888");
	});
	page.on("dragover", function(e) {
		e.stopPropagation();
		e.preventDefault();
		
		box.css("border-color", "#1bb1e8");
		text.css("color", "#1bb1e8");
	});
	page.on("drop", function(e) {
		e.stopPropagation();
		e.preventDefault();
		box.css("border-color", "#d3d3d3");
		text.css("color", "#888");
		
		if(browserChk == "IE") {
			fileAttach(e.originalEvent.dataTransfer.files, $("#fileMenu").val());
		} else {
			fileAttach(e.originalEvent.dataTransfer.items, $("#fileMenu").val());
		}
	});
}
function upFileChange() {
	fileAttach($("#files")[0].files, $("#fileMenu").val());
}
function fileUploader() {// 'U' : 업로드, 'V' : 검증
	$("#files").trigger("click");
	$("#files").off();
	
}
function fileAttach(files, menu) {
	var isError = false;
	var isUploadFail = false;
	var isOverMaxSize = false;
	
	var ul = $(".uploaded_file ul");
	if(files.length > 0) {
		var maxLen = ul[0].children.length + files.length;
		if(maxLen > 1) {
			alert('1개의 파일만 업로드 가능합니다.');
			return;
		}
		for(var i=0; i<files.length; i++) {
			
			var file;
			
			
			if(browserChk == "IE") {
				if("U" == menu) {
					if(files[i].type.split("/")[0] == 'application') {
						file = files[i];
					} else {
						alert("업로드 실패, 첨부파일을 확인하십시오.(pdf 형식 지원)");
						isUploadFail = true;
						break;
					}
				} else {
					file = files[i];
				}
				
			} else {
				if(files.constructor.name == "DataTransferItemList" && files[i].kind === "file") {
					file = files[i].getAsFile();
				} else if(files.constructor.name == "FileList") {
					file = files[i];
				} else {
					console.log("업로드 실패, 첨부파일을 확인하십시오.");
					isUploadFail = true;
					break;
				}
			}
			
			
			if("U" == menu) {
//				var fileTypeArr = ['pdf', 'hwp','doc','docx','xls','xlsx','ppt','pptx','gif','jpg','png','txt'];
				var fileTypeArr = ['pdf'];
				var cnt = 0;
				for(j=0;j<fileTypeArr.length;j++) {
					if(file.name.substring(file.name.lastIndexOf(".")+1).toLowerCase() == fileTypeArr[j] ) {
						cnt++;
						break;
					}
				}			
				if(cnt == 0) {
//					alert("파일형식이 올바르지 않습니다. (pdf,hwp,doc,xls,ppt,gif,jpg,png 형식 지원)");
					alert("파일형식이 올바르지 않습니다. (pdf 형식 지원)");
					break;
				}
			}			
			
			if(file.size > MAX_FILE_SIZE) {
				isOverMaxSize = true;
				alert("첨부 가능 용량을 초과했습니다. (최대 4MB)");//첨부 가능 용량을 초과했습니다. (파일 당 4MB, 최대 40MB)
				break;
			}
			if(totalFileSize + file.size > MAX_TOTAL_FILE_SIZE) {
				isOverMaxSize = true;
				alert("첨부 가능 용량을 초과했습니다. (최대 4MB)");
				break;
			}
			var fileNe = file.name;
			fileList.push(file);
			totalFileSize += file.size;
			if(30 < fileNe.length ) {
				fileNe = fileNe.substring(0, 30) + "...";
			}
			var appendLi = $("<li>" + 
							 "	<span class='rmBtn'>X</span>" + 
							 "	<span>"+fileNe+"</span>" + 
							 "	<span>"+dataConvert(file.size)+"</span>" + 
							 "</li>");
			appendLi.appendTo(ul);
			
		}
		
		isError = isUploadFail || isOverMaxSize;
		
		if(!isError) {
			$(".upload_txt").hide();
			$(".uploaded_file").show();
			rmSelectFile();
		}
	}
}

function dataConvert(b) {
	var convertB = 0;
	if(b < 1024000) {
		// Byte -> KB
		convertB = (b/1024).toFixed(2);
		convertB += "KB";
	} else {
		// Byte -> MB
		convertB = (b/Math.pow(1024, 2)).toFixed(2);
		convertB += "MB";
	}
	
	return convertB;
}

function rmSelectFile() {
	$(".file_list .rmBtn").off();
	$(".file_list .rmBtn").on("click", function() {
		var li = $(this).parent();
		totalFileSize -= fileList[li.index()].size;
		fileList.splice(li.index(), 1);
		li.remove();
		$("#files").val(null); 
		if(fileList.length == 0) {
			$(".upload_txt").show();
			$(".uploaded_file").hide();
		}
	});
}

function submit(menu, headerName, token) {
	var rtn = 1;
	var formData = new FormData($("#fileUpload")[0]);
	if(fileList.length>1) {
		alert('1개씩 업로드 할 수 있습니다.');
		rtn = 0;
		return rtn;
	}
	if(fileList.length == 0) {
		alert('첨부한 파일이 없습니다.');
		rtn = 0;
		return rtn;
	}
	if(browserChk == "IE") {
		$("input[name='files']").val(null);
	} else {
		formData.delete("files");
	}
	for(var i=0; i<fileList.length; i++) {
		formData.append('files', fileList[i]);
	}
	if(browserChk == "IE") {
		if($("input[name='files']").length == 0) {
			alert("첨부한 파일이 없습니다.");
			rtn = 0;
			return rtn;
		}
	} else {
		if(formData.getAll("files").length == 0) {
			alert("첨부한 파일이 없습니다.");
			rtn = 0;
			return rtn;
		}
	}
	
	$.ajax({
		type: "POST",
		enctype : "multipart/form-data",
		url : $("#reqUrl").val(),
		data : formData,
		processData : false,
		contentType : false,
		cache : false,
		beforeSend : function (xmlHttpRequest) {
			xmlHttpRequest.setRequestHeader(headerName, token);
			xmlHttpRequest.setRequestHeader("AJAX", "true");
		},
		success : function(r) {
//			console.log(r);
			if("U" == menu) {
				if(r.resultCode == "FAILURE") {
					alert(r.message);
					window.location.reload();
					rtn = 0;
					return rtn;
				}
				$(".docLoading img").attr("src", "/resources/image/3step2.png");
				
				fileUpCom(r.docInfo);
			} else {
//				alert('문서업로드에 성공하였습니다.');
			}	
		},
		error : function(e) {
			alert('문서업로드에 실패하였습니다.');
			if("U" == menu) {
				window.location.reload();
			}
		}
	});
}

function fileUpCom(params) {
	HttpUtils.ajaxData("/document/docFileUpPdf", params, {
		success : function(r) {
			console.log(r);
			if(r.resultCode == "FAILURE") {
				alert(r.message);
				window.location.reload();
			}
			$(".docLoading img").attr("src", "/resources/image/3step3.png");
	 		setTimeout(function() {
				window.location.reload();
			}, 1000);
		},
		error : function(r) {
			alert(r.message);
			window.location.reload();
		}
	});	
}
/***********문서 업로드 END**************/


$(function () {

	$("#date1").datepicker({
		showOn: "button",
		buttonImage: "../image/calendar.gif",
		buttonImageOnly: false,
		buttonText: "Select date",

	});

});
$(function () {

	$("#date2").datepicker({
		showOn: "button",
		buttonImage: "../image/calendar.gif",
		buttonImageOnly: false,
		buttonText: "Select date"
	});
});



$(document).ready(function () {

	$('#date1').datepicker({
		dateFormat: 'yy/mm/dd'
	});

	$('#date1').datepicker('setDate', new Date());

});


function closeLayer(obj) {
	$(obj).parent().parent().hide();
}

function dateChangeZero(param) {
	//날짜가 한자리 수일 경우 0 붙임
	//param : YYYY.MM.DD 형태 / return : YYYY.MM.DD
	var searchDate = param.split('.');
	var finalDate = "";
	
	for(i=1;i<searchDate.length;i++) {
		if(searchDate[i].length == 1) {
			searchDate[i] = "0" + searchDate[i];
		}
	}	
	for(i=0;i<searchDate.length;i++) {
		finalDate += searchDate[i];
		if(i != searchDate.length -1) {
			finalDate += ".";			
		}		
	}
	return finalDate;
}

function changeDate(param) {
	if(StringUtils.isEmpty(param)) {
		param = "";
	}
	var startVal = $("#startDate" + param).val();
	$("#endDate" + param).datepicker('option', {
		minDate : startVal
	});
}

$(function () {

	$('.imgSelect').mouseover(function (e) {
		var sWidth = window.innerWidth;
		var sHeight = window.innerHeight;

		var oWidth = $('.contboxwrap').width();
		var oHeight = $('.contboxwrap').height();

	
		var divLeft = e.clientX + 50;
		var divTop = e.clientY + 0;

		if (divLeft < 0) divLeft = 0;
		if (divTop < 0) divTop = 0;

		$('.contboxwrap').css({
			"top": divTop,
			"left": divLeft,
			"position": "absolute"
		}).show();
	});

});


$(function() {
	$(".close_btn").click(function() {
		cancel();
	});
})
$(function() {
	function docViewIECheck() {
		//IE에서 미리보기를 하기 위해 Acrobat 설치 유무 확인
		if("IE" == browserChk) {	
			try {
				var pdfAcro= new ActiveXObject("AcroPDF.PDF"); 
			} catch(e){
				alert("Adobe Acrobat Reader설치가 필요합니다.\n설치 완료 후 다시 시도해 주십시오.");
				var win = window.open("https://get.adobe.com/kr/reader/", '_blank', "noopener,noreferrer");
		        win.focus();
		        return false;
			}
			
		}	
		return true;
	}
})

function docViewIECheck() {
	//IE에서 미리보기를 하기 위해 Acrobat 설치 유무 확인
	if("IE" == browserChk) {	
		try {
			var pdfAcro= new ActiveXObject("AcroPDF.PDF");
		} catch(e){
			alert("Adobe Acrobat Reader설치가 필요합니다.\n설치 완료 후 다시 시도해 주십시오.");
			var win = window.open("https://get.adobe.com/kr/reader/", '_blank', "noopener,noreferrer");
	        win.focus();
	        return false;
		}
	}	
	return true;
}

function documentView(issuCd, viewAddr) {
	viewAddr = StringUtils.replaceAll(viewAddr, "&amp;", "&");
	if(issuCd == "M") {
//		window.open("/document/issued/upView?viewAddr="+viewAddr, "_blank", "width=800,height=900,noopener,noreferrer");
		var win = window.open(viewAddr, "_blank", "width=800,height=900");
		win.opener = null;
	} else {
		window.open(viewAddr, "_blank", "width=800,height=900,noopener,noreferrer");
	}
}

$(function() {
	$("input").attr("autocomplete", "off");
})

/****************************
 * SHA256 암호화
 * @param s
 * @returns
 *****************************/

function SHA256(s){
      
        var chrsz   = 8;
        var hexcase = 0;
      
        function safe_add (x, y) {
            var lsw = (x & 0xFFFF) + (y & 0xFFFF);
            var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
            return (msw << 16) | (lsw & 0xFFFF);
        }
      
        function S (X, n) { return ( X >>> n ) | (X << (32 - n)); }
        function R (X, n) { return ( X >>> n ); }
        function Ch(x, y, z) { return ((x & y) ^ ((~x) & z)); }
        function Maj(x, y, z) { return ((x & y) ^ (x & z) ^ (y & z)); }
        function Sigma0256(x) { return (S(x, 2) ^ S(x, 13) ^ S(x, 22)); }
        function Sigma1256(x) { return (S(x, 6) ^ S(x, 11) ^ S(x, 25)); }
        function Gamma0256(x) { return (S(x, 7) ^ S(x, 18) ^ R(x, 3)); }
        function Gamma1256(x) { return (S(x, 17) ^ S(x, 19) ^ R(x, 10)); }
      
        function core_sha256 (m, l) {
             
            var K = new Array(0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5, 0x3956C25B, 0x59F111F1,
                0x923F82A4, 0xAB1C5ED5, 0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3,
                0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174, 0xE49B69C1, 0xEFBE4786,
                0xFC19DC6, 0x240CA1CC, 0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA,
                0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7, 0xC6E00BF3, 0xD5A79147,
                0x6CA6351, 0x14292967, 0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13,
                0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85, 0xA2BFE8A1, 0xA81A664B,
                0xC24B8B70, 0xC76C51A3, 0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070,
                0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5, 0x391C0CB3, 0x4ED8AA4A,
                0x5B9CCA4F, 0x682E6FF3, 0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208,
                0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2);
 
            var HASH = new Array(0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, 0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19);
 
            var W = new Array(64);
            var a, b, c, d, e, f, g, h, i, j;
            var T1, T2;
      
            m[l >> 5] |= 0x80 << (24 - l % 32);
            m[((l + 64 >> 9) << 4) + 15] = l;
      
            for ( var i = 0; i<m.length; i+=16 ) {
                a = HASH[0];
                b = HASH[1];
                c = HASH[2];
                d = HASH[3];
                e = HASH[4];
                f = HASH[5];
                g = HASH[6];
                h = HASH[7];
      
                for ( var j = 0; j<64; j++) {
                    if (j < 16) W[j] = m[j + i];
                    else W[j] = safe_add(safe_add(safe_add(Gamma1256(W[j - 2]), W[j - 7]), Gamma0256(W[j - 15])), W[j - 16]);
      
                    T1 = safe_add(safe_add(safe_add(safe_add(h, Sigma1256(e)), Ch(e, f, g)), K[j]), W[j]);
                    T2 = safe_add(Sigma0256(a), Maj(a, b, c));
      
                    h = g;
                    g = f;
                    f = e;
                    e = safe_add(d, T1);
                    d = c;
                    c = b;
                    b = a;
                    a = safe_add(T1, T2);
                }
      
                HASH[0] = safe_add(a, HASH[0]);
                HASH[1] = safe_add(b, HASH[1]);
                HASH[2] = safe_add(c, HASH[2]);
                HASH[3] = safe_add(d, HASH[3]);
                HASH[4] = safe_add(e, HASH[4]);
                HASH[5] = safe_add(f, HASH[5]);
                HASH[6] = safe_add(g, HASH[6]);
                HASH[7] = safe_add(h, HASH[7]);
            }
            return HASH;
        }
      
        function str2binb (str) {
            var bin = Array();
            var mask = (1 << chrsz) - 1;
            for(var i = 0; i < str.length * chrsz; i += chrsz) {
                bin[i>>5] |= (str.charCodeAt(i / chrsz) & mask) << (24 - i%32);
            }
            return bin;
        }
      
        function Utf8Encode(string) {
            string = string.replace(/\r\n/g,"\n");
        var utftext = "";
  
        for (var n = 0; n < string.length; n++) {
  
            var c = string.charCodeAt(n);
  
            if (c < 128) {
                utftext += String.fromCharCode(c);
            }
            else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            }
            else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }
  
        }
  
        return utftext;
    }
  
    function binb2hex (binarray) {
        var hex_tab = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
        var str = "";
        for(var i = 0; i < binarray.length * 4; i++) {
            str += hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8+4)) & 0xF) +
            hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8  )) & 0xF);
        }
        return str;
    }
  
    s = Utf8Encode(s);
    return binb2hex(core_sha256(str2binb(s), s.length * chrsz));
  
}

function spaceBarChk(param) {
	//공백사용 제한
	if(window.event.keyCode == 32) {
		alert("공백 입력이 불가합니다.");
		$("#"+param.id).val($("#"+param.id).val().replace(/(\s*)/gi, "") );
	}
}


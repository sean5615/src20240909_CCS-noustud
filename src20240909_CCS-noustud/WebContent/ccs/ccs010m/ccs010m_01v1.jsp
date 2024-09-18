<%@ page import="com.nou.aut.AUTICFM, com.acer.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../../include/pages/checkUser.jsp" %>
<%@ include file="../../include/pages/query.jsp" %>
<%@ include file="../../include/pages/query1_2_0_2.jsp" %>
<%@page import="com.acer.db.*,com.nou.aut.*,java.util.Vector"%>
<%
	java.text.SimpleDateFormat dateTimeFormat = new java.text.SimpleDateFormat("yyyyMMdd");
	java.util.Calendar cal = java.util.Calendar.getInstance();

	
	String	ID_TYPE		=	(String)session.getAttribute("ID_TYPE");
	String	PRVLG_TP	=	(String)session.getAttribute("PRVLG_TP");
	String	ASYS	 	=	(String)session.getAttribute("ASYS");
	String 	USER_ID		=	(String)session.getAttribute("USER_ID");
	String	USER_IDNO 	=	(String)session.getAttribute("USER_IDNO");
	String	AYEAR		=	Utility.checkNull(request.getParameter("AYEAR"), "");
	String	SMS			= 	Utility.checkNull(request.getParameter("SMS"), "");		
	String 	today 		= 	dateTimeFormat.format(cal.getTime());
	
	
	boolean flag = false;
	VtResultSet	_rs	=	new VtResultSet(DBUtil.getSQLData("ccs029m_01v1.jsp", "NOU", "select ENROLL_AYEARSMS from STUT003 where stno = '" + session.getAttribute("USER_ID") + "' "));
	//於109上取消非當學年度入學不符合申請限制
	//if (_rs.next())
	//{
	//	String enroll_ayearsms = _rs.getString("ENROLL_AYEARSMS");
		
	//	if(!enroll_ayearsms.substring(0, 3).equals(AYEAR) && Integer.parseInt(enroll_ayearsms.substring(0, 3)) > 105) {
			
	//		out.println("<script>alert('"+enroll_ayearsms.substring(0, 3)+"學年度入學不符合校內學分採認申請資格，相關問題請洽詢所屬中心!');window.location = '../../home/home00/main.htm';</script>");
	//		flag = true;
	//		return;
	//	}
	//}	
	
	
	String 	sql	=	"SELECT a.AYEAR,a.SMS,  " +
					"case when '" + today + "' >= a.REPL_SDATE AND '" + today + "' <= a.REPL_EDATE then 'T' else 'F' end as STU_MK, "+
					"case when '" + today + "' >= a.CENTER_REPL_SDATE AND '" + today + "' <= a.CENTER_REPL_EDATE then 'T' else 'F' end as CENTER_MK "+
					"FROM CCST001 a " + 
					"WHERE 1 = 1 " + 
					"AND a.ASYS = '" + ASYS + "' " +
							"and a.ayear || A.SMS =  (SELECT MAX(B.AYEAR || B.SMS) FROM CCST001 B WHERE B.ASYS = A.ASYS) ";
	
	String STU_MK = "";
	String CENTER_MK = "";
	VtResultSet	rs	=	new VtResultSet(DBUtil.getSQLData("ccs010m_01v1.jsp", "NOU", sql));
	if (rs.next())
	{
		STU_MK = rs.getString("STU_MK");
		CENTER_MK = rs.getString("CENTER_MK");
	}	
	
	com.nou.aut.AUTGETRANGE getCheck = (com.nou.aut.AUTGETRANGE)session.getAttribute("AUTGETRANGE");
	String user_id=(String)session.getAttribute("USER_ID");
	Vector checkVt=new Vector();	
	String check="0"; //檢查註記
	String dep_code="";
	String center_code = "";
	//檢查是不是課務組
	checkVt=getCheck.getDEP_CODE("3","3");
	for (int i = 0; i < checkVt.size(); i++){	
		dep_code=(String)checkVt.get(i);
		if(dep_code==null||dep_code.equals("513")){
			check="1";	
		}
		if(check.equals("1")){
			break;
		}
	}
	//檢查是不是中心
	if(!"1".equals(check)){
		checkVt=getCheck.getDEP_CODE("4","3");
		if(checkVt.size()>0){
			center_code=(String)checkVt.get(0);
			if("T".equals(CENTER_MK)){
				check = "1";
			}
		}
	}
	//檢查學生
	if(!"1".equals(check)){
		if("T".equals(STU_MK)){
			check = "1";
		}
	}
	//by poto	
	session.setAttribute("dep_code",dep_code);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>list</title>
    <script language="javascript">
<!--
	
		
	
	
	/** 初始設定頁面資訊 */
	var	printPage1	=	"/ccs/ccs101r/_01p1";	//列印頁面
	var	printPage2	=	"/ccs/ccs102r/_01p1";	//列印頁面
	var	editMode		=	"ADD";				//編輯模式, ADD - 新增, MOD - 修改
	var	lockColumnCount		=	-1;				//鎖定欄位數
	var	listShow		=	true;				//是否一進入顯示資料
	var	_privateMessageTime	=	-1;				//訊息顯示時間(不自訂為 -1)
	var	pageRangeSize		=	10;				//畫面一次顯示幾頁資料
	var	controlPage		=	"_01c2";	//控制頁面
	var	checkObj		=	new checkObj();			//核選元件
	var	queryObj		=	new queryObj();			//查詢元件
	var	importSelect		=	false;				//匯入選取欄位功能
	var	noPermissAry		=	new Array();			//沒有權限的陣列
	
	var	FLAG		=	"";
	
	/** 網頁初始化 */
	function page_init(loadTime)
	{
		if (loadTime != "second")
			page_init_start();
	
		
		/** 權限檢核 */
		securityCheck();
		
		/** === 初始欄位設定 === */
		/** 初始上層帶來的 Key 資料 */
		iniMasterKeyColumn();
	
		if ("<%=ID_TYPE%>" == "1")	
		{
			/** 初始查詢欄位 */
			Form.iniFormSet('QUERY', 'ASYS', 'M',  1, 'A', 'D', 1);
			Form.iniFormSet('QUERY', 'AYEAR', 'S', 3, 'N', 'M',  3, 'A', 'F', 3, 'R', 1);
			Form.iniFormSet('QUERY', 'SMS', 'M',  1, 'A', 'D', 1);
			Form.iniFormSet('QUERY', 'STNO', 'S', 10, 'N', 'M',  9, 'A', 'R', 1);
			Form.iniFormSet('QUERY', 'IDNO', 'S', 10, 'M',  10, 'A', 'I', 'R', 1);
			Form.iniFormSet('QUERY', 'APP_SEQ', 'S', 8, 'M', 8, 'A', 'EN');
	
			Form.setInput('QUERY', 'STNO', '<%=USER_ID%>');
			Form.setInput('QUERY', 'IDNO', '<%=USER_IDNO%>');
			
			Form.setInput('QUERY', 'ASYS', '<%=ASYS%>');
			Form.setInput('QUERY', 'AYEAR', '<%=AYEAR%>');
			Form.setInput('QUERY', 'SMS', '<%=SMS%>');

	
			FLAG = "1";
		}
		else
		{	
			/** 初始查詢欄位 */
			Form.iniFormSet('QUERY', 'ASYS', 'M',  1, 'A');
			Form.iniFormSet('QUERY', 'AYEAR', 'S', 3, 'N', 'M',  3, 'A', 'F', 3);
			Form.iniFormSet('QUERY', 'SMS', 'M',  1, 'A');
			Form.iniFormSet('QUERY', 'STNO', 'S', 10, 'N', 'M',  9, 'A');
			Form.iniFormSet('QUERY', 'IDNO', 'S', 10, 'M',  10, 'A', 'I', 'U');
			Form.iniFormSet('QUERY', 'APP_SEQ', 'S', 8, 'M', 8, 'A', 'EN');
		}
	
		/** === 設定檢核條件 === */
		/** 查詢欄位 */
		Form.iniFormSet('QUERY', 'ASYS', 'AA', 'chkForm', 'ASYS');
		Form.iniFormSet('QUERY', 'AYEAR', 'AA', 'chkForm', '學年');
		Form.iniFormSet('QUERY', 'SMS', 'AA', 'chkForm', '學期');
	
		/** ================ */
	
		if (loadTime != "second")
		{
			page_init_end();
			setDefault();
		}
	}
	
	/**
	初始化 Grid 內容
	@param	stat	呼叫狀態(init -> 網頁初始化)
	*/
	function iniGrid(stat)
	{
		var	gridObj	=	new Grid();
	
		iniGrid_start(gridObj)
	
		/** 設定表頭 */
		/*
		gridObj.heaherHTML.append
		(
			"<table id=\"RsultTable\" class='sortable' width=\"100%\" border=\"1\" cellpadding=\"2\" cellspacing=\"0\" bordercolor=\"#E6E6E6\" summary=\"排版用表格\">\
					<tr class=\"mtbGreenBg\">\
					<td width=20>&nbsp;</td>\
					<td width=20>&nbsp;</td>\
					<td width=20>&nbsp;</td>\
					<td resize='on' nowrap>序號</td>\
					<td resize='on' nowrap>身分證字號</td>\
					<td resize='on' nowrap>學號</td>\
					<td resize='on' nowrap>姓名</td>\
					<td resize='on' nowrap>學年期</td>\
					<td resize='on' nowrap>應繳金額</td>\
				</tr>"
		);
		*/
		gridObj.heaherHTML.append
		(
			"<tr class=listHeader align=center>\
					<td width=10>&nbsp;</td>\
					<td resize='on'>&nbsp;</td>\
					<td resize='on' nowrap>申請序號</td>\
					<td resize='on' nowrap>學號</td>\
					<td resize='on' nowrap>姓名</td>\
					<td resize='on' nowrap>學年期</td>\
					<td resize='on' nowrap>申請狀態</td>\
				</tr>"
		);
	
		if (stat == "init" && !listShow)
		{
			/** 初始化及不顯示資料只秀表頭 */
			document.getElementById("grid-scroll").innerHTML	=	gridObj.heaherHTML.toString().replace(/\t/g, "") + "</table>";
			Message.hideProcess();
		}
		else
		{
			//by poto		
			if(stat!=""&&stat!=null&&stat!="Y"){
				var	editAry	=	stat.split("|");
				for (i = 0; i < editAry.length; i += 2)
				{
					console.log(editAry[i]);
					try{Form.setInput("QUERY", editAry[i], editAry[i + 1])}catch(e){};
				}
			}
			/** 頁次區間同步 */
			Form.setInput ("QUERY", "pageSize",	Form.getInput("RESULT", "_scrollSize"));
			Form.setInput ("QUERY", "pageNo",	Form.getInput("RESULT", "_goToPage"));
	
			/** 處理連線取資料 */
			var	callBack	=	function (ajaxData)
			{
				if (ajaxData == null)
					return;
	
				/** 設定表身 */
				var	keyValue	=	"";
				var	editStr		=	"";
				var	delStr		=	"";
				var	editStr2		=	"";
				var	editStr3		=	"";
				var	exportBuff	=	new StringBuffer();
				//by poto 2008/3/3
				var kValue3 ="";
				var check_mk ="";
				var CONFIRM_MK_NAME = "";
				for (var i = 0; i < ajaxData.data.length; i++, gridObj.rowCount++)
				{
					keyValue	=	"ASYS|" + ajaxData.data[i].ASYS + "|AYEAR|" + ajaxData.data[i].AYEAR + "|SMS|" + ajaxData.data[i].SMS + "|STNO|" + ajaxData.data[i].STNO + "|APP_TYPE|" + ajaxData.data[i].APP_TYPE + "|APP_SEQ|" + ajaxData.data[i].APP_SEQ;
	
					/** 判斷權限 */
					if (chkSecure("DEL"))
						delStr	=	"onkeypress=\"doDelete('" + keyValue + "');\"onclick=\"doDelete('" + keyValue + "');\"><div class=list_btn><a href=\"javascript:void(0)\">&nbsp;&nbsp;&nbsp;&nbsp;刪&nbsp;&nbsp;&nbsp;&nbsp;</a></div>";
					else
						delStr	=	"><div class=list_btn_disable>&nbsp;&nbsp;&nbsp;&nbsp;刪&nbsp;&nbsp;&nbsp;&nbsp;</div>";
	
					kValue3	=	"STNO=" + ajaxData.data[i].STNO + 
								"&NAME=" + ajaxData.data[i].NAME + 
								"&CENTER_CODE=" + ajaxData.data[i].CENTER_CODE + 
								"&CENTER_NAME=" + ajaxData.data[i].CENTER_NAME +
								"&TEL=" + ajaxData.data[i].TEL + 
								"&APP_SEQ=" + ajaxData.data[i].APP_SEQ + 
								"&PAYABLE_AMT=" + ajaxData.data[i].PAYABLE_AMT + 
								"&CRRSADDR_ZIP=" + ajaxData.data[i].CRRSADDR_ZIP + 
								"&CRRSADDR=" + ajaxData.data[i].CRRSADDR +
								"&APP_TYPE=" + ajaxData.data[i].APP_TYPE +
								"&ASYS=" + ajaxData.data[i].ASYS +
								"&AYEAR=" + ajaxData.data[i].AYEAR +
								"&SMS=" + ajaxData.data[i].SMS +
								"&IDNO=" + ajaxData.data[i].IDNO +
								"&HEDU_TYPE=" + ajaxData.data[i].HEDU_TYPE +
								"&IS_CONFIRM=" + ajaxData.data[i].CONFIRM_MK;
	
					/**判斷是否在確認送出的狀太,是的話新增刪都要備份到異動檔 */
					if (ajaxData.data[i].CONFIRM_MK == "Y")
					{
						Form.setInput('RESULT', 'IS_CONFIRM', 'Y');
					}
					else
					{
						Form.setInput('RESULT', 'IS_CONFIRM', 'N');
					}
					//by poto
					if (ajaxData.data[i].CONFIRM_MK == "Y"){	
						if("<%=ID_TYPE%>" == "1"){
							
							Form.iniFormSet("QUERY", "ADD_BTN", "D", 1);
							//_i('QUERY','ADD_BTN').disabled = true;
							check_mk ="Y"
						}else{
							Form.iniFormSet("QUERY", "ADD_BTN", "D", 0);
							//_i('QUERY','ADD_BTN').disabled = false;
							check_mk ="N"
						}
						CONFIRM_MK_NAME ="<font color='red'>已送出</font>";
					}else{
						//_i('QUERY','ADD_BTN').disabled = false;
						Form.iniFormSet("QUERY", "ADD_BTN", "D", 0);
						check_mk ="N"
						CONFIRM_MK_NAME ="未送出";
					}	
											
					
					/**身份為學生且確認註記為Y,則不能編輯*/
					if (ajaxData.data[i].CONFIRM_MK != "Y" || "<%=ID_TYPE%>" != "1")
					{
						editStr2	=	"onkeypress=\"doEdit('" + kValue3 + "');\"onclick=\"doEdit('" + kValue3 + "');\"><div class=list_btn><a href=\"javascript:void(0)\">&nbsp;&nbsp;&nbsp;&nbsp;申請科目&nbsp;&nbsp;&nbsp;&nbsp;</a></div>";
					}
					else
					{
						editStr2	=	"onkeypress=\"doPrint('ccs101r','" + ajaxData.data[i].AYEAR + "','" + ajaxData.data[i].SMS + "','" + ajaxData.data[i].STNO + "','" + ajaxData.data[i].APP_SEQ + "');\"onclick=\"doPrint('ccs101r','" + ajaxData.data[i].AYEAR + "','" + ajaxData.data[i].SMS + "','" + ajaxData.data[i].STNO + "','" + ajaxData.data[i].APP_SEQ + "');\"><div class=list_btn><a href=\"javascript:void(0)\">&nbsp;&nbsp;&nbsp;&nbsp;列印申請表&nbsp;&nbsp;&nbsp;&nbsp;</a></div>";
						//editStr3	=	"onkeypress=\"doPrint('ccs102r', '" + ajaxData.data[i].AYEAR + "', '" + ajaxData.data[i].SMS + "', '" + ajaxData.data[i].STNO + "', '" + ajaxData.data[i].APP_SEQ + "');\"onclick=\"doPrint('ccs102r', '" + ajaxData.data[i].AYEAR + "', '" + ajaxData.data[i].SMS + "', '" + ajaxData.data[i].STNO + "', '" + ajaxData.data[i].APP_SEQ + "');\"><a href=\"javascript:void(0)\">列印學系申請表</a>";
					}					
					
					
					gridObj.gridHtml.append
					(
						"<tr class=\"listColor0" + ((gridObj.rowCount % 2) + 1) + "\" onmouseover='OMOver(this);' onmouseout='OMOut"+((gridObj.rowCount % 2) + 1)+"(this);'>\
							<td align=center><input type=checkbox name='chkBox' value=\"" + keyValue + "\"></td>\
							<td align=center " + editStr2 + "</td>\
							<td>" + ajaxData.data[i].APP_SEQ + "&nbsp;</td>\
							<td>" + ajaxData.data[i].STNO + "&nbsp;</td>\
							<td>" + ajaxData.data[i].NAME + "&nbsp;</td>\
							<td>" + ajaxData.data[i].AYEARSMS + "&nbsp;</td>\
							<td>" + CONFIRM_MK_NAME + "&nbsp;</td>\
						</tr>"
					);
	
					exportBuff.append
					(
						ajaxData.data[i].APP_SEQ + "," + 
						ajaxData.data[i].IDNO + "," + 
						ajaxData.data[i].STNO + "," + 
						ajaxData.data[i].NAME + "," + 
						ajaxData.data[i].AYEARSMS + "\r\n"
					);
				}
				gridObj.gridHtml.append ("<tr></tr>");
	
				/** 無符合資料 */
				if (ajaxData.data.length == 0){
					gridObj.gridHtml.append ("<tr><td colspan='15'><font color=red><b>　　　查無符合資料!!</b></font></td></tr>");
				}
				//by poto  stat =Y表示 是從確認送出過來的 不要再跳回編輯頁面了
				if(ajaxData.data.length == 1&&stat!="Y"&&check_mk!="Y"){
					iniGrid_end(ajaxData, gridObj, ajaxData.data.length, kValue3);//如果只有一筆資料 直接到修改頁面的寫法			
				}else{
					iniGrid_end(ajaxData, gridObj);
					top.viewFrame.location.href	=	'_02v1?ASYS=' + Form.getInput('QUERY','ASYS') + '&AYEAR=' + Form.getInput('QUERY','AYEAR') + '&SMS=' + Form.getInput('QUERY','SMS');
				}
			}
			sendFormData("QUERY", controlPage, "QUERY_MODE", callBack);
		}
	}
	
	/** 處理匯出動作 */
	function doExport(type)
	{
		var	header		=	"流水號, 身分證字號, 學號, 姓名, 學年, PAYABLE_AMT\r\n";
		
		/** 處理匯入功能 匯出種類, 標題, 一次幾筆, 程式名稱, 寬度, 高度 */
		processExport(type, header, 4, 'ccs010m', 500, 200);
	}
	
	/** 查詢功能時呼叫 */
	function doQuery()
	{
		doQuery_start();
	
		/** === 自定檢查 === */
		/** 資料檢核及設定, 當有錯誤處理方式為 Form.errAppend(Message) 累計錯誤訊息 */
		//if (Form.getInput("QUERY", "SYS_CD") == "")
		//	Form.errAppend("系統編號不可空白!!");
		/** ================ */
	
		return doQuery_end();
	}
	
	/** 新增功能時呼叫 */
	function doAdd()
	{
		/** 開啟新增 Frame */
		top.showView();
	
		/** 呼叫新增 */
		top.viewFrame.doAdd(Form.getInput('QUERY', 'CENTER_CODE'));
	}
	
	/** ============================= 欲修正程式放置區 ======================================= */
	/** 設定功能權限 */
	function securityCheck()
	{
		try
		{
			/** 查詢 */
			if (!<%=AUTICFM.securityCheck (session, "QRY")%>)
			{
				noPermissAry[noPermissAry.length]	=	"QRY";
				try{Form.iniFormSet("QUERY", "QUERY_BTN", "D", 1);}catch(ex){}
			}
			/** 新增 */
			if (!<%=AUTICFM.securityCheck (session, "ADD")%>)
			{
				noPermissAry[noPermissAry.length]	=	"ADD";
				editMode	=	"NONE";
				try{Form.iniFormSet("EDIT", "ADD_BTN", "D", 1);}catch(ex){}
			}
			/** 修改 */
			if (!<%=AUTICFM.securityCheck (session, "UPD")%>)
			{
				noPermissAry[noPermissAry.length]	=	"UPD";
			}
			/** 新增及修改 */
			if (!chkSecure("ADD") && !chkSecure("UPD"))
			{
				try{Form.iniFormSet("EDIT", "SAVE_BTN", "D", 1);}catch(ex){}
			}
			/** 刪除 */
			if (!<%=AUTICFM.securityCheck (session, "DEL")%>)
			{
				noPermissAry[noPermissAry.length]	=	"DEL";
				try{Form.iniFormSet("RESULT", "DEL_BTN", "D", 1);}catch(ex){}
			}
			/** 匯出 */
			if (!<%=AUTICFM.securityCheck (session, "EXP")%>)
			{
				noPermissAry[noPermissAry.length]	=	"EXP";
				try{Form.iniFormSet("RESULT", "EXPORT_BTN", "D", 1);}catch(ex){}
				try{Form.iniFormSet("QUERY", "EXPORT_ALL_BTN", "D", 1);}catch(ex){}
			}
			/** 列印 */
			if (!<%=AUTICFM.securityCheck (session, "PRT")%>)
			{
				noPermissAry[noPermissAry.length]	=	"PRT";
				try{Form.iniFormSet("RESULT", "PRT_BTN", "D", 1);}catch(ex){}
				try{Form.iniFormSet("QUERY", "PRT_ALL_BTN", "D", 1);}catch(ex){}
			}
		}
		catch (ex)
		{
		}
	}
	
	/** 檢查權限 - 有權限/無權限(true/false) */
	function chkSecure(secureType)
	{
		if (noPermissAry.toString().indexOf(secureType) != -1)
			return false;
		else
			return true
	}
	/** ====================================================================================== */
	function setDefault() {
		document.forms["QUERY"].QUERYBY[0].checked = true;
		setQUERYBY();
	}
	
	function setQUERYBY() 
	{
		if (FLAG != "1")
		{
			_i('QUERY','STNO').removeAttribute("chkForm");
			_i('QUERY','IDNO').removeAttribute("chkForm");
			_i('QUERY','APP_SEQ').removeAttribute("chkForm");
	
			Form.iniFormSet('QUERY', 'STNO', 'D', 1);	
			Form.iniFormSet('QUERY', 'IDNO', 'D', 1);
			Form.iniFormSet('QUERY', 'APP_SEQ', 'D', 1);
	
			Form.setInput('QUERY', 'STNO', '');	
			Form.setInput('QUERY', 'IDNO', '');
			Form.setInput('QUERY', 'APP_SEQ', '');
	
			if (document.forms["QUERY"].QUERYBY[0].checked) 
			{	
				Form.iniFormSet('QUERY', 'STNO', 'D', 0);			
				//Form.iniFormSet('QUERY', 'STNO', 'AA', 'chkForm', '學號');		
				Form.iniFormSet('QUERY', 'STNO', 'FC');
			} 
			else if (document.forms["QUERY"].QUERYBY[1].checked)
			{	
				Form.iniFormSet('QUERY', 'IDNO', 'D', 0);			
				Form.iniFormSet('QUERY', 'IDNO', 'AA', 'chkForm', '身份證字號');		
				Form.iniFormSet('QUERY', 'IDNO', 'FC');
			}
			//依申請序號
			else
			{
				Form.iniFormSet('QUERY', 'APP_SEQ', 'D', 0);
				Form.iniFormSet('QUERY', 'APP_SEQ', 'AA', 'chkForm', '申請序號');
				Form.iniFormSet('QUERY', 'APP_SEQ', 'FC');
			}
		}
		else
		{
			//依申請序號
			if (document.forms["QUERY"].QUERYBY[2].checked)
			{
				Form.iniFormSet('QUERY', 'APP_SEQ', 'D', 0);
				Form.iniFormSet('QUERY', 'APP_SEQ', 'AA', 'chkForm', '申請序號');
				Form.iniFormSet('QUERY', 'APP_SEQ', 'FC');
			}
			//非依申請序號
			else
			{
				_i('QUERY','APP_SEQ').removeAttribute("chkForm");
				Form.iniFormSet('QUERY', 'APP_SEQ', 'D', 1, 'V', '');
			}
		}
		
		Form.iniFormColor();
	}
	
	/** 初始上層帶來的 Key 資料 */
	function iniMasterKeyColumn()
	{
		/** 非 Detail 頁面不處理 */
		if (typeof(keyObj) == "undefined")
			return;
		/** 塞值 */
		for (keyName in keyObj)
		{
			try {Form.iniFormSet("QUERY", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
			try {Form.iniFormSet("EDIT", keyName, "V", keyObj[keyName], "R", 0);}catch(ex){};
		}
		Form.iniFormColor();
	}
	
	function toMoneyFormat(tmp)
	{  
	  		var   signa=0;  
	  		var   ll=tmp.length;  
	  		if (ll%3==1)
			{  
	  			tmp="00"+tmp;
	  			signa=2;  
			}  
			if(ll%3==2)
			{  
				tmp="0"+tmp;
				signa=1;  
			}  
	
			var   tt=(tmp.length)/3;
			var   mm=new   Array(); 
			for (var   i=0;i<tt;i++)
			{  
				mm[i]=tmp.substring(i*3,3+i*3);
			}
	   
			var   vv="";
			for(var   i=0;i<mm.length;i++)  
				vv+=mm[i]+",";
	   
	   		vv=vv.substring(signa,vv.length-1);
			return vv;
	} 
	
	function doEdit(kv)
	{
		Message.showProcess();
		top.viewFrame.location.href	=	'_03v1?' + encodeURI(kv);
		Message.hideProcess();	
	}
	
	/** 處理列印動作 */
	function doPrint1(printForm)
	{
		/** 取消 onsubmit 功能防止重複送出 */
		//event.returnValue	=	false;
	
		/** 開始處理 */
		Message.showProcess();
	
		/** 檢核設定欄位*/
		Form.startChkForm("PRINT");
	
		/** 減核錯誤處理 */
		if (!queryObj.valideMessage (Form))
			return;
	
		var	printWin	=	WindowUtil.openPrintWindow("", "Print");
	
		Form.doSubmit("PRINT", printPage1 + "?PRINTFORM=" + printForm, "post", "Print");	
	
		printWin.focus();
	
		/** 停止處理 */
		Message.hideProcess();
	}
	
	/** 處理列印動作 */
	function doPrint2(printForm)
	{
		/** 取消 onsubmit 功能防止重複送出 */
		//event.returnValue	=	false;
	
		/** 開始處理 */
		Message.showProcess();
	
		/** 檢核設定欄位*/
		Form.startChkForm("PRINT");
	
		/** 減核錯誤處理 */
		if (!queryObj.valideMessage (Form))
			return;
	
		var	printWin	=	WindowUtil.openPrintWindow("", "Print");
	
		Form.doSubmit("PRINT", printPage2 + "?PRINTFORM=" + printForm, "post", "Print");	
	
		printWin.focus();
	
		/** 停止處理 */
		Message.hideProcess();
	}
	
	function doPrint(KIND, AYEAR, SMS, STNO, APP_SEQ)
	{
		Form.setInput('PRINT', 'AYEAR', AYEAR);
		Form.setInput('PRINT', 'SMS', SMS);
		Form.setInput('PRINT', 'STNO', STNO);
		Form.setInput('PRINT', 'APP_SEQ', APP_SEQ);
	
		if (KIND == 'ccs101r')
		{
			doPrint1();
		}
		else if (KIND == 'ccs102r')
		{
			doPrint2();
		}
	}
	
	/**by poto 2008/1/28**/
	/** 查詢清除 */
	function doReset()
	{
		document.forms["QUERY"].reset();	
		document.forms["QUERY"].QUERYBY[0].checked = true;
		setQUERYBY();
		iniMasterKeyColumn();
	}
	/**by poto 2008/3/3**/
	/** Grid 處理結束 */
	function iniGrid_end(ajaxData, gridObj, rowCount, keyValue)
	{
		if (rowCount != null && _i("RESULT", "_goToPage").value ==  1 && rowCount == 1){		
			doEdit(keyValue);
		}	
			
		document.getElementById("grid-scroll").innerHTML	=	gridObj.heaherHTML.toString().replace(/\t/g, "") + gridObj.gridHtml.toString().replace(/\t/g, "");
	
		/** 設定 event */
		//Query.setGridEvent(gridObj.scrollSize);
	
		/** 初始化分頁字串 */
		iniPage(10, ajaxData.count);
	
		/** 初始化排序功能 */
		//try{SortTable.sortables_init();}catch(ex){}
		
		/** 停止處理 */
		Message.hideProcess();
	}
	
	function pageInit()	
	{		
		if ("<%=check%>" == "0")
		{
			alert("非開放申請學分抵免期間");
			window.location = '../../home/home00/main.htm';
		}
	}
-->
    </script>
</head>

<body onLoad="pageInit();">
<span id="lblFunc" class="title"></span>
<jsp:include page="../../include/pages/title.jsp" />

<div align="center">
<%
		//showMsg((String)request.getAttribute("message"), out);
%>
</div>

<!----------------------查詢條件區開始------------------------------------------------------>
<div id="panelSearch" style="width: 100%;">

<form name="QUERY" method="post"  id="QUERY">	
	<input type="hidden" name="control_type" value="QUERY_MODE" />
	<input type="hidden" name="pageNo" value="1" />
	<input type="hidden" id="pageSize" name="pageSize" value="<%=StringUtils.defaultString((String)request.getParameter("pageSize"), "10") %>" />
	
	<input type=hidden name="EXPORT_FILE_NAME">
	<input type=hidden name="EXPORT_COLUMN_FILTER">
	<input type=hidden name="ASYS">
	<input type=hidden name="CENTER_CODE" value = "<%=center_code%>" >
	
    <table class="boxSearch" cellSpacing="0" cellPadding="5" width="100%" align="center">
	
		<tr>
			<td align='right'>學年期<font color=red>＊</font>：</td>
			<td>
				<input type='text' name='AYEAR'>
				<select name='SMS' id='SMS'>
					<option value=''>請選擇</option>
					<script>Form.getSelectFromPhrase("CCS010M_01_SELECT", "KIND", "SMS");</script>
				</select>
			</td>
			<td align='right'>學號<font color=red>＊</font>：</td>
			<td>
			<input type=text name='STNO'>
			</td>
		</tr>
		<tr style="display:none">
		<td>
			<td align='right'>查詢方式<font color=red>＊</font>：</td>
			<td>
				<input type=radio name='QUERYBY' value="1" onclick=setQUERYBY()>依學號&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<BR>
				<input type=radio name='QUERYBY' value="2" onclick=setQUERYBY()>依身份證字號&nbsp;<input type=text name='IDNO'>
				<BR>
				<input type=radio name='QUERYBY' value="3" onclick=setQUERYBY()>依申請序號&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type=text name='APP_SEQ'>
			</td>
			<td align='right'>申請狀態：</td>
			<td>							
				<select name='CONFIRM_MK'>
					<option value=''>請選擇</option>
					<option value='Y'>已送出</option>
					<option value='N'>未送出</option>
				</select>
			</td>
		</tr>
		<tr>		
			<td colspan="4" align="right">
	        	<div class="btnarea">		 
	        		<!-- 從右到左 -->	       	        		
	        		<%=ButtonUtil.GetButton("javascript:void(0);", "doQuery();", "查  詢", false, false, true, "QUERY_BTN") %>
	        		<%=ButtonUtil.GetButton("javascript:void(0);", "doAdd();", "開始申請", false, false, true, "ADD_BTN") %>	  	        		       		       	       
		        </div>
	        </td>
		</tr>		
    </table>	
</form>

</div>


<!----------------------查詢條件區結束------------------------------------------------------>
<div><img src="../../images/searchline.jpg" width="196" height="1" /></div>
<div style='line-height:10px'>&nbsp;</div>


<!----------------------結果列表區開始------------------------------------------------------>
<div id="panelList" style="width: 100%;">

<form name="RESULT" method="post" id="RESULT">
	<input type="hidden" name="control_type" value="" />
	<input type=hidden keyColumn="Y" name="ASYS">
	<input type=hidden keyColumn="Y" name="AYEAR">
	<input type=hidden keyColumn="Y" name="SMS">
	<input type=hidden keyColumn="Y" name="STNO">
	<input type=hidden keyColumn="Y" name="APP_TYPE">
	<input type=hidden keyColumn="Y" name="APP_SEQ">
	<input type=hidden name="IS_CONFIRM">


    <table cellspacing="0" cellpadding="0" border="0" width="100%">
	<!--<tr>
		<td width="10">&nbsp;</td>
	    <td height="30">
		注意事項<br>說明文字
	    </td>
	</tr>-->
    </table>
    <table class="box1" cellSpacing="0" cellPadding="0" border="0" width="100%" align="center">
	<tr>
	    <td colspan="3">
		<!----------------------工具列------------------------------------------------------>
		<table cellSpacing="0" cellPadding="0" border="0" width="100%" align="center">
		    <tr height="30">
				<td>		
					<%=ButtonUtil.GetButton("javascript:void(0);", "Form.setCheckBox(1, 'RESULT');", "全    選", false, false, false, "SELALL_BTN") %>
					<%=ButtonUtil.GetButton("javascript:void(0);", "Form.setCheckBox(0, 'RESULT');", "全 不 選", false, false, false, "SELNONE_BTN") %>
					<%=ButtonUtil.GetButton("javascript:void(0);", "doDelete('multi');", "刪    除", false, false, false, "DEL_BTN") %>			    				   
				</td>
				<td align='right' valign='bottom'>
					<jsp:include page="../../include/pages/page.jsp" />					
				</td>
		    </tr>
		</table>
		<!----------------------結果列表------------------------------------------------------>
		<table class="box2" rules="all" id="grid-scroll" width="100%" align="center" />		    		
	    </td>
	</tr>
    </table>    
</form>

<form name="PRINT" method="post">
	<input type=hidden name="AYEAR">
	<input type=hidden name="SMS">
	<input type=hidden name="STNO">
	<input type=hidden name="APP_SEQ">
	<input type=hidden name="APP_TYPE" value="2">
</form>

</div>


</body>
</html>
<script>
    document.write ("<font color=\"white\">" + document.lastModified + "</font>");
    window.addEventListener("load", page_init);    
</script>
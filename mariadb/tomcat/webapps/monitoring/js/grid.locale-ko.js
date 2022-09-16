;(function($){
/**
 * jqGrid English Translation
 * Tony Tomov tony@trirand.com
 * http://trirand.com/blog/ 
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
**/
$.jgrid = $.jgrid || {};
$.extend($.jgrid,{
	defaults : {
		recordtext: "���� {0} - {1} / {2}",
		emptyrecords: "ǥ���� ���� �����ϴ�",
		loadtext: "��ȸ��...",
		pgtext : "������ {0} / {1}"
	},
	search : {
		caption: "�˻�...",
		Find: "ã��",
		Reset: "�ʱ�ȭ",
		odata : ['����', '���� �ʴ�', '�۴�', '�۰ų� ����','ũ��','ũ�ų� ����', '�� �����Ѵ�','�� �������� �ʴ´�','���� �ִ�','���� ���� �ʴ�','�� ������','�� ������ �ʴ´�','���� �����Ѵ�','���� �������� �ʴ´�'],
		groupOps: [	{ op: "AND", text: "����" },	{ op: "OR",  text: "����" }	],
		matchText: " ��ġ�ϴ�",
		rulesText: " �����ϴ�"
	},
	edit : {
		addCaption: "�� �߰�",
		editCaption: "�� ����",
		bSubmit: "����",
		bCancel: "���",
		bClose: "�ݱ�",
		saveData: "�ڷᰡ ����Ǿ����ϴ�! �����Ͻðڽ��ϱ�?",
		bYes : "��",
		bNo : "�ƴϿ�",
		bExit : "���",
		msg: {
			required:"�ʼ��׸��Դϴ�",
			number:"��ȿ�� ��ȣ�� �Է��� �ּ���",
			minValue:"�Է°��� ũ�ų� ���ƾ� �մϴ�",
			maxValue:"�Է°��� �۰ų� ���ƾ� �մϴ�",
			email: "��ȿ���� ���� �̸����ּ��Դϴ�",
			integer: "��ȿ�� ���ڸ� �Է��ϼ���",
			date: "��ȿ�� ��¥�� �Է��ϼ���",
			url: "�� ��ȿ���� ���� URL�Դϴ�. ����տ� �����ܾ �ʿ��մϴ�('http://' or 'https://')",
			nodefined : " �� ���ǵ��� �ʾҽ��ϴ�!",
			novalue : " ��ȯ���� �ʿ��մϴ�!",
			customarray : "��������� �Լ��� �迭�� ��ȯ�ؾ� �մϴ�!",
			customfcheck : "Custom function should be present in case of custom checking!"
			
		}
	},
	view : {
		caption: "�� ��ȸ",
		bClose: "�ݱ�"
	},
	del : {
		caption: "����",
		msg: "���õ� ���� �����Ͻðڽ��ϱ�?",
		bSubmit: "����",
		bCancel: "���"
	},
	nav : {
		edittext: "",
		edittitle: "���õ� �� ����",
		addtext:"",
		addtitle: "�� ����",
		deltext: "",
		deltitle: "���õ� �� ����",
		searchtext: "",
		searchtitle: "�� ã��",
		refreshtext: "",
		refreshtitle: "�׸��� ����",
		alertcap: "���",
		alerttext: "���� �����ϼ���",
		viewtext: "",
		viewtitle: "���õ� �� ��ȸ"
	},
	col : {
		caption: "���� �����ϼ���",
		bSubmit: "Ȯ��",
		bCancel: "���"
	},
	errors : {
		errcap : "����",
		nourl : "������ url�� �����ϴ�",
		norecords: "ó���� ���� �����ϴ�",
		model : "colNames�� ���̰� colModel�� ��ġ���� �ʽ��ϴ�!"
	},
	formatter : {
		integer : {thousandsSeparator: ",", defaultValue: '0'},
		number : {decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, defaultValue: '0.00'},
		currency : {decimalSeparator:".", thousandsSeparator: ",", decimalPlaces: 2, prefix: "", suffix:"", defaultValue: '0.00'},
		date : {
			dayNames:   [
				"Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat",
				"��", "��", "ȭ", "��", "��", "��", "��"
			],
			monthNames: [
				"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
				"1��", "2��", "3��", "4��", "5��", "6��", "7��", "8��", "9��", "10��", "11��", "12��"
			],
			AmPm : ["am","pm","AM","PM"],
			S: function (j) {return j < 11 || j > 13 ? ['st', 'nd', 'rd', 'th'][Math.min((j - 1) % 10, 3)] : 'th'},
			srcformat: 'Y-m-d',
			newformat: 'm-d-Y',
			masks : {
				ISO8601Long:"Y-m-d H:i:s",
				ISO8601Short:"Y-m-d",
				ShortDate: "Y/j/n",
				LongDate: "l, F d, Y",
				FullDateTime: "l, F d, Y g:i:s A",
				MonthDay: "F d",
				ShortTime: "g:i A",
				LongTime: "g:i:s A",
				SortableDateTime: "Y-m-d\\TH:i:s",
				UniversalSortableDateTime: "Y-m-d H:i:sO",
				YearMonth: "F, Y"
			},
			reformatAfterEdit : false
		},
		baseLinkUrl: '',
		showAction: '',
		target: '',
		checkbox : {disabled:true},
		idName : 'id'
	}
});
})(jQuery);

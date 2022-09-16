	function cfInitXChart(oXChart)
	{
		//먼저 기존의 Series들을 클리어 한다
//		CollectGarbage();
		oXChart.RemoveAllSeries();


//		oXChart.Canvas.BackColor =  oXChart.ToOLEColor("Green");


		//XChart의 보기,기울기등의 속성을 설정한다
//		oXChart.Aspect.View3D = true;
//		oXChart.Aspect.Chart3DPercent = 15;
//		oXChart.Aspect.Elevation = 30;
		oXChart.Aspect.Zoom = 120;

		//Xchart의 타이틀에 관련된 속성을 설정한다
		//주의 : XChart에는 Title속성이 없고 대신 Header속성이 존재한다 
		oXChart.Header.Alignment = 2;
		oXChart.Header.Text.Clear();
		oXChart.Header.Font.Size=8;
		oXChart.Header.Font.Name = "돋움";
		oXChart.Header.Font.Bold = true;
		oXChart.Header.Font.Color = oXChart.ToOLEColor("#D50064");

		// Footer
		oXChart.Footer.Text.Clear();
		oXChart.Footer.Alignment  = 1;
		oXChart.Footer.Font.Size = 8;
		oXChart.Footer.Font.Name = "돋움";
		oXChart.Footer.Font.Italic = false;
		oXChart.Footer.Font.Bold = true;
		oXChart.Footer.Font.Color=oXChart.ToOLEColor("#002499");

		//XChart의 판넬의 속성을 설정한다
		//XChart가 표시되는 전체영역의 바탕을 설정하는것이다
		oXChart.Panel.Color = oXChart.ToOLEColor("#F5F5F5,#000000");
		oXChart.Panel.BevelOuter = 0;
		oXChart.Panel.BorderStyle = 0;

		//XChart의 좌표축에 관련된 속성을 설정한다

		
		//툴팁(마우스를 Series위에 올렸을때 값을 보여 주기위한 설정	
		var Toolsidx = oXChart.Tools.Add(8);
		oXChart.Tools.Items(Toolsidx).asMarksTip.MouseAction = 0;
		oXChart.Tools.Items(Toolsidx).asMarksTip.Style = 4;
		oXChart.Tools.Items(Toolsidx).asMarksTip.Delay = 0;

		
		oXChart.Legend.Visible		= false;										// 범례

		oXChart.AutoRepaint			= true;										// 자동 재그리기
		
	}



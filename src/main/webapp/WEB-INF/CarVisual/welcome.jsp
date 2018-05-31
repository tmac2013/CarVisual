<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <link rel="stylesheet" type="text/css" href="css/default.css">
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=zVOjktctX9WDxQtM96W8KCMdYK7UgBek"></script>
    <title>Driverless Car Viusal System</title>
</head>
<body>
<div id="header">
    <h1>Driverless Car Viusal System</h1>
</div>

<div id="nav">
    London<br>
    Paris<br>
    Tokyo<br>
</div>

<div id="content">
    <div id="allmap"></div>

    <div id="video">video</div>

    <div id="status">status:Disconnecting</div>
</div>


</body>
</html>
<script src="js/jquery-1.11.2.min.js"></script>
<script src="https://unpkg.com/gcoord/dist/gcoord.js"></script>
<script type="text/javascript">
    $(document).ready(function(){
        $("#forward").click(
            function(){
                $.get("${pageContext.request.contextPath}/websocket/forward");
                //console.log("send forward!")
                });
    });

</script>
<script type="text/javascript">
    // 百度地图API功能
    var map = new BMap.Map("allmap");
    map.centerAndZoom(new BMap.Point(116.331398,39.897445),11);
    map.enableScrollWheelZoom(true);
    var myIcon = new BMap.Icon("image/car.png", new BMap.Size(30,30));

    var car_longitude="";
    var car_latitude="";
    var car_connect="Disconnecting";
    var car_marker;
    var car_point;


    //jquery实现AJAX
    function ink(){
        $.ajax({
            type:"post",
            async:true,
            cache:false,
            url:"${pageContext.request.contextPath}/welcome",
            data: "json",
            success:function(data){
                //document.getElementById("location").innerHTML=data.longitude+" "+data.latitude;
                if(data.connect!=car_connect){
                    car_connect=data.connect;
                    document.getElementById("status").innerHTML="status:"+data.connect;
                    if(data.connect=="Disconnecting"){
                        alert("Car is disconnecting!");
                    }
                }
                if (car_connect=="Connecting"){
                    if(data.longitude!=car_longitude||data.latitude!=car_latitude){
                        car_latitude=data.latitude;
                        car_longitude=data.longitude;
                        if (data.longitude==""||data.latitude==""||data.longitude=="nan"||data.latitude=="nan"){}
                        else{
                            var point = new BMap.Point(data.longitude,data.latitude);
                            var marker = new BMap.Marker(point);
                            var convertor = new BMap.Convertor();
                            var pointArr = [];
                            pointArr.push(point);
                            convertor.translate(pointArr, 1, 5, translateCallback);//坐标转换
                        };

                    }
                }else{
                    map.clearOverlays();
                }

            }
        });//坐标更新
    }
    $(function(){setInterval("ink()",1000);});

    translateCallback = function (data){
        if(data.status === 0) {
            map.removeOverlay(car_marker);
            car_marker = new BMap.Marker(data.points[0],{icon:myIcon});
            map.centerAndZoom(data.points[0],19);
            map.addOverlay(car_marker);
            if (car_point!=null){
                var polyline = new BMap.Polyline([
                    car_point,
                    data.points[0],
                ], {strokeColor:"blue", strokeWeight:2, strokeOpacity:0.5});
                map.addOverlay(polyline)
            }
            car_point=data.points[0];
        }
    }//坐标转换回调函数

    function showInfo(e){
        if (car_connect=="Connecting"){
            car_marker = new BMap.Marker(e.point);  // 创建标注
            map.addOverlay(car_marker);
            var result = gcoord.transform(
                [e.point.lng, e.point.lat ],    // 经纬度坐标
                gcoord.BD09,                 // 当前坐标系
                gcoord.WGS84                   // 目标坐标系
            );
            var pointconvertor = result.toString().split(",");
            $.get("${pageContext.request.contextPath}/websocket/destination?"+"longitude="+pointconvertor[0]+"&latitude="+pointconvertor[1]);
            setTimeout("$.get(\"${pageContext.request.contextPath}/websocket/check\")",30000)
        }else {
            alert("Car is disconnecting!")
        }

    }
    map.addEventListener("click", showInfo);

</script>

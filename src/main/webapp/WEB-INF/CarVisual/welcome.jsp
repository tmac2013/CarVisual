<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <style type="text/css">
        body, html{width: 100%;height: 100%;margin:0;font-family:"微软雅黑";}
        #allmap{height:500px;width:100%;}
        #r-result{width:100%; font-size:14px;}
    </style>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=zVOjktctX9WDxQtM96W8KCMdYK7UgBek"></script>
    <title>Location</title>
</head>
<body>
<div id="allmap"></div>
<div id="parameters" style="height:300px">
    <div id="status" style=" height: 300px; width:300px;float:left">status:Disconnecting</div>
    <div id="control" style=" height: 300px; width:300px;float:left">
        <button id="forward">forward</button>
    </div>
</div>
</body>
</html>
<script src="js/jquery-1.11.2.min.js"></script>
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

    var car_longitude="";
    var car_latitude="";
    var car_connect="Disconnecting";
    var car_marker;

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
                if(data.longitude!=car_longitude||data.latitude!=car_latitude){
                    car_latitude=data.latitude;
                    car_longitude=data.longitude;
                    var point = new BMap.Point(data.longitude,data.latitude);
                    var marker = new BMap.Marker(point);

                    var convertor = new BMap.Convertor();
                    var pointArr = [];
                    pointArr.push(point);
                    convertor.translate(pointArr, 1, 5, translateCallback);//坐标转换
                }

                if(data.connect!=car_connect){
                    car_connect=data.connect;
                    document.getElementById("status").innerHTML="status:"+data.connect;
                }
            }
        });//坐标更新
    }
    $(function(){setInterval("ink()",1000);});

    translateCallback = function (data){
        if(data.status === 0) {
            map.removeOverlay(car_marker);
            car_marker = new BMap.Marker(data.points[0]);
            map.centerAndZoom(data.points[0],18);
            map.addOverlay(car_marker);
        }
    }//坐标转换回调函数

    function showInfo(e){
        car_marker = new BMap.Marker(e.point);  // 创建标注
        map.addOverlay(car_marker);
        $.get("${pageContext.request.contextPath}/websocket/destination?"+"longitude="+e.point.lng+"&latitude="+e.point.lat);
    }
    map.addEventListener("click", showInfo);

</script>

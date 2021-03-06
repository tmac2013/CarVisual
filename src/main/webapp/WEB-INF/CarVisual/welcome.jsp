<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="css/default.css">
    <script src="js/jquery-1.11.2.min.js"></script>
    <script src="https://unpkg.com/gcoord/dist/gcoord.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=zVOjktctX9WDxQtM96W8KCMdYK7UgBek"></script>
    <title>Driverless Car Viusal System</title>
</head>
<body >
<div class="container" style="width: 100%;height: 100%;background-image: url(image/back1.jpg);  background-repeat: no-repeat;background-size: 100% 100%;  ">
    <div class="row clearfix"  >
        <div class="col-md-12 column" style="background-image: url(image/back.jpg);  background-repeat: no-repeat;background-size: 100% 100%;  ">
            <div class="page-header" id="title"  >
                <h1 style="color: aliceblue">
                    Driverless Car Visual System <small>无人车巡检可视化系统</small>
                </h1>
            </div>
        </div>
    </div>
    <div class="row clearfix">
        <div class="col-md-3 column">
            <h3>
                路径生成模块
            </h3>
            <p>
                选择“选取坐标点”按钮，鼠标在图上点击以选取目标路径点。<br>
                选择“生成路径”按钮，生成巡检路径。
            </p>
            <button type="button" id="selectgps"  onclick="selectgps()" class="btn btn-default btn-primary btn-block">选取坐标点</button>
            <button type="button" id="newroute" onclick="newroute()" class="btn btn-default btn-block btn-primary">生成路径</button>
        </div>
        <div class="col-md-6 column" id="allmap">
        </div>
        <div class="col-md-3 column">
            <div class="row clearfix">
                <div class="col-md-12 column" id="video">video
                </div>
            </div>
            <div class="row clearfix">
                <div class="col-md-12 column" id="status"><h3>status：Disconnecting</h3>
                </div>
            </div>
            <div class="row clearfix">
                <div class="col-md-12 column" id="longitude"><h3>longitude：</h3>
                </div>
            </div>
            <div class="row clearfix">
                <div class="col-md-12 column" id="latitude"><h3>latitude：</h3>
                </div>
            </div>
        </div>
    </div>
    <div class="row clearfix">
        <div class="col-md-12 column">
            <br>
            <div class="alert alert-success alert-dismissable" id="alert">
                <h4>
                    Welcome to Driverless Car Visual System!
                </h4>
                <strong>欢迎进入无人车巡检可视化系统！</strong>
            </div>
        </div>
    </div>
</div>
</body>
</html>
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
    var route_marker;
    var route_points=[];
    var driving = new BMap.WalkingRoute(map, {renderOptions:{map: map, autoViewport: true},
        onPolylinesSet:function(routes) {
            searchRoute = routes[0].getPolyline();//导航路线
            map.removeOverlay(searchRoute);
        },
        onMarkersSet:function(routes) {
            map.removeOverlay(routes[0].marker); //删除起点
            map.removeOverlay(routes[1].marker);//删除终点
        }
    });
    //jquery实现AJAX;
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
                    if(data.connect=="Disconnecting"){
                        document.getElementById("alert").innerHTML="<h4>Driverless car is disconnecting! </h4> <strong>无人车连接已断开！</strong>"
                        $.post("${pageContext.request.contextPath}/car",{longitude:"",latitude:""})
                        document.getElementById("longitude").innerHTML="<h3>longitude:</h3>";
                        document.getElementById("latitude").innerHTML="<h3>latitude:</h3>";
                    }else{
                        document.getElementById("alert").innerHTML="<h4>Driverless car is successfully connecting! </h4> <strong>无人车已成功连接！</strong>"
                    }
                }
                if (car_connect=="Connecting"){
                    if(data.longitude!=car_longitude||data.latitude!=car_latitude){
                        car_latitude=data.latitude;
                        car_longitude=data.longitude;
                        if (data.longitude==""||data.latitude==""||data.longitude=="nan"||data.latitude=="nan"){
                        }
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
                    car_longitude="";
                    car_latitude="";
                    map.clearOverlays();
                }
                document.getElementById("status").innerHTML="<h3>status:"+car_connect+"</h3>";
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
            document.getElementById("longitude").innerHTML="<h3>longitude:"+data.points[0].lng+"</h3>";
            document.getElementById("latitude").innerHTML="<h3>latitude:"+data.points[0].lat+"</h3>";
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
            route_points.push(e.point)
            route_marker = new BMap.Marker(e.point);// 创建标注
            map.addOverlay(route_marker);
            var result = gcoord.transform(
                [e.point.lng, e.point.lat ],    // 经纬度坐标
                gcoord.BD09,                 // 当前坐标系
                gcoord.WGS84                   // 目标坐标系
            );
            var pointconvertor = result.toString().split(",");
            $.get("${pageContext.request.contextPath}/websocket/destination?"+"longitude="+pointconvertor[0]+"&latitude="+pointconvertor[1]);
            setTimeout("$.get(\"${pageContext.request.contextPath}/websocket/check\")",30000)
        }else {
            document.getElementById("alert").innerHTML="<h4>Warnning:Driverless car is disconnecting! </h4> <strong>警告：无人车未连接！</strong>"
        }

    }
    //map.addEventListener("click", showInfo);

    // $(document).ready(function(){
    //     $("#selectgps").click(
    //         function(){
    //             map.addEventListener("click", showInfo);
    //         });
    // });
    function selectgps(){
        driving.clearResults();
        map.clearOverlays();
        map.addOverlay(car_marker);
        route_points=[];
        if (car_longitude==""||car_latitude==""||car_longitude=="nan"||car_latitude=="nan"){
            document.getElementById("alert").innerHTML="<h4>No GPS location information! </h4> <strong>警告：未获取无人车GPS定位信息！</strong>"
        }
        else{
            map.addEventListener("click", showInfo);
        }
    }
    function newroute() {
        var length  = route_points.length;
        if(length==0){
            document.getElementById("alert").innerHTML="<h4>No points selected! </h4> <strong>警告：坐标点未选取！</strong>"
        }else{
            document.getElementById("alert").innerHTML="<h4>Route has been created! </h4> <strong>路径已生成！</strong>"
            for(var i=0;i<length;i++){
                if (i==0){
                    driving.search(car_point, route_points[i]);
                }else{
                    driving.search(route_points[i-1],route_points[i]);
                }
            }
            driving.setSearchCompleteCallback(function () {
                var pts = driving.getResults().getPlan(0).getRoute(0).getPath();    //通过步行实例，获得一系列点的数组
                var polyline = new BMap.Polyline(pts,{strokeColor:"red"});
                map.addOverlay(polyline);
            }
            )
            var des_icon=new BMap.Icon("image/destination.png", new BMap.Size(30,30));
            route_marker.setIcon(des_icon);
            map.removeEventListener("click", showInfo);
            // var destination_point = route_points[length-1];
            // var way_points=route_points.slice(0,length-1);
            // driving.search(car_point, route_points[i]);
        }
    }

</script>

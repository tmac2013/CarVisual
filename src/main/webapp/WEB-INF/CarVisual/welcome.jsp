<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<div id="location">
</div>
</body>
</html>
<script src="js/jquery-1.11.2.min.js"></script>
<script type="text/javascript">
    // 百度地图API功能
    var map = new BMap.Map("allmap");
    map.centerAndZoom(new BMap.Point(116.331398,39.897445),11);
    map.enableScrollWheelZoom(true);

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
                if(data.longitude!=""&&data.latitude!=""){
                    var point = new BMap.Point(data.longitude,data.latitude);
                    var marker = new BMap.Marker(point);

                    var convertor = new BMap.Convertor();
                    var pointArr = [];
                    pointArr.push(point);
                    convertor.translate(pointArr, 1, 5, translateCallback);
                }



            }
        });

    }
    $(function(){setInterval("ink()",1000);});


    translateCallback = function (data){
        if(data.status === 0) {
            var new_marker = new BMap.Marker(data.points[0]);
            map.centerAndZoom(data.points[0],18);
            map.clearOverlays();
            map.addOverlay(new_marker);
        }
    }


</script>

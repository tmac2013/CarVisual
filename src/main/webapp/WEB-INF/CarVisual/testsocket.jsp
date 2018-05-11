<%--
  Created by IntelliJ IDEA.
  User: WSPN
  Date: 2018/5/11
  Time: 10:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

</body>
</html>
<script>
    var ws = new WebSocket('ws://10.108.145.238:8080/websocket/socketServer.do');

    ws.onopen = function(evt) {
        console.log("Connection open ...");
        ws.send("Hello WebSockets!");
    };

    ws.onmessage = function(evt) {
        console.log( "Received Message: " + evt.data);
        ws.close();
    };

    ws.onclose = function(evt) {
        console.log("Connection closed.");
    };
</script>
<!doctype html>
<head>
    <meta charset="utf-8" />
    <title>WebSocket Connection Testing</title>

    <style>
        li { list-style: none; }
    </style>

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            if (!window.WebSocket) {
                if (window.MozWebSocket) {
                    window.WebSocket = window.MozWebSocket;
                } else {
                    $('#messages').append("<li>Your browser doesn't support WebSockets.</li>");
                }
            }
            ws = new WebSocket('ws://192.168.43.69:8080/websocket');
            ws.onopen = function(evt) {
                $('#messages').append('<li>Connected to server</li>');
            }
            ws.onmessage = function(evt) {
                $('#messages').append('<li>' + evt.data + '</li>');
            }
            $('#send-message').submit(function() {
                ws.send($('#name').val() + ": " + $('#message').val());
                $('#message').val('').focus();
                return false;
            });
        });
    </script>
</head>
<body>
    <h2>WebSocket Connection Testing</h2>
   

    <div id="messages"></div>
</body>
</html>
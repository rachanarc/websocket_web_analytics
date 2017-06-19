<!doctype html>
<head>
    <meta charset="utf-8" />
    <title>WebSocket Connection Admin</title>

    <style>
        li { list-style: none; }
    </style>

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
    <script>
        $(document).ready(function() {
            $("#getCount").click();

            if (!window.WebSocket) {
                if (window.MozWebSocket) {
                    window.WebSocket = window.MozWebSocket;
                } else {
                    $('#messages').append("<li>Your browser doesn't support WebSockets.</li>");
                }
            }
            ws = new WebSocket('ws://localhost:8080/ws_admin');

            ws.onopen = function(evt) {
                $('#messages').append('<li>Connected to server</li>');
                
                ws.send('Hello');
            }

            ws.onmessage = function(evt) {
                console.log('Count : ' + evt.data);
                $('#count').text(evt.data);
            }

            $('#getCount').click(function(){
                console.log('click');
                ws.send('Hello');
            })

            
        });
    </script>
</head>
<body>
    <h2>WebSocket Connection Admin</h2>
   
    <h3>Online Devices : <span id="count"></span></h3>
    <br>
    <button id="getCount">Get Count</button>

</body>
</html>
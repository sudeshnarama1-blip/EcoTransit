<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="#051F20">
    <link rel="manifest" href="manifest.json">
    <link rel="icon" type="image/png" href="icons/icon-192.png">
    <link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-title" content="EcoTransit">
    <title>Green Mobility</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body>

    <div class="container">

    <div class="card login-card">

        <h1>EcoTransit</h1>

        <h2>Student Login</h2>

        <p>Enter your details to continue.</p>

        <form action="login.jsp" method="post">

            <label>Enter your name:</label>
            <br>
            <input type="text" name="name" required>

            <br><br>

            <label>Enter your email:</label>
            <br>
            <input type="email" name="email" required>

            <br><br>

            <button type="submit">Continue</button>

        </form>

    </div>

</div>

<script>
    if ("serviceWorker" in navigator) {
        window.addEventListener("load", function () {
            navigator.serviceWorker.register("sw.js");
        });
    }
</script>
</body>
</html>
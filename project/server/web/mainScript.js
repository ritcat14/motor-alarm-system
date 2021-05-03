const API_KEY = "&key=AIzaSyCh1UK0LA-So2r0dKkvXxX3wa68zP95yGQ";
const WEB_ADDR = "https://www.google.com/maps/embed/v1/place?q=";

class CircleChart {

    constructor(ID, radius, maxValue, barColor, backgroundColor, textSymbol, textColor, label) {
        this.id = ID;
        this.radius = radius;
        this.maxValue = maxValue;
        this.barColor = barColor;
        this.backgroundColor = backgroundColor;
        this.textSymbol = textSymbol;
        this.textColor = textColor;
        this.label = label;
        this.lineWidth = radius/6;
        this.createCanvas();
    }

    createCanvas() {
        this.canvas = document.createElement("canvas");
        this.canvas.id = "stats-canvas" + this.id;
        this.canvas.width = 200;
        this.canvas.height = 200;
        this.canvas.style.position = "absolute";
        this.canvas.style.top = "50px";
        this.canvas.style.left = 30 + (this.id * 225) + "px";
        this.canvas.style.zIndex = '1';
        stats.appendChild(this.canvas);
    }

    draw(value) {
        this.canvas = document.getElementById("stats-canvas" + this.id);
        const context = this.canvas.getContext("2d");

        context.clearRect(0, 0, this.radius*2, this.radius*2);

        const startAngle = 3 * (Math.PI / 4);
        const endAngle = (2 * Math.PI) + (Math.PI/4);
        const angleScale = (2 * Math.PI) - (Math.PI/2);

        const greenAngle = (2 * Math.PI) - (Math.PI/2);
        const orangeAngle = 1.95 * Math.PI;
        const redAngle = endAngle;

        let angle = (angleScale / this.maxValue) * value;
        const valueAngle = endAngle - (angleScale - angle);

        //
        context.lineWidth = 5;
        const outer_radius = this.radius + (this.lineWidth/2) + 5;
        context.beginPath();
        context.strokeStyle = 'green';
        context.arc(this.x, this.y, outer_radius, startAngle, greenAngle)
        context.stroke();

        context.beginPath();
        context.strokeStyle = 'orange';
        context.arc(this.x, this.y, outer_radius, greenAngle, orangeAngle);
        context.stroke();

        context.beginPath();
        context.strokeStyle = 'red';
        context.arc(this.x, this.y, outer_radius, orangeAngle, redAngle);
        context.stroke();

        //
        context.beginPath();
        context.strokeStyle = this.backgroundColor;
        context.lineWidth = this.lineWidth;
        context.arc(this.x, this.y, this.radius, startAngle, endAngle);
        context.stroke();

        context.beginPath();
        context.strokeStyle = this.barColor;
        context.arc(this.x, this.y, this.radius, startAngle, valueAngle);
        context.stroke();

        context.textAlign = 'center';
        context.fillStyle = this.textColor;
        context.font = (this.radius/2) + 'px Courier New';
        context.fillText(value, this.x, this.y);

        context.font = '10px Courier New';
        context.fillText(this.textSymbol, this.x, this.y + (this.radius/4));

        context.font = 'bold 18px Courier New';
        context.fillStyle = 'darkgreen';
        if (valueAngle > orangeAngle) context.fillStyle = '#b22222';
        if (valueAngle > greenAngle && valueAngle < orangeAngle) context.strokeStyle = 'orange';
        context.fillText(this.label, this.x, this.y + 75);
    }

    get x() {
        return this.width / 2;
    }

    get y() {
        return this.height / 2;
    }

    get width() {
        return this.canvas.width;
    }

    get height() {
        return this.canvas.height;
    }

}

// x, y, radius, startValue, maxValue, barColor, textSymbol, textColor
var circleCharts = [];

let stats;
let map;
let camera;
let currentContent;
let http_exchange = create_http_exchange();
let cameraState = false;

function attempt_request() {
    check_response(http_exchange);

    send_request(http_exchange, "GET", "data", "test");
}

function check_response(http_exchange) {
    http_exchange.onreadystatechange = function() {
        if (http_exchange.readyState === 4 && http_exchange.status === 200) {
            process_response(http_exchange.responseText);
        }
    }
}

function process_response(http_response_text) {
    const parts = http_response_text.split("\n");

    let longitude;
    let latitude;
    let temp1, temp2, speed;

    let i;
    for (i = 0; i < parts.length; i++) {
        const currentData = parts[i].split(":");
        if (currentData[0] === "long") longitude = currentData[1];
        else if (currentData[0] === "lat") latitude = currentData[1];
        else if (currentData[0] === "temp1") temp1 = currentData[1];
        else if (currentData[0] === "temp2") temp2 = currentData[1];
        else if (currentData[0] === "speed") speed = currentData[1];
    }

    update_map(latitude, longitude);
    update_stats(temp1, temp2, speed, longitude, latitude);

}

function update_map(long, lat) {
    if (currentContent === map)
        document.getElementById("mapFrame").src = WEB_ADDR + long + "," + lat + API_KEY;
}

function update_stats(temp1, temp2, speed, longitude, latitude) {
    if (currentContent === stats) {
        document.getElementById("latitude").innerHTML = "Latitude: " + latitude;
        document.getElementById("longitude").innerHTML = "Longitude:" + longitude;

        circleCharts[0].draw(getRandomValue(0, 100));

        circleCharts[1].draw(getRandomValue(0, 100));

        circleCharts[2].draw(getRandomValue(0, 100));

        console.log("SPEED:" + speed);
        console.log("TEMP1:" + temp1);
        console.log("TEMP2:" + temp2);
        console.log("Latitude:" + latitude);
        console.log("Longitude:" + longitude);
    }
}

function getRandomValue(min, max) {
    return Math.floor(Math.random() * max) + min;
}

function statsClicked() {
    console.log("stats clicked");
    setContent(stats);
}

function trackClicked() {
    console.log("track clicked");
    setContent(map);
}

function cameraClicked() {
    console.log("camera clicked");
    camera.innerHTML =
        "<button id=\"cameratoggle\" class=\"navBar cameratoggle loginbutton\" style=\"position: fixed; background-image: url(images/camera_off-button.png);\"></button>" +
        "<img class='video_source' alt=\"Video source not available!\" src=\"http://10.0.0.3:8080/?action=stream\">";
    setContent(camera);
    document.getElementById("cameratoggle").onclick = cameraToggle;
}

function cameraToggle() {
    if (!cameraState) {
        document.getElementById("cameratoggle").style.backgroundImage = "url(images/camera_on-button.png)";
        send_request(http_exchange, "POST", "camera", "on");
        cameraState = true;
    } else {
        document.getElementById("cameratoggle").style.backgroundImage = "url(images/camera_off-button.png)";
        send_request(http_exchange, "POST", "camera", "off");
        cameraState = false;
    }
}

function logout() {
    console.log("Logout clicked!");
    document.location = "http://betawars.ddns.net:8500/web/index.html";
}

function init() {
    stats = document.createElement("div");
    stats.id = "stats";
    stats.class = "stats";

    let fields = ["longitude", "latitude"];
    let i;
    for (i = 0; i < fields.length; i++) {
        const element = document.createElement("p");
        element.id = fields[i];
        stats.appendChild(element);
    }

    const labels = ['TEMP1', 'TEMP2', 'SPEED'];
    const units = ['°C', '°F', 'MPH'];

    for (i = 0; i < 3; i++) {
        circleCharts[i] = new CircleChart(i, 80, 100, '#92DD86', '#8ABDEC',
            units[i], 'white', labels[i]);
    }

    camera = document.createElement("div");
    camera.class = "camera";

    map = document.createElement("div");
    map.class = "track";
    map.innerHTML =
        "<iframe id='mapFrame' src=\"https://www.google.com/maps/embed/v1/place?q=0,0&key=AIzaSyCh1UK0LA-So2r0dKkvXxX3wa68zP95yGQ\"" +
            "style='width: 100%; height: 100%;' frameBorder='0' allowFullScreen='' aria-hidden='false tabIndex='0'></iframe>";

    document.getElementById("button1").onclick = statsClicked;
    document.getElementById("button2").onclick = trackClicked;
    document.getElementById("button3").onclick = cameraClicked;
    document.getElementById("button4").onclick = logout;

    setContent(stats);
}

function setContent(content) {
    currentContent = content;
    document.getElementById("main-content").innerHTML = ""; // wipe current content
    document.getElementById("main-content").appendChild(content); // Add provided content to main-content pane
}

init();

attempt_request();
setInterval(attempt_request, 3000);


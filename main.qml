import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

Window {
    id: root
    visible: true
    width: 640
    height: 480
    title: "MSFT Stock Price"

    property string downloadstate: ""

    ListModel {
        id: lm
    }

    ListView {
        id: lv
        width: parent.width; height: 200

        model: lm
        delegate: Rectangle {
            Text {
                text: "Date: " + date + "    Open: " + open + "    High:" + high + "    Low: " + low + "    Close " + close + "    Volume:" + volume
            }
            width: parent.width
            height: childrenRect.height
            color: (index % 2) ? "#eeeeff" : "white";
        }
    }

    function httpCallback(request) {
        console.log("readstate == " + request.readyState);


        if (request.readyState === XMLHttpRequest.DONE && request.status === 200) {
            lm.clear();
            var responseText = request.responseText;


            // schema:
            /*
            {
                "Meta Data": {
                    ...
                },
                "Time Series (Daily)": {
                    "2018-06-15": {
                        "1. open": "101.5100",
                        "2. high": "101.5300",
                        "3. low": "100.0700",
                        "4. close": "100.1300",
                        "5. volume": "65649135"
                    },
                    "2018-06-14": {
                        "1. open": "101.6500",
                        "2. high": "102.0300",
                        "3. low": "101.0000",
                        "4. close": "101.4200",
                        "5. volume": "25691811"
                    },
                    ...
            }
            */

            var obj = JSON.parse(responseText);
            var timeseries = obj["Time Series (Daily)"];
            var count = 0;

            for (var k in timeseries) {
                var col = (count % 2) ? "#eeeeff" : "white";
                var date = k;
                var dataobject = {};
                var entry =  timeseries[k];
                dataobject.date = k;
                dataobject.open = entry["1. open"];
                dataobject.high = entry["2. high"];
                dataobject.low = entry["3. low"];
                dataobject.close = entry["4. close"];
                dataobject.volume = entry["5. volume"];
                dataobject.index = count;
                count++;

                lm.append(dataobject);
            }

            root.downloadstate = "Download complete";

        }
        else if (request.readyState === XMLHttpRequest.DONE) {
            console.log("error downloading.  status==" + request.status);
            root.downloadstate = "Error: " + request.status;
        }
    }


    Button {
        id: btn
        anchors.top: lv.bottom
        anchors.topMargin: 20
        width: 50
        height: 20
        text: "click me"
        onClicked: function () {
            var request = new XMLHttpRequest();
            request.open("GET", "http://www.selbie.com/json/fakedata.json", true);
            request.onreadystatechange = function() {
                httpCallback(request);
            }
            root.downloadstate = "Downloading...";
            request.send()
        }
    }

    Text {
        id: statustext
        anchors.top: btn.bottom
        text: root.downloadstate
    }


}

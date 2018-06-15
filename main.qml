import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    function updateFromJson(response) {
        var obj = JSON.parse(response);
        var s = "";

        for (var i in obj) {
            s += obj[i].body + "\n";
        }

        txt.text = s;
    }

    Text {
        id: txt
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 240
        text: "loading..."
    }


    Button {
        text: "Click me"
        height: 30
        width: 100
        anchors.left: parent.left
        anchors.top: txt.bottom
        onClicked: function() {
            var request = new XMLHttpRequest();
            request.open("GET", "http://jsonplaceholder.typicode.com/posts/1/comments", true);
            request.onreadystatechange = function() {
                if (request.readyState === 4 && request.status === 200) {
                    txt.text = request.responseText;
                    updateFromJson(request.responseText);
                }
                else if (request.readyState == 4) {
                    text.text = request.status.toString() + " : "  + request.responseText;
                }
                else {
                    txt.text = request.readyState.toString() + " : " + request.responseText;
                }
            }

            request.send()
        }
    }



}

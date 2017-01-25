import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.LocalStorage 2.0
import "DataBaseOpts.js" as SqlDb

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Dubist")

    property string identifier: "Dubist"
    property string version: "Dubist"
    property string description: "Simple tasks list app!"

    header: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: qsTr("Todo")
        }
        TabButton {
            text: qsTr("Done")
        }
    }

    Component.onCompleted: {
        SqlDb.Sql=LocalStorage;

        SqlDb.createDataBase();

        var rows=SqlDb.getTasksTodo();

        for(var i = 0; i < rows.length; i++) {
            lvItems.model.append({
                                     id:  rows.item(i).id,
                                     title: rows.item(i).title,
                                     description: rows.item(i).description,
                                     isDone: rows.item(i).description
                                 });
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Page{

            ListView{
                id: lvItems
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: txtNewTask.top
                model: ListModel{}
                clip: true
                delegate: Item{
                    height: 50
                    width: parent.width

                    Text {
                        text: title + ": " + description
                    }

                    Image{
                        //TODO: Icon should be changed
                        id: imgRemove
                        source: "res/delete.svg"
                        anchors.top: parent.top
                        anchors.right: btnDone.left
                        anchors.bottom: parent.bottom
                        width: 50

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                SqlDb.removeTask(id);
                                lvItems.model.remove(index);
                            }
                        }
                    }

                    Button{
                        id: btnDone
                        text: "Done"
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        onClicked: {
                            SqlDb.changeStatus(id, 1);
                            lvItems.model.remove(index);
                            //TODO: Add it to "Done" tab
                        }
                    }

                    MouseArea{
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: imgRemove.left

                        onClicked: {
                            lvItems.currentIndex = index
                        }
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                    }
                }

                highlightMoveDuration: 0
                highlightResizeDuration: 0

                highlight: Rectangle {
                    color: 'grey'
                }

                focus: true
                onCurrentItemChanged: console.log(model.get(lvItems.currentIndex).title + ' selected')

            }

            TextField{
                id:txtNewTask
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 5
                Keys.onPressed: {
                    if (event.key===16777220 || event.key===16777221)
                    {
                        addTask(txtNewTask.text);
                        txtNewTask.clear();
                    }
                }
            }

        }

        Page {
            //TODO: Done page!
        }
    }

    function addTask(textTask){
        if(textTask !== "")
        {
            lvItems.model.append({
                                     id: SqlDb.newId(),
                                     title:"TODO",
                                     description: textTask
                                 });
            SqlDb.insertTask("TODO", textTask);
        }
    }
}

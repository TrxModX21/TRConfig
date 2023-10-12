/*
 *   Copyright 2016 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 2.2

import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: root

    /*
     * Any message to be displayed to the user, visible above the text fields
     */
    property alias notificationMessage: notificationsLabel.text

    /*
     * A list of Items (typically ActionButtons) to be shown in a Row beneath the prompts
     */
    property alias actionItems: actionItemsLayout.children

    /*
     * A model with a list of users to show in the view
     * The following roles should exist:
     *  - name
     *  - iconSource
     *
     * The following are also handled:
     *  - vtNumber
     *  - displayNumber
     *  - session
     *  - isTty
     */
    property alias userListModel: userListView.model

    /*
     * Self explanatory
     */
    property alias userListCurrentIndex: userListView.currentIndex
    property var userListCurrentModelData: userListView.currentIndex === null ? [] : userListView.currentIndex.m
    property bool showUserList: true

    property alias userList: userListView

    default property alias _children: innerLayout.children


    Rectangle{

        anchors.fill: parent
        color: "transparent"
        UserList {
            anchors.bottom : parent.verticalCenter
            anchors.bottomMargin: units.gridUnit
            anchors.horizontalCenter: parent.horizontalCenter
            id: userListView
            height: 40
            width: 200
            visible: false
            z:1
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom : parent.verticalCenter
            anchors.bottomMargin: units.gridUnit
            font.pointSize: 40
            color: config.colorPrimary
            text: userListView.selectedUser
            font.capitalization: Font.Capitalize
            font.family: newFont.name
            z:2
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor;
                onClicked:  userListView.popup.open()
            }
        }

        //goal is to show the prompts, in ~16 grid units high, then the action buttons
        //but collapse the space between the prompts and actions if there's no room
        //ui is constrained to 16 grid units wide, or the screen
        ColumnLayout {
            id: prompts
            anchors.top: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: parent.right
            Layout.fillHeight: true

            PlasmaComponents.Label {
                id: notificationsLabel
                Layout.maximumWidth: units.gridUnit * 16
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.italic: true
            }
            ColumnLayout {
                Layout.minimumHeight: implicitHeight
                Layout.maximumHeight: units.gridUnit * 10
                Layout.maximumWidth: units.gridUnit * 16
                Layout.alignment: Qt.AlignHCenter
                RowLayout {
                    id: innerLayout
                    Layout.alignment: Qt.AlignBottom
                    Layout.fillWidth: true
                }
            }
        }

        RowLayout {
            anchors.right: parent.right
            anchors.top: parent.bottom
            anchors.topMargin: units.gridUnit * 3
            anchors.horizontalCenter: parent.horizontalCenter
            Row { //deliberately not rowlayout as I'm not trying to resize child items
                id: actionItemsLayout
                spacing: units.largeSpacing * 2
                Layout.alignment: Qt.AlignHCenter
            }
        }

    }

}

/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.2

Page {

    property int state_stopped: 1
    property int state_started: 2

    attachedObjects: [
        AboutSheet {
            id: aboutInfo
        }
    ]

    Menu.definition: MenuDefinition {
        actions: [
            ActionItem {
                title: "About"
                imageSource: "images/about.png"

                onTriggered: {
                    aboutInfo.open();
                }
            }
        ]
    }

    Container {
        // ======== Identity ===============

        id: mainPage
        objectName: "mainPage"

        // ======== Properties =============

        // ======== SIGNAL()s ==============

        signal startListening()
        signal stopListening()

        // ======== SLOT()s ================

        function onMessage(text) {
            logMessage(text);
        }

        // ======== Local functions ========

        function logMessage(message) {
            log.text += (qsTr("\n") + message );
        }

        layout: StackLayout {
        }

        topPadding: 10
        leftPadding: 30
        rightPadding: 30

        Label {
            text: qsTr("Where's My Beacon")
            textStyle {
                base: SystemDefaults.TextStyles.BigText
                fontWeight: FontWeight.Bold
            }
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            Button {
                id: startListeningButton
                text: "Start"
                enabled: app.state == state_stopped
                horizontalAlignment: HorizontalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 50
                }
                onClicked: {
                    mainPage.startListening();
                }
            }
            Button {
                id: stopListeningButton
                text: "Stop"
                enabled: app.state == state_started
                horizontalAlignment: HorizontalAlignment.Center
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 50
                }
                onClicked: {
                    mainPage.stopListening();
                }
            }
        }

        Container {
            topPadding: 20
            leftPadding: 20
            rightPadding: 20
            bottomPadding: 20

            ListView {
                id: beacon_list
                objectName: "beacon_list"

                dataModel: app.model

                listItemComponents: [
                    ListItemComponent {
                        type: "listItem"
                        CustomListItem {
                            dividerVisible: true
                            highlightAppearance: HighlightAppearance.Frame
                            Container {
                                Label {
                                    text: "MAC: " + ListItemData.MAC
                                    textStyle.fontWeight: FontWeight.Bold
                                }
                                Label {
                                    text: " UUID: " + ListItemData.UUID
                                }
                                Label {
                                    text: " Major: " + ListItemData.MAJOR + " Minor: " + ListItemData.MINOR
                                }
                                Label {
                                    text: " Calibrated Power: " + ListItemData.RSSI + " Path Loss: " + ListItemData.LOSS
                                }
                                Divider {
                                    
                                }
                            }
                        }
                    }
                ]

                function itemType(data, indexPath) {
                    if (indexPath.length == 1) {
                        return "header";
                    } else {
                        return "listItem";
                    }
                }
                accessibility.name: "TODO: Add property content"
            }
        }
        Logger {
            id: log
            visible: false
        }
    }
}

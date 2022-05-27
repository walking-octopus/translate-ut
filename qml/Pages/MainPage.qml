/*
 * Copyright (C) 2022  walking-octopus
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * translate is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


import QtQuick 2.7
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12 as QQC
import QtQuick.Controls.Suru 2.2
import "../Components"

Page {
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: i18n.tr("Translate")

        trailingActionBar {
            actions: [
                Action {
                    iconName: "settings"
                    text: i18n.tr("Settings")
                    onTriggered: showSettings()
                },
                Action {
                    iconName: "info"
                    text: i18n.tr("About")
                    onTriggered: pStack.push(Qt.resolvedUrl("./About.qml"))
                }
            ]
        }
    }
    title: i18n.tr("Translate")

    ColumnLayout {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        spacing: units.gu(preferences.commonMargin)

        GridLayout {
            columns: root.width > units.gu(70) ? 2 : 1

            TextArea {
                id: input
                placeholderText: i18n.tr("Hello!")
                font.pixelSize: FontUtils.sizeToPixels("medium") * preferences.fontSize / 10
                
                Layout.fillHeight: true; Layout.fillWidth: true
                Layout.leftMargin: units.gu(preferences.commonMargin)
                Layout.rightMargin: units.gu(preferences.commonMargin)
                Layout.topMargin: units.gu(preferences.commonMargin)

                // Play
                // Button {
                //     anchors {
                //         right: parent.right
                //         bottom: parent.bottom
                //         rightMargin: units.gu(2)
                //         bottomMargin: units.gu(2)
                //     }

                //     iconName: "media-playback-start"
                //     onClicked: lingva.get_audio(
                //         input.text,
                //         lingva.language_name_to_code(source_lang.currentIndex)
                //     )
                //     width: units.gu(4)
                //     color: "transparent"
                // }
            }

            TextArea {
                id: output
                placeholderText: "Bonjour!"
                font.pixelSize: FontUtils.sizeToPixels("medium") * preferences.fontSize / 10
                readOnly: true

                // Clear, Copy, Play
                Button {
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        rightMargin: units.gu(2)
                        bottomMargin: units.gu(2)
                    }

                    iconName: "edit-clear"
                    onClicked: {
                        output.text = "";
                        input.text = "";
                    }
                    width: units.gu(4)
                    color: "transparent"
                }

                Button {
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                        rightMargin: units.gu(6)
                        bottomMargin: units.gu(2)
                    }

                    iconName: "edit-copy"
                    onClicked: Clipboard.push(output.text)
                    width: units.gu(4)
                    color: "transparent"
                }

                // Button {
                //     anchors {
                //         right: parent.right
                //         bottom: parent.bottom
                //         rightMargin: units.gu(10)
                //         bottomMargin: units.gu(2)
                //     }
                    
                //     iconName: "media-playback-start"
                //     onClicked: lingva.get_audio(
                //         output.text,
                //         lingva.language_name_to_code(target_lang.currentIndex + 1)
                //     )
                //     width: units.gu(4)
                //     color: "transparent"
                // }

                // A hack to allow copying text
                onSelectedTextChanged: {
                    if (selectedText.length > 0) {
                        cursorVisible = true
                    }
                }

                Layout.fillHeight: true; Layout.fillWidth: true
                Layout.leftMargin: units.gu(preferences.commonMargin)
                Layout.rightMargin: units.gu(preferences.commonMargin)
                Layout.topMargin: units.gu(preferences.commonMargin)
            }

            Layout.fillHeight: true; Layout.fillWidth: true
        }

        RowLayout {
            QQC.ComboBox {
                id: source_lang
                Layout.fillWidth: true

                onCurrentIndexChanged: preferences.last_source_lang = source_lang.currentIndex
            }

            QQC.Button {
                icon.name: "swap"
                // Layout.preferredWidth: icon.width*2

                enabled: source_lang.currentIndex - 1 != -1 ? true : false
                onClicked: {
                    const old_source_lang = source_lang.currentIndex;
                    source_lang.currentIndex = target_lang.currentIndex + 1;
                    target_lang.currentIndex = old_source_lang - 1;

                    const old_input = input.text;
                    input.text = output.text;
                    output.text = old_input;
                }
            }

            QQC.ComboBox {
                id: target_lang
                Layout.fillWidth: true

                onCurrentIndexChanged: preferences.last_target_lang = target_lang.currentIndex
            }

            Component.onCompleted: lingva.get_languages(
                preferences.last_source_lang,
                preferences.last_target_lang
            )

            Layout.fillWidth: true
            Layout.leftMargin: units.gu(preferences.commonMargin)
            Layout.rightMargin: units.gu(preferences.commonMargin)
        }

        Button {
            text: i18n.tr("Translate!")
            onClicked: lingva.translate(
                lingva.language_name_to_code(
                    source_lang.currentIndex
                ),
                lingva.language_name_to_code(
                    target_lang.currentIndex + 1
                ),
                input.text
            )

            color: UbuntuColors.green
            enabled: input.length != 0 ? true : false

            Layout.fillWidth: true
            Layout.leftMargin: units.gu(preferences.commonMargin)
            Layout.rightMargin: units.gu(preferences.commonMargin)
            Layout.bottomMargin: units.gu(preferences.commonMargin)
        }
    }

    Lingva {
        id: lingva
    }
}

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
import Qt.labs.settings 1.0
import QtQuick.Controls 2.12 as QQC
import QtQuick.Controls.Suru 2.2
//import "./Components"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'translate.walking-octopus'
    automaticOrientation: true

    width: units.gu(65)
    height: units.gu(70)
    anchorToKeyboard: true

    Settings {
        id: preferences

        property int last_source_lang: 0
        property int last_target_lang: 26
        //property int commonMargin: units.gu(2)
    }

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('Translate')

            trailingActionBar {
                actions: [
                    Action {
                        iconName: "settings"
                        text: "Settings"
                        // Todo: add settings
                        onTriggered: print("settings")
                    },
                    Action {
                        iconName: "info"
                        text: "About"
                        // Todo: add about page
                        onTriggered: print("about page")
                    }]
            }
        }
        title: "Translate"

        ColumnLayout {
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            spacing: units.gu(2)

            GridLayout {
                columns: root.width > units.gu(70) ? 2 : 1

                TextArea {
                    id: input
                    placeholderText: "Hello!"

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Layout.leftMargin: units.gu(2)
                    Layout.rightMargin: units.gu(2)
                    Layout.topMargin: units.gu(2)
                }
                // Todo: add the bottom pannel
                TextArea {
                    id: output
                    placeholderText: "Bonjour!"
                    readOnly: true

                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Layout.leftMargin: units.gu(2)
                    Layout.rightMargin: units.gu(2)
                    Layout.topMargin: units.gu(2)
                }
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            // Todo: remember selected language
            RowLayout {
                QQC.ComboBox {
                    id: source_lang
                    Layout.fillWidth: true

                    onCurrentIndexChanged: preferences.last_source_lang = source_lang.currentIndex
                }
                QQC.Button {
                    icon.name: "swap"
                    Layout.preferredWidth: units.gu(5)

                    enabled: source_lang.currentIndex - 1 != -1 ? true : false
                    onClicked: {
                        const old_source_lang = source_lang.currentIndex
                        source_lang.currentIndex = target_lang.currentIndex + 1
                        target_lang.currentIndex = old_source_lang - 1

                        const old_input = input.text
                        input.text = output.text
                        output.text = old_input
                    }
                }
                QQC.ComboBox {
                    id: target_lang
                    Layout.fillWidth: true

                    onCurrentIndexChanged: preferences.last_target_lang = target_lang.currentIndex
                }

                Component.onCompleted: lingva.get_languages(preferences.last_source_lang, preferences.last_target_lang)

                Layout.fillWidth: true
                Layout.leftMargin: units.gu(2)
                Layout.rightMargin: units.gu(2)
            }

            Button {
                text: i18n.tr('Translate!')
                onClicked: lingva.translate(
                    lingva.language_name_to_code(source_lang.currentIndex),
                    lingva.language_name_to_code(target_lang.currentIndex + 1),
                    input.text)

                color: UbuntuColors.green
                enabled: input.length != 0 ? true : false

                Layout.fillWidth: true
                Layout.leftMargin: units.gu(2)
                Layout.rightMargin: units.gu(2)
                Layout.bottomMargin: units.gu(2)
            }

        }

        QtObject {
            id: lingva
            property string baseURL: "https://lingva.ml/api/v1"
            property var languages

            function translate(source, target, query) {
                const url = baseURL + "/%1/%2/%3".arg(source).arg(target).arg(query)

                request(url).then(response => {
                    const data = JSON.parse(response)

                    //print(data.translation)

                    output.text = data.translation
                })
                .catch(error => console.error(error))
            }

            function get_audio(lang, query) {
                const url = baseURL + "/audio/%1/%2".arg(lang).arg(query)

                request(url).then(response => {
                    const data = JSON.parse(response)

                    print(data.audio)
                })
            }

            function get_languages(last_source_lang, last_target_lang) {
                request(baseURL + "/languages").then(response => {
                    const data = JSON.parse(response)
                    languages = data.languages

                    let language_names = []
                    languages.forEach(i => language_names.push(i.name))
                    //for(var i = 1; i <= 10; i++) {language_names.push(i)}

                    source_lang.model = language_names
                    language_names.shift(); target_lang.model = language_names

                    target_lang.currentIndex = last_target_lang
                    source_lang.currentIndex = last_source_lang
                })
            }

            function language_name_to_code(i) {
                return languages[i].code
            }
        }
    }

    function request(url) {
        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest();
            xhr.open("GET", url, true);
            xhr.onload = () => {
                if (xhr.status >= 200 && xhr.status < 300) {
                    resolve(xhr.response);
                } else {
                    reject(xhr.statusText);
                }
            };
            xhr.onerror = () => reject(xhr.statusText);
            xhr.send();
        });
    }

}

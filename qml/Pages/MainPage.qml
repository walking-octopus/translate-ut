import QtQuick 2.7
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12 as QQC
import QtQuick.Controls.Suru 2.2

Page {
    anchors.fill: parent

    header: PageHeader {
        id: header
        title: i18n.tr('Translate')

        trailingActionBar {
            actions: [
                Action {
                    iconName: "settings"
                    text: i18n.tr("Settings")
                    // Todo: add settings
                    onTriggered: showSettings()
                },
                Action {
                    iconName: "info"
                    text: i18n.tr("About")
                    onTriggered: pStack.push(Qt.resolvedUrl("./About.qml"))
                }]
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

                Layout.fillHeight: true
                Layout.fillWidth: true

                Layout.leftMargin: units.gu(preferences.commonMargin)
                Layout.rightMargin: units.gu(preferences.commonMargin)
                Layout.topMargin: units.gu(preferences.commonMargin)
            }
            // Todo: add the bottom pannel
            TextArea {
                id: output
                placeholderText: "Bonjour!"
                readOnly: true

                Layout.fillHeight: true
                Layout.fillWidth: true

                Layout.leftMargin: units.gu(preferences.commonMargin)
                Layout.rightMargin: units.gu(preferences.commonMargin)
                Layout.topMargin: units.gu(preferences.commonMargin)
            }
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        RowLayout {
            QQC.ComboBox {
                id: source_lang
                Layout.fillWidth: true

                onCurrentIndexChanged: preferences.last_source_lang = source_lang.currentIndex
            }
            QQC.Button {
                icon.name: "swap"
                Layout.preferredWidth: icon.width*2

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
            Layout.leftMargin: units.gu(preferences.commonMargin)
            Layout.rightMargin: units.gu(preferences.commonMargin)
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
            Layout.leftMargin: units.gu(preferences.commonMargin)
            Layout.rightMargin: units.gu(preferences.commonMargin)
            Layout.bottomMargin: units.gu(preferences.commonMargin)
        }

    }

    QtObject {
        id: lingva
        property string baseURL
        property var languages

        function translate(source, target, query) {
            const url = baseURL + "/%1/%2/%3".arg(source).arg(target).arg(encodeURIComponent(query))

            request(url).then(response => {
                const data = JSON.parse(response)

                //print(data.translation)

                output.text = data.translation
            })
            .catch(error => console.error(error))
        }

        function get_audio(lang, query) {
            const url = baseURL + "/audio/%1/%2".arg(lang).arg(encodeURIComponent(query))

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

        Component.onCompleted: lingva.baseURL = preferences.baseURL
    }
}

import QtQuick 2.7
import Lomiri.Components 1.3
import "../Components"

Page {
    id: pageSavings

    header: PageHeader {
        title: i18n.tr('About')

        flickable: aboutFlickable
    }

    ScrollView {
        width: parent.width
        height: parent.height
        contentItem: aboutFlickable
    }

    Flickable {
        id: aboutFlickable
        width: parent.width; height: width
        contentHeight: mainColumn.height
        topMargin: units.gu(2)
        bottomMargin: units.gu(3)

        Column {
            id: mainColumn
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: units.gu(1)
            spacing: units.gu(2)

            LomiriShape {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: units.gu(2)
                width: units.gu(16); height: width

                radius: "medium"
                source: Image {
                    source: "../../assets/logo.png"
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter

                text: i18n.tr("Translate")
                textSize: Label.Large
                font.bold: true
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: units.gu(1.5)

                text: "walking-octopus"
            }
            
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                textSize: Label.Small
                font.weight: Font.DemiBold
                
                text: Qt.application.version
                color: "white"

                LomiriShape {
                    anchors {
                        fill: parent
                        leftMargin: units.gu(-0.6)
                        rightMargin: units.gu(-0.6)
                        topMargin: units.gu(-0.2)
                        bottomMargin: units.gu(-0.2)
                    }
                    z: -1
                    
                    color: LomiriColors.blue
                    radius: "large"
                }
            }

            AboutItem {
                headerText: i18n.tr('License')
                contentText: "GPLv3"
                url: "https://github.com/walking-octopus/translate-ut#license"
            }

            AboutItem {
                // headerText: i18n.tr("Report an issue")
                contentText: i18n.tr('Report an issue')
                url: "https://github.com/walking-octopus/translate-ut/issues/new"
            }

            AboutItem {
                headerText: i18n.tr("Translation")
                contentText: i18n.tr('Help us translate the app!')
                url: "https://github.com/walking-octopus/translate-ut/tree/main/po"
            }

            AboutItem {
                contentText: i18n.tr('Source code')
                url: "https://github.com/walking-octopus/translate-ut"
            }
        }
    }
}

import QtQuick 2.9
import Ubuntu.Components 1.3

Page {
    id: settingPage

    property alias commonMargin: marginSlider.value
    property alias fontSize: fontSizeSlider.value
    property alias baseURL: dirPath.text

    signal applyChanges
    signal cancelChanges

    header: PageHeader {
        title: i18n.tr("Settings")
        flickable: scrollView.flickableItem

        leadingActionBar.actions: Action {
            text: i18n.tr("Cancel")
            iconName: "close"
            onTriggered: {
                settingPage.cancelChanges();
                pageStack.pop();
            }
        }

        trailingActionBar.actions: Action {
            text: i18n.tr("Apply")
            iconName: "ok"
            onTriggered: {
                settingPage.applyChanges();
                pageStack.pop();
            }
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        Column {
            id: column
            width: scrollView.width

            property int mSpacing: units.gu(1)

            ListItem {
                height: dirlabel.height + dirPath.height + 2 * column.mSpacing
                Label {
                    id: dirlabel
                    text: i18n.tr("Linva instance:")
                    anchors {
                        top: parent.top; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
                TextField {
                    id: dirPath
                    width: parent.width
                    anchors.top: dirlabel.bottom
                    anchors {
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
            }

            ListItem {
                height: marginLabel.height + marginSlider.height + column.mSpacing
                Label {
                    id:marginLabel
                    text: i18n.tr("Spacing:")
                    anchors {
                        top: parent.top; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
                Slider {
                    id:marginSlider
                    function formatValue(v) { return v.toFixed(0); }
                    minimumValue: 0
                    maximumValue: 8
                    value: preferences.commonMargin
                    live: true
                    width: parent.width
                    anchors.top: marginLabel.bottom
                    anchors {
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
            }

            ListItem {
                height: fontSizeLabel.height + fontSizeSlider.height + column.mSpacing
                Label {
                    id:fontSizeLabel
                    text: i18n.tr("Font size:")
                    anchors {
                        top: parent.top; topMargin: column.mSpacing
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
                Slider {
                    id:fontSizeSlider
                    function formatValue(v) { return v.toFixed(0); }
                    minimumValue: 1
                    maximumValue: 50
                    value: preferences.commonMargin
                    live: true
                    width: parent.width
                    anchors.top: fontSizeLabel.bottom
                    anchors {
                        left: parent.left; leftMargin: units.gu(1)
                        right: parent.right; rightMargin: units.gu(1)
                    }
                }
            }
        }
    }
}

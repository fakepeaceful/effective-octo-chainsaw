import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

ShellRoot {
    PwObjectTracker {
        objects: Pipewire.defaultAudioSink
            ? [Pipewire.defaultAudioSink]
            : []
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    PanelWindow {
        id: bar

        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: 30
        color: "#BF1A1A1A"

        // ============================================================
        // LEFT — WORKSPACES
        // ============================================================

        RowLayout {
            anchors {
                left: parent.left
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }

            height: parent.height
            spacing: 14

            Repeater {
                model: 10

                Rectangle {
                    required property int index

                    readonly property int workspaceId: index + 1

                    readonly property bool active:
                        Hyprland.focusedWorkspace !== null &&
                        Hyprland.focusedWorkspace.id === workspaceId

                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 12
                    Layout.preferredHeight: 12

                    radius: 6

                    color: active
                        ? "white"
                        : "transparent"

                    border.color: "white"
                    border.width: 1

                    opacity: active ? 1.0 : 0.45

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            Hyprland.dispatch(
                                "workspace " + workspaceId
                            )
                        }
                    }
                }
            }
        }


        // ============================================================
        // CENTER — MUSIC
        // ============================================================

        Text {
            id: musicText

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            width: Math.min(
                implicitWidth,
                bar.width * 0.35
            )

            height: parent.height

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            font {
                family: "SF Pro Display"
                pixelSize: 20
                bold: false
            }

            color: "white"

            elide: Text.ElideRight

            property var player: {
                const players = Mpris.players.values

                if (!players || players.length === 0)
                    return null

                for (let i = 0; i < players.length; ++i) {
                    if (players[i].isPlaying)
                        return players[i]
                }

                return null
            }

            visible:
                player !== null &&
                player.trackTitle !== ""

            text: {
                if (player === null)
                    return ""

                return player.trackTitle || ""
            }
        }


        // ============================================================
        // RIGHT — BATTERY / CLOCK
        // ============================================================

        RowLayout {
            anchors {
                right: parent.right
                rightMargin: 20
                verticalCenter: parent.verticalCenter
            }

            height: parent.height
            spacing: 12


            // ========================================================
            // BATTERY
            // ========================================================

            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: 5

                Text {
                    Layout.alignment: Qt.AlignVCenter

                    font {
                        family: "Iosevka Nerd Font"
                        pixelSize: 20
                    }

                    color: "white"

                    text: {
                        const battery = UPower.displayDevice

                        if (!battery || !battery.ready)
                            return "󰁹"

                        const percentage =
                            Math.round(
                                battery.percentage * 100
                            )

                        if (
                            battery.state ===
                            UPowerDeviceState.Charging
                        )
                            return "󰂄"

                        if (percentage >= 95)
                            return "󰂂"

                        if (percentage >= 85)
                            return "󰂁"

                        if (percentage >= 75)
                            return "󰂀"

                        if (percentage >= 60)
                            return "󰁾"

                        if (percentage >= 45)
                            return "󰁼"

                        if (percentage >= 30)
                            return "󰁻"

                        if (percentage >= 15)
                            return "󰁺"

                        return "󰂎"
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignVCenter

                    font {
                        family: "SF Pro Display"
                        pixelSize: 20
                        bold: false
                    }

                    color: "white"

                    text: {
                        const battery = UPower.displayDevice

                        if (!battery || !battery.ready)
                            return "--%"

                        return Math.round(
                            battery.percentage * 100
                        ) + "%"
                    }
                }
            }


            // ========================================================
            // CLOCK
            // ========================================================

            Text {
                Layout.alignment: Qt.AlignVCenter

                height: parent.height

                verticalAlignment: Text.AlignVCenter

                font {
                    family: "SF Pro Display"
                    pixelSize: 20
                    bold: false
                }

                color: "white"

                text: Qt.formatDateTime(
                    clock.date,
                    "hh:mm  ·  dd MMM yyyy"
                )
            }
        } 
    }
}


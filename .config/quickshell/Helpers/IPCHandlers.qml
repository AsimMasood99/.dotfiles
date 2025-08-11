import QtQuick
import Quickshell.Io
import qs.Bar.Modules
import qs.Helpers
import qs.Widgets.LockScreen
import qs.Widgets.Notification
// import "../Services"
// <-- import your singleton
import "../Services"

Item {
    id: root

    property Applauncher appLauncherPanel
    property LockScreen lockScreen
    property IdleInhibitor idleInhibitor
    property NotificationPopup notificationPopup

    IpcHandler {
        target: "globalIPC"

        // Music controls
        function musicPlayPause(): void {
            console.log("[IPC] Music play/pause called")
            MusicManager.playPause()
        }

        function musicNext(): void {
            console.log("[IPC] Music next called")
            MusicManager.next()
        }

        function musicPrevious(): void {
            console.log("[IPC] Music previous called")
            MusicManager.previous()
        }

        function musicStop(): void {
            console.log("[IPC] Music stop called")
            MusicManager.pause()
        }

        // Other existing IPCs
        function toggleIdleInhibitor(): void {
            root.idleInhibitor.toggle()
        }

        function toggleNotificationPopup(): void {
            console.log("[IPC] NotificationPopup toggle() called")
            root.notificationPopup.togglePopup()
        }

        function toggleLauncher(): void {
            if (!root.appLauncherPanel) {
                console.warn("AppLauncherIpcHandler: appLauncherPanel not set!")
                return
            }
            if (root.appLauncherPanel.visible) {
                root.appLauncherPanel.hidePanel()
            } else {
                console.log("[IPC] Applauncher show() called")
                root.appLauncherPanel.showAt()
            }
        }

        function toggleLock(): void {
            if (!root.lockScreen) {
                console.warn("LockScreenIpcHandler: lockScreen not set!")
                return
            }
            console.log("[IPC] LockScreen show() called")
            root.lockScreen.locked = true
        }
    }
}

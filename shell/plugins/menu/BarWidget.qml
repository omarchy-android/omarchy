import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.menu"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "\ue900"
    fontFamily: "omarchy"
    centerFigures: false
    horizontalMargin: 7.5
    onPressed: function(button) {
      if (!root.bar) return
      if (button === Qt.RightButton) root.bar.run("xdg-terminal-exec")
      // This widget and the menu live in the same Quickshell process. Routing
      // a click through bash -> timeout -> qs IPC -> this same process is
      // especially expensive under PRoot and makes this button feel much
      // slower than the other in-process bar popups. Keep IPC only as a
      // compatibility fallback for a nonstandard bar host.
      else if (root.bar.shell && typeof root.bar.shell.toggle === "function")
        root.bar.shell.toggle("omarchy.menu", '{"menu":"root"}')
      else
        root.bar.run("omarchy-shell shell toggle omarchy.menu '{\"menu\":\"root\"}'")
    }
  }
}

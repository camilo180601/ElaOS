// ElaOS Modes — switch de modos en la barra superior (GNOME 45+).
import GObject from 'gi://GObject';
import St from 'gi://St';
import GLib from 'gi://GLib';

import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as PanelMenu from 'resource:///org/gnome/shell/ui/panelMenu.js';
import * as PopupMenu from 'resource:///org/gnome/shell/ui/popupMenu.js';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';

const MODES = [
    ['Normal',  'normal',  'face-smile-symbolic'],
    ['Gaming',  'gaming',  'applications-games-symbolic'],
    ['Hacking', 'hacking', 'security-high-symbolic'],
];

const ElaosIndicator = GObject.registerClass(
class ElaosIndicator extends PanelMenu.Button {
    _init() {
        super._init(0.0, 'ElaOS Modes');

        this.add_child(new St.Icon({
            icon_name: 'preferences-desktop-display-symbolic',
            style_class: 'system-status-icon',
        }));

        for (const [label, key, icon] of MODES) {
            const item = new PopupMenu.PopupImageMenuItem(label, icon);
            item.connect('activate', () => {
                GLib.spawn_command_line_async(`/usr/local/bin/elaos-mode ${key}`);
                Main.notify('ElaOS', `Modo ${label} activado`);
            });
            this.menu.addMenuItem(item);
        }
    }
});

export default class ElaosModes extends Extension {
    enable() {
        this._indicator = new ElaosIndicator();
        Main.panel.addToStatusArea('elaos-modes', this._indicator);
    }

    disable() {
        this._indicator?.destroy();
        this._indicator = null;
    }
}

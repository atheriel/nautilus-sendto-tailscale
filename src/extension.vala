/* -*- mode: vala; indent-tabs-mode: t; tab-width: 4 -*-
 *
 * SPDX-License-Identifier: LGPL-2.1-or-later
 * SPDX-FileCopyrightText: 2023 Aaron Jacobs
 */

class SendToTailscaleMenuProvider : Nautilus.MenuProvider, Object {
	public virtual List<Nautilus.MenuItem>? get_file_items(Gtk.Widget window, List<Nautilus.FileInfo> files) {
		if (files.is_empty ()) {
			return null;
		}
		var filenames = new List<string>();
		foreach (var file in files) {
			var path = file.get_location ().get_path ();
			if (path != null && !file.is_directory ()) {
				filenames.append ((!) path);
			}
		}
		if (filenames.is_empty ()) {
			// Tailscale does not support sending directories, so hide the menu
			// item if there are no non-directory files selected.
			return null;
		}
		var status = get_status ();
		if (status.stopped) {
			// Hide the menu item when Tailscale is stopped.
			return null;
		}
		var submenu = new Nautilus.Menu ();
		if (status.online.length == 0 && status.offline.length == 0) {
			// In the rare case that there are no other devices, add a special
			// non-selectable entry to the menu explaining as much.
			var item = new Nautilus.MenuItem ("none", "No active devices");
			item.sensitive = false;
			submenu.append_item (item);
		}
		foreach (var device in status.online) {
			var item = new Nautilus.MenuItem (device, device);
			item.activate.connect (() => send_to_device.begin (filenames, device));
			submenu.append_item (item);
		}
		foreach (var device in status.offline) {
			// For informational purposes, show offline devices as
			// non-selectable entries in the menu.
			var item = new Nautilus.MenuItem (device, device);
			item.sensitive = false;
			submenu.append_item (item);
		}
		var item = new Nautilus.MenuItem (
			"sendto-tailscale",
			_("Send to Tailscale Device"),
			_("Send file(s) to a Tailscale device")
		);
		item.menu = submenu;
		var items = new List<Nautilus.MenuItem>();
		items.append(item);
		return items;
	}

	public virtual List<Nautilus.MenuItem>? get_background_items(Gtk.Widget window, Nautilus.FileInfo current_folder) {
		return null;
	}

	struct StatusResult {
		bool stopped;
		string[] online;
		string[] offline;
	}

	private StatusResult get_status() {
		bool stopped = false;
		string[] online = {}, offline = {};
		string[] argv = { "tailscale", "status", "--self=false", "--active" };
		try {
			var proc = new Subprocess.newv (argv, SubprocessFlags.STDOUT_PIPE);
			var stream = new DataInputStream ((!) proc.get_stdout_pipe ());
			string? rawline;
			while ((rawline = stream.read_line ()) != null) {
				var line = (!) rawline;
				if (line.contains ("Tailscale is stopped")) {
					// This should be the only line.
					stopped = true;
					continue;
				}
				var columns = line.split ("  ");
				if (columns.length < 5) {
					print ("unexpected tailscale status output: %s\n", line);
					continue;
				}
				if (line.contains ("offline")) {
					offline += columns[1].strip ();
				} else {
					online += columns[1].strip ();
				}
			}
			proc.wait ();
			if (!stopped && proc.get_exit_status () != 0) {
				print ("tailscale status failed with code %d\n",
					   proc.get_exit_status ());
			}
		} catch (Error e) {
			print ("failed to get tailscale status: %s\n", e.message);
		}
		return { stopped, online, offline };
	}

	private async void send_to_device(List<string> filenames, string target) {
		var app = GLib.Application.get_default ();
		string[] argv = { "tailscale", "file", "cp", "--verbose" };
		foreach (var path in filenames) {
			argv += (!) path;
		}
		argv += target + ":";
		try {
			var proc = new Subprocess.newv (argv, SubprocessFlags.STDERR_PIPE);
			var stream = new DataInputStream ((!) proc.get_stderr_pipe ());
			string? rawline;
			while ((rawline = yield stream.read_line_async ()) != null) {
				var line = (!) rawline;
				// Parse the CLI output to determine when a file has finished
				// being sent.
				if (!line.contains ("sending") && !line.contains ("sent")) {
					print ("unexpected tailscale file cp output: %s\n", line);
					continue;
				}
				var split = line.split ("sent ", 2);
				if (split.length != 2) {
					continue;
				}
				var file = split[1].replace ("\"", "");
				if (app == null) {
					print ("sent: %s\n", file);
					continue;
				}
				var notification = new Notification (_("File Sent to Tailscale Device"));
				notification.set_body (
					_("%s was sent to device \"%s\".").printf (file, target));
				((!) app).send_notification ("sendto-tailscale", notification);
			}
			proc.wait ();
			if (proc.get_exit_status () != 0) {
				print ("tailscale file cp failed with status %d\n",
					   proc.get_exit_status ());
			}
		} catch (Error e) {
			print ("failed to send file to tailscale device: %s\n", e.message);
		}
	}
}

[ModuleInit]
public void nautilus_module_initialize(TypeModule module) {
	typeof(SendToTailscaleMenuProvider);
}

public void nautilus_module_shutdown() {
}

// See shim.c.
public void _nautilus_module_list_types([CCode (array_length_type = "int")] out Type[] types) {
	types = {
		typeof(SendToTailscaleMenuProvider),
	};
}

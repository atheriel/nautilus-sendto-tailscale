/* libnautilus-extension.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "Nautilus", gir_namespace = "Nautilus", gir_version = "3.0", lower_case_cprefix = "nautilus_")]
namespace Nautilus {
	[CCode (cheader_filename = "nautilus-extension.h", type_id = "nautilus_column_get_type ()")]
	public class Column : GLib.Object {
		[CCode (has_construct_function = false)]
		public Column (string name, string attribute, string label, string description);
		[NoAccessorMethod]
		public string attribute { owned get; set; }
		[NoAccessorMethod]
		public uint attribute_q { get; }
		[NoAccessorMethod]
		public Gtk.SortType default_sort_order { get; set; }
		[NoAccessorMethod]
		public string description { owned get; set; }
		[NoAccessorMethod]
		public string label { owned get; set; }
		[NoAccessorMethod]
		public string name { owned get; construct; }
		[NoAccessorMethod]
		public float xalign { get; set; }
	}
	[CCode (cheader_filename = "nautilus-extension.h", type_id = "nautilus_menu_get_type ()")]
	public class Menu : GLib.Object {
		[CCode (has_construct_function = false)]
		public Menu ();
		public void append_item (owned Nautilus.MenuItem item);
		public GLib.List<Nautilus.MenuItem>? get_items ();
	}
	[CCode (cheader_filename = "nautilus-extension.h", type_id = "nautilus_menu_item_get_type ()")]
	public class MenuItem : GLib.Object {
		[CCode (has_construct_function = false)]
		public MenuItem (string name, string label, string? tip = null, string? icon = null);
		public void set_submenu (owned Nautilus.Menu menu);
		[NoAccessorMethod]
		public string? icon { owned get; set; }
		[NoAccessorMethod]
		public string label { owned get; set; }
		[NoAccessorMethod]
		public Nautilus.Menu menu { owned get; set; }
		[NoAccessorMethod]
		public string name { owned get; construct; }
		[NoAccessorMethod]
		public bool priority { get; set; }
		[NoAccessorMethod]
		public bool sensitive { get; set; }
		[NoAccessorMethod]
		public string? tip { owned get; set; }
		[HasEmitter]
		public virtual signal void activate ();
	}
	[CCode (cheader_filename = "nautilus-extension.h", has_type_id = false)]
	[Compact]
	public class OperationHandle {
	}
	[CCode (cheader_filename = "nautilus-extension.h", type_id = "nautilus_property_page_get_type ()")]
	public class PropertyPage : GLib.Object {
		[CCode (has_construct_function = false)]
		public PropertyPage (string name, Gtk.Widget label, Gtk.Widget page);
		[NoAccessorMethod]
		public Gtk.Widget label { owned get; set; }
		[NoAccessorMethod]
		public string name { owned get; construct; }
		[NoAccessorMethod]
		public Gtk.Widget page { owned get; set; }
	}
	[CCode (cheader_filename = "nautilus-extension.h", type_id = "nautilus_column_provider_get_type ()")]
	public interface ColumnProvider : GLib.Object {
		public abstract GLib.List<Nautilus.Column>? get_columns ();
	}
	[CCode (cheader_filename = "nautilus-extension.h", type_cname = "NautilusFileInfoInterface", type_id = "nautilus_file_info_get_type ()")]
	public interface FileInfo : GLib.Object {
		public abstract void add_emblem (string emblem_name);
		public abstract bool can_write ();
		public static Nautilus.FileInfo create (GLib.File location);
		public static Nautilus.FileInfo create_for_uri (string uri);
		public abstract string get_activation_uri ();
		[CCode (vfunc_name = "get_string_attribute")]
		public abstract string? get_attribute (string name);
		public abstract GLib.FileType get_file_type ();
		public abstract GLib.File get_location ();
		public abstract string get_mime_type ();
		public abstract GLib.Mount? get_mount ();
		public abstract string get_name ();
		public abstract Nautilus.FileInfo? get_parent_info ();
		public abstract GLib.File? get_parent_location ();
		public abstract string get_parent_uri ();
		public abstract string get_uri ();
		public abstract string get_uri_scheme ();
		public abstract void invalidate_extension_info ();
		public abstract bool is_directory ();
		public abstract bool is_gone ();
		public abstract bool is_mime_type (string mime_type);
		public static Nautilus.FileInfo? lookup (GLib.File location);
		public static Nautilus.FileInfo? lookup_for_uri (string uri);
		[CCode (vfunc_name = "add_string_attribute")]
		public abstract void set_attribute (string name, string value);
	}
	[CCode (cheader_filename = "nautilus-extension.h", type_id = "nautilus_info_provider_get_type ()")]
	public interface InfoProvider : GLib.Object {
		public abstract void cancel_update (Nautilus.OperationHandle handle);
		public static void update_complete_invoke (GLib.Closure update_complete, Nautilus.InfoProvider provider, Nautilus.OperationHandle handle, Nautilus.OperationResult result);
		public abstract Nautilus.OperationResult update_file_info (Nautilus.FileInfo file, GLib.Closure update_complete, out unowned Nautilus.OperationHandle? handle);
	}
	[CCode (cheader_filename = "nautilus-extension.h", type_id = "nautilus_location_widget_provider_get_type ()")]
	public interface LocationWidgetProvider : GLib.Object {
		public abstract unowned Gtk.Widget? get_widget (string uri, Gtk.Widget window);
	}
	[CCode (cheader_filename = "nautilus-extension.h", type_id = "nautilus_menu_provider_get_type ()")]
	public interface MenuProvider : GLib.Object {
		public abstract GLib.List<Nautilus.MenuItem>? get_background_items (Gtk.Widget window, Nautilus.FileInfo current_folder);
		public abstract GLib.List<Nautilus.MenuItem>? get_file_items (Gtk.Widget window, GLib.List<Nautilus.FileInfo> files);
		public virtual signal void items_updated ();
	}
	[CCode (cheader_filename = "nautilus-extension.h", type_id = "nautilus_property_page_provider_get_type ()")]
	public interface PropertyPageProvider : GLib.Object {
		public abstract GLib.List<Nautilus.PropertyPage>? get_pages (GLib.List<Nautilus.FileInfo> files);
	}
	[CCode (cheader_filename = "nautilus-extension.h", cprefix = "NAUTILUS_OPERATION_", type_id = "nautilus_operation_result_get_type ()")]
	public enum OperationResult {
		COMPLETE,
		FAILED,
		IN_PROGRESS
	}
}

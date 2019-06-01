using Gtk;

public class MyApp : Gtk.Application {

    public MyApp () {
        Object (
            application_id: "com.github.omig12.calcapp",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
         var window = new Gtk.ApplicationWindow (this);
         window.default_height = 100;
         window.default_width = 100;
         window.border_width = 10;
         window.title = "Simple Calculator";

         var grid = new Gtk.Grid();
         // grid.orientation  = Gtk.Orientation.VERTICAL;
         grid.row_spacing = 10;
         grid.column_spacing = 10;

         var icon = new GLib.ThemedIcon ("dialog-warning");


         var input1 = new Gtk.Entry();
         input1.placeholder_text = "number 1";
         input1.set_visibility(true);
         input1.set_icon_from_gicon(Gtk.EntryIconPosition.SECONDARY, icon);
         grid.attach(input1, 0, 0, 1, 1);

         var mult = new Gtk.Button.with_label("*");
         grid.attach_next_to(mult, input1, Gtk.PositionType.BOTTOM, 1, 1);

         var sum = new Gtk.Button.with_label("+");
         grid.attach_next_to(sum, mult, Gtk.PositionType.BOTTOM, 1, 1);

         var div = new Gtk.Button.with_label("/");
         grid.attach_next_to( div, sum, Gtk.PositionType.BOTTOM, 1, 1);

         var sub = new Gtk.Button.with_label("-");
         grid.attach_next_to(sub, div, Gtk.PositionType.BOTTOM, 1, 1);

         var op  = new Gtk.Label ("?");
         grid.attach_next_to(op, input1, Gtk.PositionType.RIGHT, 1, 1);

         var input2 = new Gtk.Entry();
         input2.placeholder_text = "number 2";
         input2.set_visibility(true);
         input2.set_icon_from_gicon(Gtk.EntryIconPosition.SECONDARY, icon);
         grid.attach_next_to(input2, op, Gtk.PositionType.RIGHT, 1, 1);

         var eq  = new Gtk.Label ("=");
         grid.attach_next_to(eq, input2, Gtk.PositionType.RIGHT, 1, 1);

         var label  = new Gtk.Label ("");
         label.set_selectable(true);
         grid.attach_next_to(label, eq, Gtk.PositionType.RIGHT, 1, 1);

         var button = new Gtk.Button.with_label("Calculate this!");
         button.sensitive = false;
         grid.attach_next_to(button, input2, Gtk.PositionType.BOTTOM, 1, 1);

         window.add(grid);

         int oper = 0;

         mult.clicked.connect (() => {
            button.sensitive = true;
            mult.sensitive = false;
            sum.sensitive = true;
            sub.sensitive = true;
            div.sensitive = true;
            op.set_text("*");
            oper = 1;
         });

         sum.clicked.connect (() => {
            button.sensitive = true;
            mult.sensitive = true;
            sum.sensitive = false;
            sub.sensitive = true;
            div.sensitive = true;
            op.set_text("+");
            oper = 2;
         });

          div.clicked.connect (() => {
             button.sensitive = true;
             mult.sensitive = true;
             sum.sensitive = true;
             sub.sensitive = true;
             div.sensitive = false;
             op.set_text("/");
             oper = 3;
          });

           sub.clicked.connect (() => {
              button.sensitive = true;
              mult.sensitive = true;
              sum.sensitive = true;
              sub.sensitive = false;
              div.sensitive = true;
              op.set_text("-");
              oper = 4;
           });

         button.clicked.connect (() => {
            var result = "";
            switch (oper) {
                case 1:
                    result = (double.parse(input1.get_text()) * double.parse(input2.get_text()) ).to_string();
                    break;
                case 2:
                    result = (double.parse(input1.get_text()) + double.parse(input2.get_text()) ).to_string();
                    break;
                case 3:
                    result = (double.parse(input1.get_text()) / double.parse(input2.get_text()) ).to_string();
                    break;
                case 4:
                    result = (double.parse(input1.get_text()) - double.parse(input2.get_text()) ).to_string();
                    break;
            }
            label.set_markup("<span foreground='slategrey' size='x-large'><b><u>"+ result +"</u></b></span>");
            button.sensitive = false;
            input1.set_icon_from_gicon(Gtk.EntryIconPosition.SECONDARY, null);
            input2.set_icon_from_gicon(Gtk.EntryIconPosition.SECONDARY, null);
            var notification = new Notification ("Calculation finished!");
            notification.set_body (@"Calculation result: $result");
            notification.set_priority (NotificationPriority.URGENT);
            notification.set_icon(new GLib.ThemedIcon ("accessories-calculator"));
            this.send_notification ("com.github.omig12.calcapp", notification);

         });

         window.show_all();
    }

    public static int main(string[] args){
        var app = new MyApp();
        return app.run(args);
    }

}

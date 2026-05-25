"""
crud_view.py - A generic CRUD screen that works for ANY of the 12 tables.

Features required by Stage E:
  - SELECT : a grid showing every row, with foreign keys resolved to readable
             NAMES instead of ids (and the primary-key id never displayed).
  - INSERT : "Add" form.
  - UPDATE : select a row -> the form is pre-filled with its current values
             (the system "brings the fields"), then save.
  - DELETE : remove the selected row.
"""
import tkinter as tk
from tkinter import ttk, messagebox
import customtkinter as ctk

import db
from schema import TABLES


class CrudFrame(ctk.CTkFrame):
    def __init__(self, parent, table_key):
        super().__init__(parent, fg_color="transparent")
        self.meta = TABLES[table_key]
        self.table = self.meta["table"]
        self.pk = self.meta["pk"]
        self.columns = self.meta["columns"]

        self.fk_maps = {}      # col_name -> {id: label}
        self.fk_options = {}   # col_name -> [(id, label)]
        self.row_data = {}     # pk_value -> {col: raw_value}

        self._build_ui()
        self._load_fk_lookups()
        self.refresh()

    # ---------------------------------------------------------------- UI
    def _build_ui(self):
        header = ctk.CTkLabel(self, text=self.meta["display_name"],
                              font=ctk.CTkFont(size=22, weight="bold"))
        header.pack(anchor="w", padx=10, pady=(6, 10))

        toolbar = ctk.CTkFrame(self, fg_color="transparent")
        toolbar.pack(fill="x", padx=10)
        ctk.CTkButton(toolbar, text="🔄 Refresh", width=110, command=self.refresh).pack(side="left", padx=4)
        ctk.CTkButton(toolbar, text="➕ Add", width=110, command=self.on_add).pack(side="left", padx=4)
        ctk.CTkButton(toolbar, text="✏️ Edit", width=110, command=self.on_edit).pack(side="left", padx=4)
        ctk.CTkButton(toolbar, text="🗑️ Delete", width=110, fg_color="#a83232",
                      hover_color="#7d2626", command=self.on_delete).pack(side="left", padx=4)

        # Treeview (data grid)
        grid_frame = ctk.CTkFrame(self)
        grid_frame.pack(fill="both", expand=True, padx=10, pady=10)

        # columns shown = every column except the primary key (id hidden)
        self.display_cols = [c for c in self.columns if c["name"] != self.pk]
        col_ids = [c["name"] for c in self.display_cols]

        style = ttk.Style()
        style.theme_use("clam")
        style.configure("Treeview", background="#2b2b2b", foreground="white",
                        fieldbackground="#2b2b2b", rowheight=26, borderwidth=0)
        style.configure("Treeview.Heading", background="#1f6aa5", foreground="white",
                        font=("Segoe UI", 10, "bold"))
        style.map("Treeview", background=[("selected", "#1f6aa5")])

        self.tree = ttk.Treeview(grid_frame, columns=col_ids, show="headings", selectmode="browse")
        for c in self.display_cols:
            self.tree.heading(c["name"], text=c["label"])
            self.tree.column(c["name"], width=140, anchor="w")

        vsb = ttk.Scrollbar(grid_frame, orient="vertical", command=self.tree.yview)
        hsb = ttk.Scrollbar(grid_frame, orient="horizontal", command=self.tree.xview)
        self.tree.configure(yscrollcommand=vsb.set, xscrollcommand=hsb.set)
        self.tree.grid(row=0, column=0, sticky="nsew")
        vsb.grid(row=0, column=1, sticky="ns")
        hsb.grid(row=1, column=0, sticky="ew")
        grid_frame.grid_rowconfigure(0, weight=1)
        grid_frame.grid_columnconfigure(0, weight=1)
        self.tree.bind("<Double-1>", lambda e: self.on_edit())

        self.status = ctk.CTkLabel(self, text="", anchor="w")
        self.status.pack(fill="x", padx=12, pady=(0, 6))

    # ----------------------------------------------------------- lookups
    def _load_fk_lookups(self):
        for col in self.columns:
            if col.get("type") == "fk":
                fk_meta = TABLES[col["fk"]]
                cols, rows = db.fetch_table(fk_meta["label_query"])
                options = [(r[0], str(r[1])) for r in rows]
                self.fk_options[col["name"]] = options
                self.fk_maps[col["name"]] = {rid: lbl for rid, lbl in options}

    # ------------------------------------------------------------ SELECT
    def refresh(self):
        for iid in self.tree.get_children():
            self.tree.delete(iid)
        self.row_data.clear()

        col_names = [c["name"] for c in self.columns]
        query = "SELECT {} FROM {} ORDER BY {}".format(
            ", ".join(col_names), self.table, self.pk)
        try:
            _, rows = db.fetch_table(query)
        except Exception as e:
            messagebox.showerror("Database error", str(e))
            return

        for row in rows:
            raw = dict(zip(col_names, row))
            pk_val = raw[self.pk]
            self.row_data[pk_val] = raw
            values = [self._format(c, raw[c["name"]]) for c in self.display_cols]
            self.tree.insert("", "end", iid=str(pk_val), values=values)

        self.status.configure(text=f"{len(rows)} row(s).  (ids are hidden; foreign keys shown as names)")

    def _format(self, col, value):
        if value is None:
            return ""
        if col.get("type") == "fk":
            return self.fk_maps.get(col["name"], {}).get(value, f"#{value}")
        if col.get("type") == "bool":
            return "Yes" if value else "No"
        return str(value)

    # ---------------------------------------------------- INSERT / UPDATE
    def on_add(self):
        self._open_form(mode="add")

    def on_edit(self):
        sel = self.tree.selection()
        if not sel:
            messagebox.showinfo("Edit", "Please select a row first.")
            return
        pk_val = sel[0]
        # the key identifies the record; the system brings its current fields
        key = self._cast_pk(pk_val)
        self._open_form(mode="edit", pk_value=key, current=self.row_data[key])

    def _cast_pk(self, pk_str):
        # tree iids are strings; the dict keys are the original python values
        for k in self.row_data:
            if str(k) == str(pk_str):
                return k
        return pk_str

    def _open_form(self, mode, pk_value=None, current=None):
        win = ctk.CTkToplevel(self)
        win.title(("Add" if mode == "add" else "Edit") + " - " + self.meta["display_name"])
        win.geometry("460x620")
        win.grab_set()

        title = "New record" if mode == "add" else f"Editing record (key loaded)"
        ctk.CTkLabel(win, text=title, font=ctk.CTkFont(size=18, weight="bold")).pack(pady=10)

        form = ctk.CTkScrollableFrame(win, width=420, height=460)
        form.pack(fill="both", expand=True, padx=10, pady=6)

        widgets = {}  # col_name -> (kind, widget)
        for col in self.columns:
            ctype = col.get("type")
            if ctype == "serial" or col.get("readonly"):
                continue  # auto / computed columns are not user-editable

            lbl_text = col["label"] + (" *" if col.get("required") else "")
            ctk.CTkLabel(form, text=lbl_text, anchor="w").pack(fill="x", padx=8, pady=(8, 0))

            cur_val = current.get(col["name"]) if current else None

            if ctype == "bool":
                var = tk.BooleanVar(value=bool(cur_val))
                w = ctk.CTkCheckBox(form, text="", variable=var)
                w.pack(anchor="w", padx=8)
                widgets[col["name"]] = ("bool", var)

            elif ctype == "fk":
                options = self.fk_options.get(col["name"], [])
                labels = [lbl for _, lbl in options]
                combo = ctk.CTkComboBox(form, values=labels, width=380)
                if cur_val is not None:
                    combo.set(self.fk_maps[col["name"]].get(cur_val, ""))
                elif labels:
                    combo.set("")
                combo.pack(fill="x", padx=8)
                widgets[col["name"]] = ("fk", combo)

            elif col.get("choices"):
                combo = ctk.CTkComboBox(form, values=col["choices"], width=380)
                combo.set(str(cur_val) if cur_val is not None else "")
                combo.pack(fill="x", padx=8)
                widgets[col["name"]] = ("text", combo)

            else:
                entry = ctk.CTkEntry(form, width=380)
                if cur_val is not None:
                    entry.insert(0, str(cur_val))
                entry.pack(fill="x", padx=8)
                widgets[col["name"]] = ("text", entry)

        def do_save():
            data = {}
            for col in self.columns:
                if col["name"] not in widgets:
                    continue
                kind, w = widgets[col["name"]]
                if kind == "bool":
                    data[col["name"]] = w.get()
                elif kind == "fk":
                    label = w.get().strip()
                    chosen = None
                    for rid, lbl in self.fk_options[col["name"]]:
                        if lbl == label:
                            chosen = rid
                            break
                    if chosen is None and col.get("required"):
                        messagebox.showerror("Validation", f"Please choose a value for '{col['label']}'.")
                        return
                    data[col["name"]] = chosen
                else:
                    txt = w.get().strip()
                    if txt == "":
                        if col.get("required"):
                            messagebox.showerror("Validation", f"'{col['label']}' is required.")
                            return
                        data[col["name"]] = None
                    else:
                        data[col["name"]] = txt
            try:
                if mode == "add":
                    self._insert(data)
                else:
                    self._update(pk_value, data)
            except Exception as e:
                messagebox.showerror("Database error", str(e))
                return
            win.destroy()
            self.refresh()
            self._load_fk_lookups()  # in case labels changed

        btns = ctk.CTkFrame(win, fg_color="transparent")
        btns.pack(fill="x", padx=10, pady=8)
        ctk.CTkButton(btns, text="💾 Save", command=do_save).pack(side="left", padx=6)
        ctk.CTkButton(btns, text="Cancel", fg_color="gray", command=win.destroy).pack(side="left", padx=6)

    def _insert(self, data):
        cols = list(data.keys())
        placeholders = ", ".join(["%s"] * len(cols))
        query = "INSERT INTO {} ({}) VALUES ({})".format(
            self.table, ", ".join(cols), placeholders)
        db.execute(query, [data[c] for c in cols])

    def _update(self, pk_value, data):
        sets = ", ".join(f"{c} = %s" for c in data.keys())
        query = "UPDATE {} SET {} WHERE {} = %s".format(self.table, sets, self.pk)
        params = list(data.values()) + [pk_value]
        db.execute(query, params)

    # ------------------------------------------------------------ DELETE
    def on_delete(self):
        sel = self.tree.selection()
        if not sel:
            messagebox.showinfo("Delete", "Please select a row first.")
            return
        if not messagebox.askyesno("Confirm delete", "Delete the selected record?"):
            return
        key = self._cast_pk(sel[0])
        try:
            db.execute(f"DELETE FROM {self.table} WHERE {self.pk} = %s", [key])
        except Exception as e:
            messagebox.showerror("Database error", str(e))
            return
        self.refresh()

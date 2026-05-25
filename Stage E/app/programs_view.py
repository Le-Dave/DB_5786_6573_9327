"""
programs_view.py - "Queries & Programs" screen.

Lets the user run, straight from the GUI:
  * 2 SELECT queries from Stage B (they only use menu tables, still valid
    after the integration).
  * 3 stored programs from Stage D:
      - fn_menu_item_kitchen_stats(menu_item)   [function, returns a row]
      - fn_get_chef_preparations(chef)          [function, returns a REF CURSOR]
      - sp_apply_category_price_increase(cat,%) [procedure, DML + trigger]
"""
import tkinter as tk
from tkinter import ttk, messagebox
import customtkinter as ctk

import db
from schema import TABLES


# ---- Stage B queries (kept identical, only menu tables -> still valid) ------
QUERY_2024 = """
SELECT mi.item_name, mi.price, mc.category_name,
       EXTRACT(YEAR FROM mi.added_date) AS year_added
FROM menu_item mi
JOIN menu_category mc ON mi.category_id = mc.category_id
WHERE EXTRACT(YEAR FROM mi.added_date) = 2024
ORDER BY mi.item_name
LIMIT 100;
"""

QUERY_TOP_CALORIES = """
SELECT mc.category_name,
       ROUND(AVG(mi.calories), 0) AS avg_calories,
       COUNT(mi.menu_item_id) AS total_items
FROM menu_category mc
JOIN menu_item mi ON mc.category_id = mi.category_id
WHERE mi.calories IS NOT NULL
GROUP BY mc.category_name
HAVING COUNT(mi.menu_item_id) >= 1
ORDER BY avg_calories DESC
LIMIT 5;
"""


class ProgramsFrame(ctk.CTkFrame):
    def __init__(self, parent):
        super().__init__(parent, fg_color="transparent")
        self._build_ui()
        self._load_options()

    def _build_ui(self):
        ctk.CTkLabel(self, text="Queries & Programs",
                     font=ctk.CTkFont(size=22, weight="bold")).pack(anchor="w", padx=10, pady=(6, 10))

        # ----- Stage B queries -----
        qbox = ctk.CTkFrame(self)
        qbox.pack(fill="x", padx=10, pady=6)
        ctk.CTkLabel(qbox, text="Stage B - Queries", font=ctk.CTkFont(size=15, weight="bold")).pack(anchor="w", padx=8, pady=4)
        qrow = ctk.CTkFrame(qbox, fg_color="transparent")
        qrow.pack(fill="x", padx=8, pady=4)
        ctk.CTkButton(qrow, text="Menu items added in 2024 (by category)", width=320,
                      command=lambda: self.run_query(QUERY_2024)).pack(side="left", padx=4)
        ctk.CTkButton(qrow, text="Top 5 categories by avg calories", width=300,
                      command=lambda: self.run_query(QUERY_TOP_CALORIES)).pack(side="left", padx=4)

        # ----- Stage D programs -----
        pbox = ctk.CTkFrame(self)
        pbox.pack(fill="x", padx=10, pady=6)
        ctk.CTkLabel(pbox, text="Stage D - Functions & Procedures", font=ctk.CTkFont(size=15, weight="bold")).pack(anchor="w", padx=8, pady=4)

        # function 1 : fn_menu_item_kitchen_stats
        r1 = ctk.CTkFrame(pbox, fg_color="transparent")
        r1.pack(fill="x", padx=8, pady=4)
        ctk.CTkLabel(r1, text="fn_menu_item_kitchen_stats — Menu item:").pack(side="left", padx=4)
        self.cb_item = ctk.CTkComboBox(r1, values=[], width=240)
        self.cb_item.pack(side="left", padx=4)
        ctk.CTkButton(r1, text="Run function", command=self.run_item_stats).pack(side="left", padx=4)

        # function 2 : fn_get_chef_preparations (ref cursor)
        r2 = ctk.CTkFrame(pbox, fg_color="transparent")
        r2.pack(fill="x", padx=8, pady=4)
        ctk.CTkLabel(r2, text="fn_get_chef_preparations — Chef:").pack(side="left", padx=4)
        self.cb_chef = ctk.CTkComboBox(r2, values=[], width=240)
        self.cb_chef.pack(side="left", padx=4)
        ctk.CTkButton(r2, text="Run (ref cursor)", command=self.run_chef_preps).pack(side="left", padx=4)

        # procedure : sp_apply_category_price_increase
        r3 = ctk.CTkFrame(pbox, fg_color="transparent")
        r3.pack(fill="x", padx=8, pady=4)
        ctk.CTkLabel(r3, text="sp_apply_category_price_increase — Category:").pack(side="left", padx=4)
        self.cb_cat = ctk.CTkComboBox(r3, values=[], width=200)
        self.cb_cat.pack(side="left", padx=4)
        ctk.CTkLabel(r3, text="%:").pack(side="left", padx=2)
        self.en_pct = ctk.CTkEntry(r3, width=60)
        self.en_pct.insert(0, "5")
        self.en_pct.pack(side="left", padx=4)
        ctk.CTkButton(r3, text="Run procedure", command=self.run_price_increase).pack(side="left", padx=4)

        # ----- messages -----
        self.msg = ctk.CTkLabel(self, text="", anchor="w", text_color="#7CFC9A")
        self.msg.pack(fill="x", padx=12, pady=(2, 0))

        # ----- results grid -----
        grid_frame = ctk.CTkFrame(self)
        grid_frame.pack(fill="both", expand=True, padx=10, pady=10)
        style = ttk.Style()
        style.theme_use("clam")
        style.configure("Treeview", background="#2b2b2b", foreground="white",
                        fieldbackground="#2b2b2b", rowheight=26)
        style.configure("Treeview.Heading", background="#1f6aa5", foreground="white",
                        font=("Segoe UI", 10, "bold"))
        self.tree = ttk.Treeview(grid_frame, show="headings")
        vsb = ttk.Scrollbar(grid_frame, orient="vertical", command=self.tree.yview)
        self.tree.configure(yscrollcommand=vsb.set)
        self.tree.grid(row=0, column=0, sticky="nsew")
        vsb.grid(row=0, column=1, sticky="ns")
        grid_frame.grid_rowconfigure(0, weight=1)
        grid_frame.grid_columnconfigure(0, weight=1)

    def _load_options(self):
        self.item_opts = self._opts("menu_item")
        self.chef_opts = self._opts("chef")
        self.cat_opts = self._opts("menu_category")
        self.cb_item.configure(values=[l for _, l in self.item_opts])
        self.cb_chef.configure(values=[l for _, l in self.chef_opts])
        self.cb_cat.configure(values=[l for _, l in self.cat_opts])
        if self.item_opts: self.cb_item.set(self.item_opts[0][1])
        if self.chef_opts: self.cb_chef.set(self.chef_opts[0][1])
        if self.cat_opts: self.cb_cat.set(self.cat_opts[0][1])

    def _opts(self, table_key):
        _, rows = db.fetch_table(TABLES[table_key]["label_query"])
        return [(r[0], str(r[1])) for r in rows]

    def _id_for(self, opts, label):
        for rid, lbl in opts:
            if lbl == label:
                return rid
        return None

    # --------------------------------------------------- result display
    def show_results(self, columns, rows, message=""):
        self.tree.delete(*self.tree.get_children())
        self.tree["columns"] = columns
        for c in columns:
            self.tree.heading(c, text=c)
            self.tree.column(c, width=max(120, int(700 / max(len(columns), 1))), anchor="w")
        for row in rows:
            self.tree.insert("", "end", values=["" if v is None else v for v in row])
        self.msg.configure(text=message or f"{len(rows)} row(s) returned.")

    # --------------------------------------------------------- handlers
    def run_query(self, sql):
        try:
            cols, rows = db.fetch_table(sql)
            self.show_results(cols, rows)
        except Exception as e:
            messagebox.showerror("Query error", str(e))

    def run_item_stats(self):
        item_id = self._id_for(self.item_opts, self.cb_item.get())
        if item_id is None:
            return
        try:
            cols, rows = db.fetch_table("SELECT * FROM fn_menu_item_kitchen_stats(%s)", [item_id])
            self.show_results(cols, rows, "fn_menu_item_kitchen_stats executed.")
        except Exception as e:
            messagebox.showerror("Function error", str(e))

    def run_chef_preps(self):
        chef_id = self._id_for(self.chef_opts, self.cb_chef.get())
        if chef_id is None:
            return
        conn = db.get_connection()
        try:
            with conn.cursor() as cur:
                cur.execute("SELECT fn_get_chef_preparations(%s)", [chef_id])
                cur_name = cur.fetchone()[0]
                cur.execute(f'FETCH 50 IN "{cur_name}"')
                cols = [d[0] for d in cur.description]
                rows = cur.fetchall()
            conn.commit()
            self.show_results(cols, rows, "fn_get_chef_preparations executed (ref cursor).")
        except Exception as e:
            messagebox.showerror("Function error", str(e))
        finally:
            conn.close()

    def run_price_increase(self):
        cat_id = self._id_for(self.cat_opts, self.cb_cat.get())
        if cat_id is None:
            return
        try:
            pct = float(self.en_pct.get())
        except ValueError:
            messagebox.showerror("Validation", "Percent must be a number.")
            return
        try:
            notices = db.call_procedure("CALL sp_apply_category_price_increase(%s, %s)", [cat_id, pct])
            text = " ".join(n.strip() for n in notices) or "Procedure executed."
            # show the updated prices of that category
            cols, rows = db.fetch_table(
                "SELECT item_name, price FROM menu_item WHERE category_id = %s ORDER BY item_name",
                [cat_id])
            self.show_results(cols, rows, "✔ " + text)
        except Exception as e:
            messagebox.showerror("Procedure error", str(e))

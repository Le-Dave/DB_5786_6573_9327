"""
main.py - Restaurant Management System GUI (Stage E)
Entry point: login screen -> dashboard -> table CRUD screens + programs screen.

Run with:  python main.py
Requires:  customtkinter, psycopg2-binary  (see requirements.txt)
The PostgreSQL database must be running (docker compose up -d).
"""
import tkinter as tk
from tkinter import messagebox
import customtkinter as ctk

import db
from schema import TABLES, TABLE_ORDER
from crud_view import CrudFrame
from programs_view import ProgramsFrame

ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")


class App(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("Restaurant Management System - Menu & Kitchen")
        self.geometry("1150x720")
        self.minsize(900, 600)
        self.current_frame = None
        self.show_login()

    def _clear(self):
        for w in self.winfo_children():
            w.destroy()

    # ----------------------------------------------------------- LOGIN
    def show_login(self):
        self._clear()
        wrapper = ctk.CTkFrame(self, fg_color="transparent")
        wrapper.place(relx=0.5, rely=0.5, anchor="center")

        card = ctk.CTkFrame(wrapper, width=420, height=420, corner_radius=16)
        card.pack(padx=20, pady=20)
        card.pack_propagate(False)

        ctk.CTkLabel(card, text="🍽️", font=ctk.CTkFont(size=46)).pack(pady=(28, 4))
        ctk.CTkLabel(card, text="Restaurant Management",
                     font=ctk.CTkFont(size=24, weight="bold")).pack()
        ctk.CTkLabel(card, text="Menu & Kitchen - Database Login",
                     font=ctk.CTkFont(size=13), text_color="gray").pack(pady=(0, 18))

        ctk.CTkLabel(card, text="Username", anchor="w").pack(fill="x", padx=40)
        user_e = ctk.CTkEntry(card, width=320, placeholder_text="DB user")
        user_e.insert(0, "MyUser")
        user_e.pack(padx=40, pady=(2, 10))

        ctk.CTkLabel(card, text="Password", anchor="w").pack(fill="x", padx=40)
        pass_e = ctk.CTkEntry(card, width=320, show="•", placeholder_text="DB password")
        pass_e.pack(padx=40, pady=(2, 16))

        info = ctk.CTkLabel(card, text="", text_color="#ff6b6b")
        info.pack()

        def do_login():
            user = user_e.get().strip()
            pwd = pass_e.get()
            try:
                db.try_login(user, pwd)
            except Exception as e:
                info.configure(text="Login failed: check credentials / DB running")
                return
            db.set_credentials(user, pwd)
            self.show_dashboard()

        ctk.CTkButton(card, text="Login", width=320, command=do_login).pack(padx=40, pady=6)
        pass_e.bind("<Return>", lambda e: do_login())

    # ------------------------------------------------------- DASHBOARD
    def show_dashboard(self):
        self._clear()
        self.grid_columnconfigure(1, weight=1)
        self.grid_rowconfigure(0, weight=1)

        # sidebar
        sidebar = ctk.CTkScrollableFrame(self, width=240, corner_radius=0,
                                         label_text="Restaurant System")
        sidebar.grid(row=0, column=0, sticky="nsw")

        ctk.CTkLabel(sidebar, text="— Tables —", text_color="gray").pack(pady=(6, 2))
        for key in TABLE_ORDER:
            ctk.CTkButton(sidebar, text=TABLES[key]["display_name"], anchor="w",
                          fg_color="transparent", hover_color="#2a2d2e",
                          command=lambda k=key: self.open_table(k)).pack(fill="x", padx=6, pady=2)

        ctk.CTkLabel(sidebar, text="— Tools —", text_color="gray").pack(pady=(10, 2))
        ctk.CTkButton(sidebar, text="🔧 Queries & Programs", anchor="w",
                      command=self.open_programs).pack(fill="x", padx=6, pady=2)
        ctk.CTkButton(sidebar, text="🚪 Logout", anchor="w", fg_color="#a83232",
                      hover_color="#7d2626", command=self.show_login).pack(fill="x", padx=6, pady=(10, 2))

        # content area
        self.content = ctk.CTkFrame(self, corner_radius=0)
        self.content.grid(row=0, column=1, sticky="nsew")
        self._welcome()

    def _welcome(self):
        self._clear_content()
        f = ctk.CTkFrame(self.content, fg_color="transparent")
        f.place(relx=0.5, rely=0.45, anchor="center")
        ctk.CTkLabel(f, text="🍽️  Welcome", font=ctk.CTkFont(size=34, weight="bold")).pack()
        ctk.CTkLabel(f, text="Choose a table on the left to manage data,\n"
                            "or open 'Queries & Programs' to run Stage B queries\n"
                            "and Stage D functions / procedures.",
                     font=ctk.CTkFont(size=15), text_color="gray", justify="center").pack(pady=10)

    def _clear_content(self):
        if self.current_frame is not None:
            try:
                self.current_frame.destroy()
            except Exception:
                pass
            self.current_frame = None
        for w in self.content.winfo_children():
            w.destroy()

    def open_table(self, key):
        self._clear_content()
        try:
            self.current_frame = CrudFrame(self.content, key)
            self.current_frame.pack(fill="both", expand=True)
        except Exception as e:
            messagebox.showerror("Error", str(e))

    def open_programs(self):
        self._clear_content()
        try:
            self.current_frame = ProgramsFrame(self.content)
            self.current_frame.pack(fill="both", expand=True)
        except Exception as e:
            messagebox.showerror("Error", str(e))


if __name__ == "__main__":
    app = App()
    app.mainloop()

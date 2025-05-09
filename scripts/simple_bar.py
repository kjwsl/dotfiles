from deps import Dependency
from typing import Dict, Any
import subprocess
import os


class SimpleBar(Dependency):
    """
    SimpleBar dependency class.
    """

    def __init__(self):
        super().__init__("Simple Bar", "latest")

    def install(self) -> None:
        # git clone https://github.com/Jean-Tinland/simple-bar $HOME/Library/Application\ Support/Übersicht/widgets/simple-bar
        print(f"Installing {self.name} version {self.version}...")
        home_dir = os.getenv("HOME")
        if not home_dir:
            print("Error: HOME environment variable is not set.")
            return

        dest_path = os.path.join(home_dir, "Library", "Application Support", "Übersicht", "widgets", "simple-bar")
        res = subprocess.run(
            ["git", "clone", "https://github.com/Jean-Tinland/simple-bar", dest_path])

        if res.returncode != 0:
            print(f"Error installing {self.name}: {res.stderr}")
            return

    def uninstall(self) -> None:
        print(f"Uninstalling {self.name}...")

    def update(self) -> None:
        print(f"Updating {self.name} to version {self.version}...")

    def get_info(self) -> Dict[str, Any]:
        return {
            "name": self.name,
            "version": self.version,
            "description": "SimpleBar is a lightweight status bar for X11.",
        }

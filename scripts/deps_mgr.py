from deps import Dependency
import tools
import inquirer


class DependencyManager:
    """
    Dependency manager class to handle installation, uninstallation, and updating of dependencies.
    """

    def __init__(self):
        self.dependencies = {}

    def add_dependency(self, dependency: Dependency) -> None:
        """
        Add a dependency to the manager.
        """
        self.dependencies[dependency.name] = dependency

    def install_all(self) -> None:
        """
        Install all dependencies.
        """
        for name, dependency in self.dependencies.items():
            quesitons = [
                    inquirer.Confirm('need_install', message=f"Do you want to install {name}?", default=True),
                    ]
            answers = inquirer.prompt(quesitons)

            need_install = answers['need_install'] if answers else False
            if need_install:
                tools.info(f"Installing {name}...")
                dependency.install()

        tools.success("All dependencies installed successfully.")

    def uninstall_all(self) -> None:
        """
        Uninstall all dependencies.
        """
        for name, dependency in self.dependencies.items():
            tools.info(f"Uninstalling {name}...")
            dependency.uninstall()

        tools.success("All dependencies uninstalled successfully.")

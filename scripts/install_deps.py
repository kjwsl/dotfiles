#!/usr/bin/env/ python3

import tools
import inquirer
from deps_mgr import DependencyManager
from simple_bar import SimpleBar

if __name__ == "__main__":
    mgr = DependencyManager()

    mgr.add_dependency(SimpleBar())

    questions = [
        inquirer.List('action',
                      message="What do you want to do?",
                      choices=['install', 'uninstall'],
                      ),
    ]

    answers = inquirer.prompt(questions)
    action = answers['action'] if answers else None

    if action == 'install':
        tools.info("Installing dependencies...")
        mgr.install_all()
    elif action == 'uninstall':
        tools.info("Uninstalling dependencies...")
        mgr.uninstall_all()
    else:
        tools.error("Invalid action. Please choose 'install' or 'uninstall'.")
        exit(1)

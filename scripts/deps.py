#!/usr/bin/env python3

from abc import ABC, abstractmethod

from typing import List, Dict, Any, Optional

class Dependency(ABC):
    """
    Abstract base class for a dependency.
    """

    def __init__(self, name: str, version: str):
        self.name = name
        self.version = version

    @abstractmethod
    def install(self) -> None:
        """
        Install the dependency.
        """
        pass

    @abstractmethod
    def uninstall(self) -> None:
        """
        Uninstall the dependency.
        """
        pass

    @abstractmethod
    def update(self) -> None:
        """
        Update the dependency.
        """
        pass

    @abstractmethod
    def get_info(self) -> Dict[str, Any]:
        """
        Get information about the dependency.
        """
        pass

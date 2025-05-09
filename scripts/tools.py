from rich.console import Console


def info(msg):
    """
    Print an info message.
    """
    console = Console()
    console.print(f"[bold blue][INFO][/bold blue] {msg}")


def warn(msg):
    """
    Print a warning message.
    """
    console = Console()
    console.print(f"[bold yellow][WARNING][/bold yellow] {msg}")


def error(msg):
    """
    Print an error message.
    """
    console = Console()
    console.print(f"[bold red][ERROR][/bold red] {msg}")


def success(msg):
    """
    Print a success message.
    """
    console = Console()
    console.print(f"[bold green][SUCCESS][/bold green] {msg}")

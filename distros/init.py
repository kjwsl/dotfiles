import re
import subprocess as sp

DISTROS = ("ubuntu", "fedora", "arch", "debian", "endeavour")


def main():
    f = open("/etc/os-release", "r")
    distro: str = re.findall(r'"(.*?)"', f.readline())[0].split()[0]

    result = sp.run(f"./{distro.lower()}.sh", shell=True, capture_output=True, text=True)
    print(result)





if __name__ == "__main__":
    main()

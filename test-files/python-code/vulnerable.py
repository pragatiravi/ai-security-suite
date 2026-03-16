import subprocess

password = "123456"  # hardcoded password

def run_command(cmd):
    subprocess.call(cmd, shell=True)

run_command("ls")

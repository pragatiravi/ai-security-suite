import subprocess

def run_cmd(user_input):
    # vulnerable code
    subprocess.call(user_input, shell=True)

run_cmd("ls")

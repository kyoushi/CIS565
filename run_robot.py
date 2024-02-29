import subprocess
import os

def run_robot(name):
    if os.path.exists(name+".robot"):
        process = subprocess.Popen(['robot', name+'.robot'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = process.communicate()
        out = out.decode('UTF-8').rstrip()
        return out
    else:
         return (name+" file for robot testing not found")



auth_output = run_robot("auth")
us_output = run_robot("User_Settings")
ba_output = run_robot("Bank_Account")

full_data = {auth_output, us_output, ba_output}
f = open("Automated_Testing_Report.txt",'w')
for data in full_data:
    split_data = data.split("\n")
    for line in split_data:
        if not line.__contains__(":"):
            f.write(line)
            f.write("\n")

f.close()


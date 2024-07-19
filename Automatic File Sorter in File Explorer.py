import os, shutil    #imports os and shell utilities(used to make changes in a directory)

path = r"C:/Users/Welcome/Music/sample/"   #define which path you want this to run in, r in the front is to take it as raw string and neglect \, /

file_name = os.listdir(path)   #pulls out the file names from the path

folder_names = ['csv files','image files','text files']   #folder names that we will need

#for loop for making directories with the folder names if they are not created initially

for loop in range(0,3):
    if not os.path.exists(path + folder_names[loop]):
        os.makedirs(path + folder_names[loop])
        
#for loop for moving the respective files into the respective folders
        
for file in file_name:
    if ".csv" in file and not os.path.exists(path + "csv files/" + file):
        shutil.move(path + file,path + "csv files/" + file)
    elif ".png" in file and not os.path.exists(path + "image files/" + file):
        shutil.move(path + file,path + "image files/" + file)
    elif ".txt" in file and not os.path.exists(path + "text files/" + file):
        shutil.move(path + file,path + "text files/" + file)



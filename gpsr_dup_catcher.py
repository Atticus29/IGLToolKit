import os
import sys

#############################
##declaring input variables##
#############################
if len(sys.argv) < 1:
    print ("Error: there weren't enough input arguments")
    sys.exit(1)
the_args = sys.argv
lpath = the_args[1]

########
##Main##
########
all_file_list = os.listdir(lpath)
ARR_files = [x for x in all_file_list if x.endswith(".ARR")]

GPSR_name = [x.split('_')[0] for x in ARR_files]
print("GPSR names has ", len(GPSR_name), " items")
unique_GPSR_name = set(GPSR_name)
print("GPSR names has ", len(unique_GPSR_name), " unique items")

user_name = [x.split('_')[2] for x in ARR_files]
print("User ID has ", len(user_name), " items")
unique_user_name = set(user_name)
print("User ID has ", len(unique_user_name), " unique items")


if len(unique_user_name)<len(user_name):
    print(list({x for x in user_name if user_name.count(x) > 1}))
    raise NameError('There is a duplicate!')

if len(unique_GPSR_name)<len(GPSR_name):
    print(list({x for x in GPSR_name if GPSR_name.count(x) > 1}))
    raise NameError('There is a duplicate!')

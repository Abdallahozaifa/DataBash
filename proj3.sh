# /** CMPSC 474 /CMPEN 441
# * Lab 1
# * File Name: proj3.sh
# *
# *Your Name: Hozaifa Abdalla
# *
# *Your PSU user ID:  hea113
# *
# *CMPSC474 Spring 2016 
# *
# *Due Time: 12:00, Thursday, January, 2016
# *
# *Time of Last Modification: 2:50, Thursday, January 24, 2016
# *Academic Integrity Statement: I certify that, while others may have assisted me in brain storming, debugging and validating this program, the program itself is my own work. I understand that submitting code which is the work of other individuals is a violation of the course Academic Integrity
# Policy and may result in a zero credit for the assignment, or course failure and a report to the Academic Dishonesty Board. I also understand that if I knowingly give my original work to another individual that it could also result in a zero credit for the assignment, or course failure and 
# report to the Academic Dishonesty Board. See Academic Integrity Procedural Guidelines at:  
# https://psbehrend.psu.edu/intranet/faculty-resources/academic-integrity/academic-integrity-procedural-guidelines
 
#*Assisted by and Assisted line numbers:
#*/

#!/bin/bash

file=$1
numOfArgs=$#

# validates the amount of arguments that the program needs which is one
function validateNumOfArguments () {
    # if number of arguments is not equal to 1
    if [ $numOfArgs -ne 1 ]; then
        echo "You must enter exactly 1 command line arguments"
    else
        # calls the other functuons if script is executed with correct number of arguments
        fileExist 
        readAndWriteAble 
        menu        
    fi
}

# checks to see if the file that is passed in with executing the script exist
function fileExist () {
    # if the file exist
    if [ -e $file ]
    then
        echo
        echo "**********************************"
        echo "* WELCOME TO HOZAIFA'S WORLD!    *"      
        echo "* The file you provided exists!  *"
    else
        # creates the file if it doesn't exist 
        >$file
        echo "* The File you provided doesn't exist! *"
        echo "* Successfully created the file for you*"
    fi
}

# checks to see if the file is readable and writeable 
function readAndWriteAble () {
    # if the file is readable and writable 
    if [[ -r $file && -w $file ]]
    then
        echo "* File is readable and writable! *"
        echo "**********************************"
        echo "**********************************"
        echo "* Please Enter Your Command!     *"
        echo "**********************************"
        echo
    else
        # if the file is not readable and writable it kills the inner shell and exits program
        echo "File is not readable and writable!"
        echo "Program exiting!"
        kill $$        
        exit
    fi
}

# checks to see if the entry exist 
function entryExist () {
    # if the first name, lastname or both are found in the file
    if egrep -q -wi "$firstName|$lastName" $file
    then 
        echo "******************************************"
        echo "* An Entry with that Name Already Exist! *"
        echo "******************************************"
        echo
        addEntry
    else
        # the firstname and lastname were not found in the file 
        echo "The Entry was added Successfully!"
        echo "******************************************"
        echo "  First Name: $firstName                  "
        echo "  Last Name: $lastName                    "
        echo "  Phone Number: $phoneNumber              "
        echo "  Address: $address                       "
        echo "******************************************"
        echo 
        addEntryToFile $line
    fi
}

# Adds an entry to the file that is provided by the user
function addEntryToFile () {
    echo $line >> $file
}

# Prompts the user for input and asks him to supply the appropriate information
function addEntry () {
    echo "Please type a valid first name and last name:" 
    read firstName lastName
    echo
    echo "Please provide a valid phone number:"
    read phoneNumber
    echo
    echo "Please provide an address:"
    read address
    echo
    # concatenates the users input into one string
    line="$firstName $lastName $phoneNumber $address"
    entryExist $firstName $lastName $phoneNumber $address $line
         
}

# removes the entry from the file
function removeEntryFromFile () {
    sed -i "/$entryToDelete/ d" $file
}

# deletes the entry menu option
function deleteEntry () {
    echo "Please type a valid first name and/or last name:"
    read entryToDelete
    # checks if the entry exist before removing it then removes it
    if grep -q  "$entryToDelete" $file
    then
        echo
        echo "***********************************"
        echo "* Entry was Removed Successfully! *"
        echo "***********************************"
        echo
        removeEntryFromFile $entryToDelete 
    else
        # entry does not exist and tells the user
        echo
        echo "***********************************"
        echo "* That Entry Does not Exist!      *"
        echo "***********************************"
        echo
        deleteEntry      
    fi
}

# handles viewing an entry
function viewEntry () {
    echo "Please type a valid entry to view by first name and/or lastname:"
    fullName=
    # requires the user to input something 
    while [[ $fullName = "" ]]; do
        read fullName
        if [[ $fullName = "" ]];then
            echo "Please provide an entry to view!"
        fi
    done
    # if the entry exist then show it
    if grep -q "$fullName" $file
    then
        echo
        echo "******************************************" 
        grep "$fullName" $file
        echo "******************************************" 
        echo
    else
        # the entry doesn't exist so the user can't view it
        echo
        echo "*************************" 
        echo "* Entry does not exist! *"
        echo "*************************"
        echo
        viewEntry
    fi
}

# exits the current function its in
function exit () {
    return 0
}

# provides the nice graphical user interface for the user
function menu () {
    
    PS3='Please select a command: '
    echo
    options=("Add Entry" "Delete Entry" "View Entry" "Exit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Add Entry")
                echo 
                echo "**********************************"
                echo "* You've Chosen to Add an Entry! *"
                echo "**********************************"
                echo
                addEntry          
                ;;
            "Delete Entry")
                echo
                echo "*************************************"
                echo "* You've Chosen to Remove an Entry! *"
                echo "*************************************"
                echo 
                deleteEntry           
                ;;
            "View Entry")
                echo
                echo "***********************************"
                echo "* You've Chosen to View an Entry! *"
                echo "***********************************"
                echo
                viewEntry
                ;;
            "Exit")
                echo
                echo "***********************************"
                echo "* You've Chosen to Exit!          *"
                echo "* Thank You for Visiting!         *"
                echo "***********************************"
                echo
                break
                ;;
            *) echo invalid option;;
        esac
    done
}
# My Equivalent version of main with 1 method call
validateNumOfArguments  

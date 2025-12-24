#!/bin/bash

main_exit=0

#mainMenu
function main_menu {
    clear
    echo -e "\t\t ---------- MESS MANAGEMENT SYSTEM ----------"
    echo -e "\t\t --------- WELCOME TO THE MAIN MENU ----------"
    
    echo -e "\t\t\t1. Enter new Member's data."
    echo -e "\t\t\t2. Update information."
    echo -e "\t\t\t3. Check the details."
    echo -e "\t\t\t4. Remove member."
    echo -e "\t\t\t5. View all members list."
    echo -e "\t\t\t6. Count per person cost."
    echo -e "\t\t\t7. Check system uptime."
    echo -e "\t\t\t8. Check disk space."
    echo -e "\t\t\t9. Backup records."
    echo -e "\t\t\t10. Restore records."
    echo -e "\t\t\t11. Exit."
    echo -e "\t\t\tEnter your choice:"
    read userchoice
    
    case $userchoice in
        1) entry ;;        
        2) update ;;      
        3) search ;;       
        4) delete ;;       
        5) full_list ;;   
        6) cost_count ;;   
        7) check_uptime ;; 
        8) check_disk_space ;; 
        9) backup_records ;;   
        10) restore_records ;; 
        11) closer ;;      
        *) main_menu ;;   
    esac
}

#add
function entry {
    clear
    echo -e "\t\t\t ADD NEW MEMBER"

    echo "Enter your NID number:"
    read nid_num

    while grep "^$nid_num " rec.dat; do
        echo "Already the Member is registered....."
        echo "Enter your Correct NID number:"
        read nid_num
    done

    echo "Enter The Candidate's Name:"
    read m_name
    echo "Enter The Candidate's Age:"
    read m_age
    echo "Enter The Candidate's City:"
    read m_city
    echo "Enter The Candidate's phone number:"
    read m_phone
    echo "Enter The Candidate's email id:"
    read m_mail_id
    echo "Enter The Candidate's allotted room no.:"
    read a_room_no

    echo "$nid_num $m_name $m_age $m_city $m_phone $m_mail_id $a_room_no" >> rec.dat

    echo "Member Enrolled!"
    echo "Enter 1 to jump to main menu and 0 to exit:"
    read main_exit

    if [[ $main_exit -eq 1 ]]; then
        main_menu
    else
        closer
    fi
}

#viewList
function full_list {
    clear
    echo -e "\nNID NO.\t\tNAME\t\tCity\t\tPHONE\n"
    cat rec.dat | while read line; do
        echo "$line" | awk '{print $1 "\t" $2 "\t\t" $4 "\t\t" $5}'
    done

    echo "Enter 1 to jump to main menu and 0 to exit:"
    read main_exit

    if [[ $main_exit -eq 1 ]]; then
        main_menu
    else
        closer
    fi
}

#searchMember
function search {
    clear
    echo "Choose a searching method:"
    echo "1. By NID no"
    echo "2. By Name"
    echo "Choose an option:"
    read choice
    if [[ $choice -eq 1 ]]; then
        echo "Enter Member's NID number:"
        read m_nid_no
        grep "^$m_nid_no " rec.dat  
    elif [[ $choice -eq 2 ]]; then
        echo "Enter Member's name:"
        read m_name
        grep " $m_name " rec.dat    
    else
        echo "You chose the wrong option!!"
    fi

    echo "0- try again."
    echo "1- Main Menu."
    echo "2- Exit."
    echo "Choose an option:"
    read main_exit

    if [[ $main_exit -eq 1 ]]; then
        main_menu
    elif [[ $main_exit -eq 2 ]]; then
        closer
    else
        search
    fi
}

#updateMember
function update {
    clear
    echo "Enter the selected member's NID:"
    read nid_num
    if ! grep -q "^$nid_num " rec.dat; then
        echo "The member doesn't exist yet!!"
        update
        return
    fi

    echo "Choose the Option to update?"
    echo "1. Room Number."
    echo "2. Mobile"
    echo "Enter your choice:"
    read choice

    old_record=$(grep "^$nid_num " rec.dat)
    new_record=""
    if [[ $choice -eq 1 ]]; then
        echo "Which room do you want to shift to?"
        read m_room_no
        new_record=$(echo "$old_record" | awk -v m_room_no="$m_room_no" '{$7=m_room_no; print}')
    elif [[ $choice -eq 2 ]]; then
        echo "Enter New Mobile Number:"
        read m_phone
        new_record=$(echo "$old_record" | awk -v m_phone="$m_phone" '{$5=m_phone; print}')
    else
        echo "Your Choice is Invalid!!!"
        update
        return
    fi

    sed -i "s/^$old_record$/$new_record/" rec.dat
    echo "Successfully Updated!"

    echo "Enter 0 to try again."
    echo "Enter 1 to return to main menu."
    echo "Enter 2 to exit."
    echo "Choose:"
    read main_exit

    if [[ $main_exit -eq 1 ]]; then
        main_menu
    elif [[ $main_exit -eq 2 ]]; then
        closer
    else
        update
    fi
}

#deleteMember
function delete {
    clear
    echo "Please provide the NID number of the member whose data you want to remove:"
    read nid_num
    if ! grep -q "^$nid_num " rec.dat; then
        echo "Member is not present!"
        delete
        return
    fi

    grep -v "^$nid_num " rec.dat > new.dat
    mv new.dat rec.dat
    echo "The Record has been deleted successfully!"

    echo "Enter 0 to try again."
    echo "Enter 1 to return to main menu."
    echo "Enter 2 to exit."
    echo "Choose:"
    read main_exit

    if [[ $main_exit -eq 1 ]]; then
        main_menu
    elif [[ $main_exit -eq 2 ]]; then
        closer
    else
        delete
    fi
}

#costCount
function cost_count {

    clear
    echo "Write your room rent: "
    read rrent
    echo "Write the total meal cost: "
    read tmcost
    echo "Write the total number of meals: "
    read tmeal
    permcost=$(echo "$tmcost / $tmeal" | bc -l)
    echo "Write the number of meals you ate: "
    read noofmeal

    if (( $(echo "$noofmeal <= 0" | bc -l) )); then
        echo "The total cost of the month: $rrent"
    else
        mcost=$(echo "$permcost * $noofmeal" | bc -l)
        totalbill=$(echo "$mcost + $rrent" | bc -l)
        echo "The total cost of the month: $totalbill"
    fi
    
    echo "Enter 0 to try again."
    echo "Enter 1 to return to main menu."
    echo "Enter 2 to exit."
    echo "Choose:"
    read main_exit

    if [[ $main_exit -eq 1 ]]; then
        main_menu
    elif [[ $main_exit -eq 2 ]]; then
        closer
    else
        cost_count
    fi
}

#uptime
function check_uptime {
    clear
    echo -e "\t\t SYSTEM UPTIME INFORMATION"
    uptime
    echo "Enter 1 to return to the main menu or 0 to exit:"
    read main_exit
    if [[ $main_exit -eq 1 ]]; then
        main_menu
    else
        closer
    fi
}

#diskSpace
function check_disk_space {
    clear
    echo -e "\t\t SYSTEM DISK SPACE INFORMATION"
    df -h | grep '^/dev/'
    echo "Enter 1 to return to the main menu or 0 to exit:"
    read main_exit
    if [[ $main_exit -eq 1 ]]; then
        main_menu
    else
        closer
    fi
}

#backup
function backup_records {
    clear
    echo "Backing up records..."
    cp rec.dat rec_backup.dat
    echo "Backup created successfully as rec_backup.dat!"
    echo "Enter 1 to return to the main menu or 0 to exit:"
    read main_exit
    if [[ $main_exit -eq 1 ]]; then
        main_menu
    else
        closer
    fi
}

#restoreBackup
function restore_records {
    clear
    if [[ -f rec_backup.dat ]]; then
        cp rec_backup.dat rec.dat
        echo "Records restored successfully from backup!"
    else
        echo "Backup file not found!"
    fi
    echo "Enter 1 to return to the main menu or 0 to exit:"
    read main_exit
    if [[ $main_exit -eq 1 ]]; then
        main_menu
    else
        closer
    fi
}


function closer {
    clear
    echo -e "\n ~~ Project by Sohail ~~ \n"
    exit 0
}

#login
function pass {
    b=0
    while (( b<=2 )); do
        clear
        echo -e "\n\t\t\t\t********* LOGIN FORM  *******  "
        echo -e " \n\t\t\t\t      ENTER USERNAME:"
        read uname
        echo -e " \n\t\t\t\t      ENTER PASSWORD:"
        read -s pword
        if [[ "$uname" == "Sohail" && "$pword" == "103" ]]; then
            echo -e "   \n\n\n                WELCOME!!! Congratulations!! LOGIN IS SUCCESSFUL  \n"
            read -p "Press any key to continue....." -n1 -s
            break
        else
            echo -e "\n                       SORRY!! WRONG INFO!! LOGIN IS UNSUCCESSFUL \n"
            read -p "Press any key to continue....." -n1 -s
            b=$((b+1))
        fi
    done
    if (( b>2 )); then
        echo -e "\nSorry you entered the invalid username and password three times!!!"
        read -p "Press any key to exit..." -n1 -s
        exit 1
    fi
}

pass  
main_menu  


import psycopg2
from os import system, name

import time
import msvcrt

Host = 'localhost'
Database = 'hotel_management'
User = 'postgres'
Password='admin_passwd' #whatever is the password for ur DB
PORT = '5432'

DBA_query_pass = 'dbms123' # for user select queries

def clear_screen():
    if name == 'nt': #for windows appliation
        temp = system('cls')
    else:
        temp = system('clear')

def loading(time_quantum = 8):                                  #make a function called loading
    spaces = 0  
    print("Loading", end="")     

    while time_quantum:                                     
        print(""*spaces+".", end="", flush=True) 
        spaces = spaces+1                          
        time.sleep(0.2)                           
        if (spaces>5):                              
            print("\b \b"*spaces, end="")          
            spaces = 0  
        time_quantum-=1                           

def verify_user():
    print("\nPlease enter the DBA pass code: ", end="")
    input_pass = ''
    while True:
        char = msvcrt.getch().decode('utf-8')
        if(char == '\r' or char == '\n'):
            break
        if(char == '\b'):
            if len(input_pass) > 0:
                input_pass = input_pass[:len(input_pass)-1]
                print('\b \b', end="", flush=True)
        else:
            print('*', end='', flush=True)
            input_pass += char

    return input_pass == DBA_query_pass

def python_Backend_to_frontend(query):
    conn = None
    rows = None
    try:
        conn = psycopg2.connect(host=Host,database=Database,user=User,password=Password, port=PORT)

        cur = conn.cursor()
        cur.execute(query)
        rows = cur.fetchall()

        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print()
        print('?'*99)
        print(error)
        print('?'*99)
    finally:
        if conn is not None:
            conn.close()

    if rows:
        return rows
    else:
        return -1


class Switch:   
    def __init__(self, name) -> None:
        self.switchName = name 
        self.index = 0

    def choice(self, opt):
        self.index = opt

        if(self.index > len(allMenus.get(self.switchName))):
            self.index = 0

        default = "Invalid option!"

        return getattr(self, 'case_' + str(self.index), lambda: default)()

    def case_0(self): 
        print("\nPlease enter valid choice")

    def case_1(self):
        allMenus.get(self.switchName)[self.index]()
    
    def case_2(self):
        allMenus.get(self.switchName)[self.index]()

    def case_3(self): 
        allMenus.get(self.switchName)[self.index]()
    
    def case_4(self): 
        allMenus.get(self.switchName)[self.index]()

    def case_5(self):
        allMenus.get(self.switchName)[self.index]()

    def case_6(self): 
        allMenus.get(self.switchName)[self.index]()
    
    def case_7(self): 
        allMenus.get(self.switchName)[self.index]()

    def case_8(self):
        allMenus.get(self.switchName)[self.index]()

    def case_9(self): 
        allMenus.get(self.switchName)[self.index]()
    
    def case_10(self): 
        allMenus.get(self.switchName)[self.index]()


def endQuery():
    print("\nThanks for visiting.\n")
    quit()

def backToHome():
    mainLoop()

# Simple Query functions

def get_all_employee():
    options = ['emp_id', 'EFname', 'ELname', 'Ephno', 'Eaddr', 'Eemail', 'salary', 'Dno']
    
    print('''\nWhat do you want to view?\n[0: 'emp_id', 1: 'EFname', 2: 'ELname', 3: 'Ephno', 4: 'Eaddr', 5: 'Eemail', 6: 'salary', 7: 'Dno']\n''')
    index = list(map(int, input('''Enter space seperated integers: ''').split()))
    
    what = '' 
    what_list = []
    for i in index:
        if i >= 0 and i < len(options):
            what_list.append(options[i])

    what = ','.join(what_list)

    if len(what) <= 0:
        what = '*'
    query = '''SELECT ''' + what + ''' FROM EMPLOYEE;'''

    result = python_Backend_to_frontend(query)

    if result == -1:
        print('An error occured...\nPlease try again after some time...\n')
    else:
        print("\n********************************* Employees working Hotel *************************************\n")

        for row in result:
            print(row)
        
        print("\n****************************** Retrieved all records *********************************\n")
        
    input('Hit ENTER to continue...')


def get_all_guest():

    query = '''SELECT* FROM GUESTS;'''

    result = python_Backend_to_frontend(query)

    if result == -1:
        print('An error occured...\nPlease try again after some time...\n')
    else:
        print("\n********************************* Guest in Hotel ************************************\n")

        for row in result:
            print(row)
        
        print("\n****************************** Retrieved all records *********************************\n")
        
    input('Hit ENTER to continue...')

def find_emp_on_salary():
    sal = input('Enter salary threshold to search, ')
    find_employee(sal)

def get_rooms():
    isPet = input('Are u looking for pet friendly room? (y/n) ')
    if(isPet == 'y'):   
        pet = 1
    else:
        pet = 0
        
    find_rooms_petfriendly(pet)

def find_rooms_petfriendly(pet):
    conn = None
    try:
        conn = psycopg2.connect(host=Host,database=Database,user=User,password=Password, port=PORT)
        
        print("\n****************** Rooms type List *********************\n")

        cur = conn.cursor()
        cur.execute('''SELECT type_id,room_name,pet_friendly FROM room_type WHERE pet_friendly= ''' + str(pet) + ''' ORDER BY type_id;''')
        rows = cur.fetchall()

        for row in rows:
            print(row)
        
        print("\n*************** Retrieved all record******************\n")
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

    input('Hit ENTER to continue...')

def find_employee(salary):
    conn = None
    try:
        conn = psycopg2.connect(host=Host,database=Database,user=User,password=Password, port=PORT)
        
        print("\n****************** Employee Record *********************\n")

        cur = conn.cursor()
        cur.execute('''SELECT* FROM employee WHERE salary > ''' + salary + ''';''')
        rows = cur.fetchall()

        for row in rows:
            print(row)
        
        print("\n*************** Retrieved all record******************\n")
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

    input('Hit ENTER to continue...')

#  Simple Query functions Ends

#  Nested Query functions Starts


def get_Emp_by_mgr():
    id = input('Enter manager SSN to find employee under him ')        
    find_employee_by_mgr(id)

def find_employee_by_mgr(mgr_id):
    query = '''SELECT efname, elname FROM EMPLOYEE WHERE (SELECT mgr_ssn FROM DEPARTMENT WHERE dnumber = dno) =''' + str(mgr_id) + ''';'''
    result = python_Backend_to_frontend(query)
    if result == -1:
        print('An error occured...\nPlease try again after some time...\n')
    else:
        if(len(result) > 0):
            print("\n********************** Employee having Minimum Salary *******************************\n")

            for row in result:
                print(row)
            
            print("\n****************************** Retrieved all records *********************************\n")
        else:
            print("\nNO Records found in DataBase\n")
        
    input('Hit ENTER to continue...')


def guest_with_visa():
    conn = None
    try:
        conn = psycopg2.connect(host=Host,database=Database,user=User,password=Password, port=PORT)
        
        print("\n****************** Guest List using VISA *********************\n")

        cur = conn.cursor()
        cur.execute('''SELECT gfname,glname,credit_info FROM guests WHERE credit_info='visa' ORDER BY gfname;''')
        rows = cur.fetchall()

        for row in rows:
            print(row)
        
        print("\n******************* Retrieved all record******************\n")
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

    input('Hit ENTER to continue...')

def roomCount_with_type():
    conn = None
    try:
        conn = psycopg2.connect(host=Host,database=Database,user=User,password=Password, port=PORT)
        
        print("\n****************** Rooms count with room type *********************\n")

        cur = conn.cursor()
        cur.execute('''SELECT rooms.room_no, COUNT(rooms.r_type) AS COUNT from rooms GROUP BY rooms.room_no;''')
        rows = cur.fetchall()

        for row in rows:
            print(row)
        
        print("\n******************* Retrieved all record******************\n")
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

    input('Hit ENTER to continue...')


def get_emp_minSalary():
    query = '''SELECT emp_id, CONCAT(EFname, ' ', ELname) AS Name, salary FROM employee WHERE salary = (SELECT MIN(SALARY) FROM employee);'''

    result = python_Backend_to_frontend(query)

    if result == -1:
        print('An error occured...\nPlease try again after some time...\n')
    else:
        print("\n********************** Employee having Minimum Salary *******************************\n")

        for row in result:
            print(row)
        
        print("\n****************************** Retrieved all records *********************************\n")
        
    input('Hit ENTER to continue...')


def get_emp_maxSalary():
    query = '''SELECT emp_id, CONCAT(EFname, ' ', ELname) AS Name, salary FROM employee WHERE salary > ALL(SELECT AVG(SALARY) FROM employee GROUP BY Dno);'''

    result = python_Backend_to_frontend(query)

    if result == -1:
        print('An error occured...\nPlease try again after some time...\n')
    else:
        print("\n***************** Employee having Salary more than average salary of all department ****************************\n")

        for row in result:
            print(row)
        
        print("\n****************************************** Retrieved all records ***********************************************\n")
        
    input('Hit ENTER to continue...')

#   Nested Query functions Ends


def order_more_than_x():
    threshold_capacity = input("Enter the capacity threshold: ")
    if(threshold_capacity.isnumeric() == False):
        print('\nInvalid capacit value ( it must be INT)...\n')
    else:
        threshold_capacity = int(threshold_capacity)
        query = '''SELECT order_fname, order_lname FROM orders WHERE capacity>=''' + str(threshold_capacity) + ''';'''
    
        result = python_Backend_to_frontend(query)
        if result == -1:
            print('An error occured...\nPlease try again after some time...\n')
        else:
            print("\n******************************** Order details ************************************\n")

            for row in result:
                print(row)
            
            print("\n*************************** Retrieved all records ********************************\n")
            
    input('Hit ENTER to continue...')

def checkinOut():
    duration = input('Enter duration of stay: ')
    checkinOut_list(duration)

def checkinOut_list(duration):
    conn = None
    try:
        conn = psycopg2.connect(host=Host,database=Database,user=User,password=Password, port=PORT)
        
        print("\n****************** Check IN/OUT within duration *********************\n")

        cur = conn.cursor()
        cur.execute('''SELECT checkin, checkout FROM bookings where dur_of_stay < ''' + str(duration) + ''';''')
        rows = cur.fetchall()

        for row in rows:
            print(row)
        
        print("\n******************* Retrieved all record******************\n")
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

    input('Hit ENTER to continue...')

def user_query():
    auth = verify_user()
    if auth == 0:
        print("\nInvalid password entered!!!")
    else:
        print()
        query = input("Enter your query: ")

        result = python_Backend_to_frontend(query)

        if result == -1:
            print('\nAn error occured...\tPlease try again after some time...\n')
        else:
            print("\n********************************* Query Output ************************************\n")

            for row in result:
                print(row)
            
            print("\n****************************** Retrieved all records *********************************\n")
            
    input('Hit ENTER to continue...')



def MENU():
    border_length = 99
    menu = ""
    
    #Heading
    Heading = ""
    Heading += "*" * border_length
    Heading += "\n\t\t\t\tWelcome to our Hotel DataBase\n\n"
    Heading += "*" * border_length

    #body
    Body = ""
    Body += "\nAvailable Queries:\n"
    Body += "\t1: Complex query menu\n"
    Body += "\t2: Nested query menu\n"
    Body += "\t3: Simple query menu\n"
    Body += "\t4: Query by DBA\n"
    Body += "\t5: QUIT\n"

    Body += "\n\nPlease select your query:\t"

    menu = Heading + Body
    return menu

def complex_query():
    border_length = 99
    border_symbol = '~'
    menu = ""
    
    #Heading
    Heading = ""
    Heading += border_symbol * border_length
    Heading += "\n\t\t\t\tPerform Complex queries\n\n"
    Heading += border_symbol * border_length

    #body
    Body = ""
    Body += "\nAvailable Queries:\n"
    Body += "\t1: Select orders whose capacity more than given threshold\n"
    Body += "\t2: Select check IN/OUT details within given stay duration \n"
    Body += "\t3: BACK\n"

    Body += "\n\nPlease select your query:\t"


    menu = Heading + Body
    return menu

def nested_query():
    border_length = 99
    border_symbol = '>'
    menu = ""
    
    #Heading
    Heading = ""
    Heading += border_symbol * border_length
    Heading += "\n\t\t\t\tPerform Nested queries\n\n"
    Heading += border_symbol * border_length

    #body
    Body = ""
    Body += "\nAvailable Queries:\n"
    Body += "\t1: List employee under manager (using mgr_ssn)\n"
    Body += "\t2: List guest using VISA\n"
    Body += "\t3: Get the name and ID of employee having minimum salary.\n"
    Body += "\t4: Employee having salary more than average salary of all departments.\n"
    Body += "\t5: BACK\n"

    Body += "\n\nPlease select your query:\t"


    menu = Heading + Body
    return menu


def simple_query():
    border_length = 99
    border_symbol = '-'
    menu = ""
    
    #Heading
    Heading = ""
    Heading += border_symbol * border_length
    Heading += "\n\t\t\t\tPerform Simple queries\n\n"
    Heading += border_symbol * border_length

    #body
    Body = ""
    Body += "\nAvailable Queries:\n"
    Body += "\t1: List all Employees in our Hotel\n"
    Body += "\t2: Select all employees whose salary is more than threshold\n"
    Body += "\t3: Select all rooms types available (based on pet friendliness)\n"
    Body += "\t4: List all Guests in our Hotel\n"
    Body += "\t5: List room count with room_type\n"
    Body += "\t6: BACK\n"

    Body += "\n\nPlease select your query:\t"


    menu = Heading + Body
    return menu

allMenus = dict()


def complex_loop():
    allMenus['complexLoop'] = ['', order_more_than_x, checkinOut, backToHome]

    while True:
        # main menu of database
        loading(10)
        clear_screen()

        print(complex_query())

        option = input()
        if(option.isnumeric() == False):
            option = -1
        else:
            option = int(option)
    
        menuSwitch = Switch('complexLoop')
        menuSwitch.choice(option)
        
def nested_q_loop():
    allMenus['nestedLoop'] = ['', get_Emp_by_mgr, guest_with_visa, get_emp_minSalary, get_emp_maxSalary, backToHome]

    while True:
        # main menu of database
        loading(12)

        clear_screen()
        print(nested_query())

        option = input()
        if(option.isnumeric() == False):
            option = -1
        else:
            option = int(option)
        
        menuSwitch = Switch('nestedLoop')
        menuSwitch.choice(option)
   
def simple_q_loop():
    allMenus['simpleLoop'] = ['', get_all_employee, find_emp_on_salary, get_rooms, get_all_guest, roomCount_with_type, backToHome]
    while True:
        # main menu of database
        loading(5)

        clear_screen()
        print(simple_query())

        option = input()
        if(option.isnumeric() == False):
            option = -1
        else:
            option = int(option)

        menuSwitch = Switch('simpleLoop')
        menuSwitch.choice(option)



def mainLoop():
    allMenus['mainLoop'] = ['', complex_loop, nested_q_loop, simple_q_loop, user_query, endQuery]
    while True:
        # main menu of database
        loading()
        clear_screen()

        print(MENU())

        option = input()

        #validate
        if(option.isnumeric() == False):
            option = 0
        else:
            option = int(option)

        menuSwitch = Switch('mainLoop')
        menuSwitch.choice(option)

        


if __name__ == "__main__":
    mainLoop()
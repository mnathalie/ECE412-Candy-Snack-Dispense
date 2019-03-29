	

import tkinter as tk
#GPIO library Controls for the GPIO Pins
#import Tkinter as tk 
#import RPi.GPIO as GPIO
#from time import sleep

#Defining the text size
LARGE_FONT= ("Verdana", 12)
SMALL_FONT= ("Verdana", 8)
#Defining the SeaofBTCapp class and inheriting everything from the tk.Tk class
class SeaofBTCapp(tk.Tk):
    
# "args" and "kwargs" Are used to pass a variable, unknown, amount of arguments through the method=_init_
#args are used to pass non-keyworded arguments, where kwargs are keyword arguments. Args are your typical parameters.
#Kwargs are basically be dictionaries.


    def __init__(self, *args, **kwargs):
        # initializing the inherited class
        tk.Tk.__init__(self, *args, **kwargs)
        container = tk.Frame(self)
    #This container is filled with a bunch of frames that can accessed later on
        container.pack(side="top", fill="both", expand = True)

        container.grid_rowconfigure(0, weight=1)
        container.grid_columnconfigure(0, weight=1)

        self.frames = {}

        for F in (StartPage, SettingsPage, TestingPage):

            frame = F(container, self)

            self.frames[F] = frame
#NSEW=North/SOuth/East/West placement
            frame.grid(row=0, column=0, sticky="nsew")
#we call show_frame to bring the frame of our choosig up
        self.show_frame(StartPage)

    def show_frame(self, cont):
#define frame to be self.frame followed by the controller
        frame = self.frames[cont]
#bring frame to the top
        frame.tkraise()

#working on this part
        #GPIO21 = 21
        #GPIO.setmode(GPIO21, GPIO.OUT)
        #def GPIO21button():
          
        #if GPIO21 == True:
                #GPIO.output(GPIO21)
           # if GPIO21 == False:
                #
        #else:
            
                
 
        #Main Home Page         
class StartPage(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self,parent)

        #Nameing the Title page "HOME PAGE" with a given front size
        label = tk.Label(self, text="HOME PAGE", font=LARGE_FONT)
        #
        label.pack(pady=10,padx=10)
        #Nameing the  1st button Dispense Candy
        button = tk.Button(self, text="Dispense Candy")
        button.pack()

        #Nameing the 2nd button Settings
        button1 = tk.Button(self, text="Settings",
        #When selecting button #2 go to Page called Settings
                            command=lambda: controller.show_frame(SettingsPage))
        button1.pack()

        button2 = tk.Button(self, text="Testing",
                            command=lambda: controller.show_frame(TestingPage))
        button2.pack()

# SettingsPage class, inheriting from tk.Frame
class SettingsPage(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        #self.radio_variable = tk.StringVar()
        #self.radio_variable.set("0")
        
#HELP NEEDED!!!!!!!!!!!!!!!!!!!!
        def validate():
    value = self.option.get()
    if value == "small":
        print("Small Amount Dispensing")
    elif value == "medium":
        print("Medium Amount Dispensing")
    else:
        print("An option must be selected")

        self.option = tk.StringVar()
        
    Rad1 = tk.Radiobutton(self, text="SMALL", value="small", variable=self.option)
    Rad1.pack()
    Rad2 = tk.Radiobutton(self, text="MEDIUM", value="medium", variable=self.option)
    Rad2.pack()
    button = Button(self, text="Save", command=validate)
    button.pack()
        #Label widget
        label = tk.Label(self, text="Setting", font=LARGE_FONT)
        #.pack organizes widget in blocks using x and y axis
        label.pack(pady=10,padx=10)

        label = tk.Label(self, text="Select Amount of Candy to Dispense", font=SMALL_FONT)
        label.pack(pady=10,padx=10)

        #1st Radio Button
        #Rad1 = tk.Radiobutton(self, text="Small Amount", padx = 20, variable=self.radio_variable,value=1).pack(anchor=tk.W)  
        
        #2nd Radio Button
       # Rad2 = tk.Radiobutton(self, text="Medium Amount", padx = 20, variable=self.radio_variable,value=2).pack(anchor=tk.W)

        #3rd Radio Button  
        #Rad3 = tk.Radiobutton(self, text="Large Amount", padx = 20, variable=self.radio_variable,value=3).pack(anchor=tk.W) 
        
        #1st Button check save and do stuff
        #button3 = tk.Button(self, text="Save")
       # button3.pack()
        
        #2nd Button when click will take you back to the home page
        #button4 = tk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        #button4.pack()



class TestingPage(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self, parent)
        
        label = tk.Label(self, text="Testing", font=LARGE_FONT)
        label.pack(pady=10,padx=10)

        label = tk.Label(self, text="Select Stepper Motor Acceleration", font=SMALL_FONT)
        label.pack(pady=10,padx=10)


        self.radio_variable = tk.StringVar()
        self.radio_variable.set("0")



        #1st Radio Button
        Rad1 = tk.Radiobutton(self, text="Slow", padx = 20, variable=self.radio_variable,value=4).pack(anchor=tk.W)
                                 #add when using GPIO, command=GPIO21Buttton)
        #2nd Radio Button
        Rad2 = tk.Radiobutton(self, text="Medium", padx = 20, variable=self.radio_variable,value=5).pack(anchor=tk.W)
        #3rd Radio Button      
        Rad3 = tk.Radiobutton(self, text="Fast", padx = 20, variable=self.radio_variable,value=6).pack(anchor=tk.W)        

        label = tk.Label(self, text="Select DC Motor Acceleration", font=SMALL_FONT)
        label.pack(pady=10,padx=10)

        #1st Radio Button
        Rad1 = tk.Radiobutton(self, text="Turn Right", padx = 20, variable=self.radio_variable,value=7).pack(anchor=tk.W)
        #2nd Radio Button   
        Rad2 = tk.Radiobutton(self, text="Turn Left",  padx = 20, variable=self.radio_variable,value=8).pack(anchor=tk.W)
        
        label = tk.Label(self, text="Select Other Motor ", font=SMALL_FONT)
        label.pack(pady=10,padx=10)

       #1st Radio Button
        Rad1 = tk.Radiobutton(self, text="Open", padx = 20, variable=self.radio_variable,value=9).pack(anchor=tk.W)
        
        #2nd Radio Button
        Rad2 = tk.Radiobutton(self, text="Close", padx = 20, variable=self.radio_variable,value=10).pack(anchor=tk.W)

        button4 = tk.Button(self, text="Save")
        button4.pack()

        button5 = tk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button5.pack()
        


app = SeaofBTCapp()
app.mainloop()












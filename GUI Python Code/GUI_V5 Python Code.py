	

import tkinter as tk
        
from tkinter import *      
root = Tk()
#GPIO library Controls for the GPIO Pins
#import Tkinter as tk 
#import RPi.GPIO as GPIO
#from time import sleep

#Defining the text size
LARGE_FONT= ("Verdana", 12)
SMALL_FONT= ("Verdana", 8)
#Defining the SeaofBTCapp class and inheriting everything from the tk.Tk
class SeaofBTCapp(tk.Tk):
    
# "args" is short for arguments, allow the passage of variables
# Kwargs allows you to pass through dictionaries and chords

#Init method is going to initialize with the class
    def __init__(self, *args, **kwargs):
        # initializing tkinter
        tk.Tk.__init__(self, *args, **kwargs)
        #contains everything in tkinter app
        container = tk.Frame(self)
        #pack just packs stuff in.
        #Top; fill: fills in the space allocated to pack; expand= if there is space beyond the spcae
        container.pack(side="top", fill="both", expand = True)
        #Configuation
        #0= set minum size
        #1= only one prioority for both
        container.grid_rowconfigure(0, weight=1)
        container.grid_columnconfigure(0, weight=1)
#new dictionary that is emplty
        self.frames = {}
# For Frame in StartPage,SeetingsPage, and TestingPage
        for F in (StartPage, SettingsPage, TestingPage):

            frame = F(container, self)

            self.frames[F] = frame
#assigning a Frame to the grid on row  0 coulum 0
            frame.grid(row=0, column=0, sticky="nsew")
#show frame StartPage
        self.show_frame(StartPage)
#define show_frame
    def show_frame(self, cont):
#define frame to be self.frame followed by the controller
        frame = self.frames[cont]
#bring frame to the top
        frame.tkraise()


                     
canvas = Canvas(root, width = 600, height = 300)      
canvas.pack()      
img = PhotoImage(file="lattice.ppm")
canvas.create_image(20,20, anchor=NW, image=img)      
#canvas.get_tk_widget().pack(side=tk.BOTTOM, fill=tk.BOTH, expand=True)



        


 
def qf(quickPrint):
        print(quickPrint)

        #Main Home Page         
class StartPage(tk.Frame):

    def __init__(self, parent, controller):
        tk.Frame.__init__(self,parent)

        #Nameing the Title page "HOME PAGE" with a given front size
        label = tk.Label(self, text="HOME PAGE", font=LARGE_FONT)
        #
        label.pack(pady=10,padx=10)
        #Nameing the  1st button Dispense Candy
        button = tk.Button(self, text="Dispense Candy",
                command=lambda: qf("Dispensing!"))
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
        #v = 

        self.radio_variable = tk.StringVar()
        self.radio_variable.set("0")
        #Label widget
        label = tk.Label(self, text="Settings", font=LARGE_FONT)
        #.pack organizes widget in blocks using x and y axis
        label.pack(pady=10,padx=10)

        label = tk.Label(self, text="Select Amount of Candy to Dispense", font=SMALL_FONT)
        label.pack(pady=10,padx=10)

        #1st Radio Button
        Rad1 = tk.Radiobutton(self, text="Small Amount", padx = 20, variable=self.radio_variable,value=1,
                         command=lambda: qf("Small Amount"))
        Rad1.pack(anchor=tk.W)
        
        #2nd Radio Button
        Rad2 = tk.Radiobutton(self, text="Medium Amount", padx = 20, variable=self.radio_variable,value=2,
                            command=lambda: qf("Medium Amount"))
        Rad2.pack(anchor=tk.W)
        #3rd Radio Button  
        Rad3 = tk.Radiobutton(self, text="Large Amount", padx = 20, variable=self.radio_variable,value=3,
                            command=lambda: qf("Large Amount"))
        Rad3.pack(anchor=tk.W)
        #1st Button check save and do stuff
        button3 = tk.Button(self, text="Save")
        button3.pack()
        
        #2nd Button when click will take you back to the home page
        button4 = tk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button4.pack()



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
        
        label = tk.Label(self, text="Select Servo Motor ", font=SMALL_FONT)
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
mainloop()





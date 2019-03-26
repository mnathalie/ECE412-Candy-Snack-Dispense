	

import tkinter as tk


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
        #Label widget
        label = tk.Label(self, text="Setting", font=LARGE_FONT)
        #.pack organizes widget in blocks using x and y axis
        label.pack(pady=10,padx=10)

        label = tk.Label(self, text="Select Amount of Candy to Dispense", font=SMALL_FONT)
        label.pack(pady=10,padx=10)

        #1st Check Button
        button = tk.Checkbutton(self, text="Small Amount")            
        button.pack()
        
        #2nd Check Button
        button1 = tk.Checkbutton(self, text="Medium Amount")
        button1.pack()

        #3rd Check Button  
        button2 = tk.Checkbutton(self, text="Large Amount")
        button2.pack()
        
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


        button1 = tk.Checkbutton(self, text="Slow")
        button1.pack()
        #If slow is choosen then do somthing

        button2 = tk.Checkbutton(self, text="Medium")
        button2.pack()
        
        button3 = tk.Checkbutton(self, text="Fast")
        button3.pack()
        


        label = tk.Label(self, text="Select DC Motor Acceleration", font=SMALL_FONT)
        label.pack(pady=10,padx=10)


        button1 = tk.Checkbutton(self, text="Turn Right")
        button1.pack()

        button2 = tk.Checkbutton(self, text="Turn Left")
        button2.pack()
        


        label = tk.Label(self, text="Select Other Motor ", font=SMALL_FONT)
        label.pack(pady=10,padx=10)


        button1 = tk.Checkbutton(self, text="Open")
        button1.pack()

        button2 = tk.Checkbutton(self, text="Close")
        button2.pack()
        
    



        button4 = tk.Button(self, text="Save")
        button4.pack()
        

        button5 = tk.Button(self, text="Back to Home",
                            command=lambda: controller.show_frame(StartPage))
        button5.pack()
        


app = SeaofBTCapp()
app.mainloop()

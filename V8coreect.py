from tkinter import *
from tkinter import ttk
#import RPi.GPIO as GPIO
#import time
#GPIO.setwarnings(False)
#GPIO.setmode(GPIO.BCM)

#GPIO.setup(23, GPIO.OUT)
#GPIO.setup(24, GPIO.OUT)
#GPIO.setup(25, GPIO.OUT)


SMALL_FONT = ("Verdana", 10)
MEDIUM_FONT = ("Verdana", 14)
LARGE_FONT = ("Verdana", 25)


#----------------------------------------------------------------
class MyApp(Tk):

    def __init__(self):
        Tk.__init__(self)
        container = ttk.Frame(self)                             
        container.pack(side="top", fill="both", expand = True)  #Packing on top and fill all space
        self.frames = {}                                        #empty dictionary 
        for F in (PageOne, PageTwo, PageThree, Password):       #populate this tuple with all of the possible pages to our application
            frame = F(container, self)                          #StartPage to show first, but later we can call upon show_frame 
            self.frames[F] = frame                              #to raise any other frame/window that we please.
            frame.grid(row=0, column=0, sticky = NSEW)
        self.show_frame(PageOne)

    def show_frame(self, cont):
        frame = self.frames[cont]
        frame.tkraise()
        
    def get_page(self, classname):
        '''Returns an instance of a page given it's class name as a string'''
        for page in self.frames.values():
            if str(page.__class__.__name__) == classname:
                return page
        return None
#--------------------------------------------------------------------------    
            
class PageOne(ttk.Frame):
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        ttk.Label(self, text='Home Page', font=LARGE_FONT).grid(padx=350, pady=0)     #PageOne = Homepage
        self.make_widget(controller)

        canvas = Canvas(self, width = 650, height = 300)                              #Canvas size for the picture
        canvas.grid()
        image = PhotoImage(file="lattice.png")                                        #Retrieving Picture From 
        canvas.create_image(50, 100, image=image, anchor=W)
        canvas.image = image                                                          #Saves a reference to the image

    def make_widget(self, controller):
        self.v = StringVar()
        self.v.set("a")

        ttk.Style().configure('black/orange.TLabel', font=MEDIUM_FONT, foreground='black', background='orange')
        
        button1 = ttk.Button(self, text="Dispensing", style='black/orange.TLabel',command=self.validate)  #Button for Dispensing
        button1.grid(pady=10)

        button2 = ttk.Button(self, text='Settings',style='black/orange.TLabel',                           #Button for Settings
                              command=lambda: controller.show_frame(PageTwo))
        button2.grid(pady=10)
        
       #button3 = ttk.Button(self, text='Testings',style='black/orange.TLabel',                           #Orginal Button for Testing
                          #   command=lambda: controller.show_frame(PageThree))
       #button3.grid(pady=10)
        
        button4 = ttk.Button(self, text='TestingPage with login screen',style='black/orange.TLabel',      #Testing Button for Testing if pressed go to password page
                              command=lambda: controller.show_frame(Password))
        button4.grid(pady=10) 

    def validate(self):                                                             # If dispening Button is selected
       value = self.v.get()
       if value == "a":                                                             # then dispensing default small amount
           print("Small Amount Dispensing")

               
class PageTwo(ttk.Frame):                                                                       #PageTwo = Settings Page
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        ttk.Label(self, text='Settings', font=LARGE_FONT).grid(padx=350, pady=10)               #Label for Settings
      
        self.v = StringVar()
        self.v.set("a")                                                                         #Make small amount default 
           
        ttk.Style().configure('Wild.TRadiobutton', front=LARGE_FONT, background='orange', foreground='black')  #Styling button to have color
    
        Rad1 = ttk.Radiobutton(self, text="SMALL", style = 'Wild.TRadiobutton', variable=self.v, value="a")    # Radio button for small
        Rad1.grid(padx=350, pady=20)
        
        Rad2 = ttk.Radiobutton(self, text="MEDIUM",style = 'Wild.TRadiobutton', variable=self.v, value="b")    # Radio button for medium            
        Rad2.grid(padx=350, pady=20)
        
        Rad3 = ttk.Radiobutton(self, text="LARGE",style = 'Wild.TRadiobutton', variable=self.v, value="c")     # Radio button for large         
        Rad3.grid(padx=350, pady=20)
       
        button2 = ttk.Button(self, text="SAVE", command=self.validate)                                         # Radio button to save and go to validate function
        button2.grid(padx=350, pady=40)                                                                        
        
        button1 = ttk.Button(self, text='Return to HomePage',                            # Button to return back to homepage
                              command=lambda: controller.show_frame(PageOne))            # Return to pageOne = HomePage
        button1.grid(padx=350, pady=10)
    def validate(self):
       value = self.v.get()                          #If SMALL amount is saved then output GPIO outputs  
       if value == "a":
           print("Small Amount Dispensing")
           #GPIO.output(23, GPIO.LOW)
           #GPIO.output(24, GPIO.LOW)
           #GPIO.output(25, GPIO.HIGH)
           #time.sleep(5)
           
       elif value == "b":                           #If MEDIUM amount is saved then output GPIO outputs  
           print("Medium Amount Dispensing")
           #GPIO.output(23, GPIO.LOW)
           #GPIO.output(24, GPIO.HIGH)
           #GPIO.output(25, GPIO.LOW)
           #time.sleep(5)
       else:                                        #If LARGE amount is saved then output GPIO outputs  
           print("Large Amount Dispensing")
           #GPIO.output(23, GPIO.LOW)
           #GPIO.output(24, GPIO.HIGH)
           #GPIO.output(25, GPIO.HIGH)
           #time.sleep(5)

class PageThree(ttk.Frame):
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
       
        ttk.Label(self, text='Testing', font=LARGE_FONT).grid(row=0, column=4)
          
        self.v = StringVar()
        self.v.set("b")
        ttk.Label(self, text='Stepper Motor',font=SMALL_FONT).grid(row=3, column=1)
        Rad1 = ttk.Radiobutton(self, text="Clockwise",style = 'Wild.TRadiobutton',variable=self.v, value="a")
        Rad1.grid(row=9, column=1)
        
        Rad2 = ttk.Radiobutton(self, text="Counter Clockwise",style = 'Wild.TRadiobutton',variable=self.v, value="b")                 
        Rad2.grid(row=12, column=1)
        
        button1 = ttk.Button(self, text="Save", command=self.validate_StepperMotor)
        button1.grid(row=15, column=1)
        
        self.vv = StringVar()
        self.vv.set("c")
        ttk.Label(self, text='Stepper Motor Acceleration', font=SMALL_FONT).grid(row=3, column=4)        
        Rad3 = ttk.Radiobutton(self, text="Fast",variable=self.vv, value="c")                 
        Rad3.grid(row=9, column=4)
        Rad4 = ttk.Radiobutton(self, text="Slow",variable=self.vv, value="d")                 
        Rad4.grid(row=12, column=4)
        
        button2 = ttk.Button(self, text="Save", command=self.validate_StepperAcc)
        button2.grid(row=15, column=4)
        
        self.dc = StringVar()
        self.dc.set("e")
        ttk.Label(self, text='DC Motor', font=SMALL_FONT).grid(row=3, column=8)
        Rad5 = ttk.Radiobutton(self, text="Right",variable=self.dc, value="e")                 
        Rad5.grid(row=9, column=8)
        Rad6 = ttk.Radiobutton(self, text="Left",variable=self.dc, value="f")                 
        Rad6.grid(row=12, column=8)   
        button3 = ttk.Button(self, text="Save", command=self.validate_DC)
        button3.grid(row=12, column=8)
        
        button4 = ttk.Button(self, text='Return to HomePage',
                              command=lambda: controller.show_frame(PageOne))
        button4.grid(row=560, column=4)


    def validate_StepperMotor(self):
       value = self.v.get()
       if value == "a":
           print("Clockwise")
           #print("Small Amount Dispensing")
           #GPIO.output(23, GPIO.HIGH)
           #time.sleep(5)


           
       elif value == "b":
           print("Counter Clockwise")
       else:
           print("Large Amount Dispensing")
           
    def validate_StepperAcc(self):
       value = self.vv.get()
       if value == "c":
           print("Fast")
           #print("Small Amount Dispensing")
           #GPIO.output(23, GPIO.HIGH)
           #time.sleep(5)
       elif value == "d":
           print("Slow")
       
    def validate_DC(self):
       value = self.dc.get()
       if value == "e":
           print("Right")
           #print("Small Amount Dispensing")
           #GPIO.output(23, GPIO.HIGH)
           #time.sleep(5)
       elif value == "f":
           print("Left")
       
   
class Password(ttk.Frame):                                         #Password Page                   
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        ttk.Label(self, text='Username', font=SMALL_FONT, ).grid(row=0) #Label for Username 
        ttk.Entry(self).grid(row=0, column=1)
        ttk.Label(self, text='Password', font=SMALL_FONT).grid(row=1)   #Label for Password 
        ttk.Entry(self).grid(row=1, column=1)
        button1 = ttk.Button(self, text="Login", command = self.Login_Button_Clicked) #If login is clicked then go to PageThree = Testing page
        button1.grid(row=2, column=1)
   

        #Need help if passwor and username are equal to green then go to page three else print login error 
    def Login_Button_Clicked(self):
        self.controller.show_frame(PageThree)
        

        if Username == "lat" and Password =="123":
                  self.controller.show_frame(PageThree)
        else:
            print("LOGIN ERROR")

        


     
    
app = MyApp()
app.title('Multi-Page Test App')
app.mainloop()

from tkinter import *
from tkinter import ttk
import RPi.GPIO as GPIO
import time
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

GPIO.setup(23, GPIO.OUT)                   #GPIO PIN to test motors 
GPIO.setup(24, GPIO.OUT)                   #GPIO PIN to test motors
GPIO.setup(25, GPIO.OUT)                   #GPIO PIN to test motors
GPIO.setup(12, GPIO.OUT)                   #GPIO PIN to set candy amount
GPIO.setup(16, GPIO.OUT)                   #GPIO PIN to set candy amount
GPIO.setup(20, GPIO.OUT)                   #GPIO PIN to send dispense signal
#GPIO.setup(21, GPIO.IN)                    #GPIO PIN to received feedback signal from FPGA 

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
        for F in (PageOne, PageTwo, PageThree):                 #populate this tuple with all of the possible pages to our application
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
        
        button1 = ttk.Button(self, text="Dispensing" , command=self.validate)                           #Button for Dispensing
        button1.grid(pady=10)

        button2 = ttk.Button(self, text='Settings',command=lambda: controller.show_frame(PageTwo))      #Button for Settings
        button2.grid(pady=10)
        
        button3 = ttk.Button(self, text='Testings', command=lambda: controller.show_frame(PageThree))   #Button for Testings
        button3.grid(pady=10)

    def validate(self):                                                                 #This will execute when Dispense Button is clicked
        
        GPIO.output(20, GPIO.HIGH)                                                      #Sends out a dispense signal
        print("Candy Dispening")
       # while GPIO.input(21) == 0:                                                      #Wait until a handshake signal received from the FPGA development board
        time.sleep(1)           #let dispense for 1 second, duration subject to change
        GPIO.output(20, GPIO.LOW)                                                       #Sends out a stop dispensing signal
        print("Candy Dispening Stopped")
               
class PageTwo(ttk.Frame):                       #PageTwo = Settings Page
    
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        ttk.Label(self, text='Settings', font=LARGE_FONT).grid(padx=350, pady=10)               #Label for Settings
      
        self.v = StringVar()
        self.v.set("a")                                                                         #Make small amount default 
           
        Rad1 = ttk.Radiobutton(self, text="SMALL", variable=self.v, value="a")    # Radio button for small
        Rad1.grid(padx=350, pady=20)
        
        Rad2 = ttk.Radiobutton(self, text="MEDIUM", variable=self.v, value="b")    # Radio button for medium            
        Rad2.grid(padx=350, pady=20)
        
        Rad3 = ttk.Radiobutton(self, text="LARGE", variable=self.v, value="c")     # Radio button for large         
        Rad3.grid(padx=350, pady=20)
       
        button2 = ttk.Button(self, text="SAVE", command=self.validate)                                         # Radio button to save and go to validate function
        button2.grid(padx=350, pady=40)                                                                        
        
        button1 = ttk.Button(self, text='Return to HomePage',                            # Button to return back to homepage
                              command=lambda: controller.show_frame(PageOne))            # Return to pageOne = HomePage
        button1.grid(padx=350, pady=10)
    def validate(self):
       value = self.v.get()                          #If SMALL amount is saved then output GPIO outputs  
       if value == "a":
           print("Small Amount Option Selected")
           GPIO.output(12, GPIO.LOW)
           GPIO.output(16, GPIO.LOW) 
       elif value == "b":                           #If MEDIUM amount is saved then output GPIO outputs  
           print("Medium Amount Option Selected")
           GPIO.output(12, GPIO.LOW)
           GPIO.output(16, GPIO.HIGH)
       else:                                        #If LARGE amount is saved then output GPIO outputs  
           print("Large Amount Option Selected")
           GPIO.output(12, GPIO.HIGH)
           GPIO.output(16, GPIO.LOW)

class PageThree(ttk.Frame):                             #PageThree = Testings Page
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
       
        ttk.Label(self, text='Testing', font=LARGE_FONT).grid(row=0, column=6)
          
        self.v = StringVar()                                                                #Stepper motor direction testing
        self.v.set("a")
        ttk.Label(self, text='Stepper Motor',font=SMALL_FONT).grid(row=3, column=1)
        Rad1 = ttk.Radiobutton(self, text="Clockwise",variable=self.v, value="a")
        Rad1.grid(row=9, column=1)
        
        Rad2 = ttk.Radiobutton(self, text="Counterclockwise",variable=self.v, value="b")                 
        Rad2.grid(row=12, column=1)
        
        button1 = ttk.Button(self, text="Test", command=self.validate_StepperMotor)
        button1.grid(row=15, column=1)
        
        self.vv = StringVar()                                                               #Stepper motor speed testing
        self.vv.set("c")
        ttk.Label(self, text='Stepper Motor Acceleration', font=SMALL_FONT).grid(row=3, column=4)        
        Rad3 = ttk.Radiobutton(self, text="Fast",variable=self.vv, value="c")                 
        Rad3.grid(row=9, column=4)
        Rad4 = ttk.Radiobutton(self, text="Slow",variable=self.vv, value="d")                 
        Rad4.grid(row=12, column=4)
        
        button2 = ttk.Button(self, text="Test", command=self.validate_StepperAcc)
        button2.grid(row=15, column=4)
        
        self.dc = StringVar()                                                               #DC motor direcion testing
        self.dc.set("e")
        ttk.Label(self, text='DC Motor', font=SMALL_FONT).grid(row=3, column=8)
        Rad5 = ttk.Radiobutton(self, text="Clockwise",variable=self.dc, value="e")                 
        Rad5.grid(row=9, column=8)
        Rad6 = ttk.Radiobutton(self, text="Counterclockwise",variable=self.dc, value="f")                 
        Rad6.grid(row=12, column=8)   
        button3 = ttk.Button(self, text="Test", command=self.validate_DC)
        button3.grid(row=15, column=8)


        self.dca = StringVar()                                                              #DC motor speed testing
        self.dca.set("g")
        ttk.Label(self, text='DC Motor Acceleration', font=SMALL_FONT).grid(row=3, column=12)
        Rad5 = ttk.Radiobutton(self, text="Fast",variable=self.dca, value="g")                 
        Rad5.grid(row=9, column=12)
        Rad6 = ttk.Radiobutton(self, text="Slow",variable=self.dca, value="h")                 
        Rad6.grid(row=12, column=12)   
        button4 = ttk.Button(self, text="Test", command=self.validate_DCAcc)
        button4.grid(row=15, column=12)

        
        button5 = ttk.Button(self, text='Return to HomePage',                               #A button to return to Homepage
                              command=lambda: controller.show_frame(PageOne))
        button5.grid(row=560, column=6)


    def validate_StepperMotor(self):                                                    
       value = self.v.get()
       if value == "a":                                                                     #Sends out signals to make stepper motor rotato clockwise, slow,
           print("Testing: Stepper Motor Clockwise")                                        #and then after 5s, turns off motor activities
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.HIGH)
           time.sleep(5)
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW)
       elif value == "b":                                                                   #Sends out signals to make stepper motor rotato counterclockwise, slow,
           print("Testing: Stepper Motor Counterclockwise")                                 #and then after 5s, turns off motor activities
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.HIGH)
           GPIO.output(25, GPIO.LOW)
           time.sleep(5)  
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW)
    def validate_StepperAcc(self):
       value = self.vv.get()
       if value == "c":                                                                     #Sends out signals to make stepper motor rotato clockwise, fast,
           print("Testing: Stepper Motor Fast")                                             #and then after 5s, turns off motor activities
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.HIGH)
           GPIO.output(25, GPIO.HIGH)
           time.sleep(5)
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW)
       elif value == "d":                                                                   #Sends out signals to make stepper motor rotato clockwise, slow,
           print("Testing: Stepper Motor Slow")                                             #and then after 5s, turns off motor activities
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.HIGH)
           time.sleep(5)
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW)
    def validate_DC(self):
       value = self.dc.get()
       if value == "e":                                                                     #Sends out signals to make DC motor rotato clockwise, slow,
           print("Testing: DC Motor Clockwise")                                             #and then after 5s, turns off motor activities
           GPIO.output(23, GPIO.HIGH)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW)
           time.sleep(5)
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW)
       elif value == "f":                                                                   #Sends out signals to make DC motor rotato counterclockwise, slow,
           print("Testing: DC Motor Counterclockwise")                                      #and then after 5s, turns off motor activities
           GPIO.output(23, GPIO.HIGH)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.HIGH)
           time.sleep(5)
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW) 
    def validate_DCAcc(self):
       value = self.dca.get()
       if value == "g":                                                                     #Sends out signals to make DC motor rotato clockwise, fast,
           print("Testing: DC Motor Fast")                                                  #and then after 5s, turns off motor activities
           GPIO.output(23, GPIO.HIGH)
           GPIO.output(24, GPIO.HIGH)
           GPIO.output(25, GPIO.LOW)
           time.sleep(5)
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW)
       elif value == "h":                                                                   #Sends out signals to make DC motor rotato clockwise, slow,
           print("Testing: DC Motor Slow")                                                  #and then after 5s, turns off motor activities
           GPIO.output(23, GPIO.HIGH)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW)
           time.sleep(5)
           GPIO.output(23, GPIO.LOW)
           GPIO.output(24, GPIO.LOW)
           GPIO.output(25, GPIO.LOW)
   
app = MyApp()
app.title('Multi-Page Test App')
app.mainloop()

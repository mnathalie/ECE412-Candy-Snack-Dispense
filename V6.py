from tkinter import *
from tkinter import ttk
#import RPi.GPIO as GPIO
#import time
#GPIO.setwarnings(False)
#GPIO.setmode(GPIO.BCM)
#GPIO.setup(23, GPIO.OUT)
SMALL_FONT= ("Verdana", 14)
MEDIUM_FONT= ("Verdana", 14)
LARGE_FONT= ("Verdana", 20)

class MyApp(Tk):

    def __init__(self):
        Tk.__init__(self)
        container = ttk.Frame(self)
        container.pack(side="top", fill="both", expand = True)
        self.frames = {}
        for F in (PageOne, PageTwo, PageThree):
            frame = F(container, self)
            self.frames[F] = frame
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
    
            
class PageOne(ttk.Frame):
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        ttk.Label(self, text='Home Page', font=LARGE_FONT).grid(padx=(400,400), pady=(50,50))
        self.controller = controller
        self.make_widget(controller)

    def make_widget(self, controller):
        #self.some_input = StringVar
        #self.some_entry = ttk.Entry(self, textvariable=self.some_input, width=8) 
        #self.some_entry.grid()
        

        
        self.v = StringVar()
        self.v.set("a")

       
        button1 = ttk.Button(self, text="Dispensing", command=self.validate)
        button1.grid(padx=20, pady=30)
        
        button2 = ttk.Button(self, text='Settings',
                              command=lambda: controller.show_frame(PageTwo))
        button2.grid(padx=20, pady=20)
        
        button3 = ttk.Button(self, text='Testing',
                              command=lambda: controller.show_frame(PageThree))
        button3.grid(padx=20, pady=20)

    def validate(self):
       value = self.v.get()
       if value == "a":
           print("Small Amount Dispensing")
           #print("Small Amount Dispensing")
           #GPIO.output(23, GPIO.HIGH)
           #time.sleep(5)
       


        
class PageTwo(ttk.Frame):
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        ttk.Label(self, text='Settings', font=LARGE_FONT).grid(padx=(400,400), pady=(50,50))
          
        self.v = StringVar()
        self.v.set("b")

        Rad1 = ttk.Radiobutton(self, text="SMALL",variable=self.v, value="a")
        Rad1.grid(padx=20, pady=1)
        
        Rad2 = ttk.Radiobutton(self, text="MEDIUM",variable=self.v, value="b")                 
        Rad2.grid(padx=20, pady=50)
        
        Rad3 = ttk.Radiobutton(self, text="LARGE",variable=self.v, value="c")                 
        Rad3.grid(padx=20, pady=20)
       
        button2 = ttk.Button(self, text="SAVE", command=self.validate)
        button2.grid(padx=20, pady=30)
        
        button1 = ttk.Button(self, text='Return to HomePage',
                              command=lambda: controller.show_frame(PageOne))
        button1.grid(padx=20, pady=20)

    def validate(self):
       value = self.v.get()
       if value == "a":
           print("Small Amount Dispensing")
           #print("Small Amount Dispensing")
           #GPIO.output(23, GPIO.HIGH)
           #time.sleep(5)
       elif value == "b":
           print("Medium Amount Dispensing")
       else:
           print("Large Amount Dispensing")

class PageThree(ttk.Frame):
    def __init__(self, parent, controller):
        ttk.Frame.__init__(self, parent)
        self.controller = controller
        ttk.Label(self, text='Testing', font=LARGE_FONT).grid(padx=20, pady=1)
          
        self.v = StringVar()
        self.v.set("b")
        ttk.Label(self, text='Stepper Motor',font=LARGE_FONT).grid(padx=(400,400), pady=(50,50))
        Rad1 = ttk.Radiobutton(self, text="Clockwise",variable=self.v, value="a")
        Rad1.grid(padx=20, pady=1)
        
        Rad2 = ttk.Radiobutton(self, text="Counter Clockwise",variable=self.v, value="b")                 
        Rad2.grid(padx=20, pady=1)
        
        button1 = ttk.Button(self, text="Save", command=self.validate_StepperMotor)
        button1.grid(padx=20, pady=15)
        
        self.vv = StringVar()
        self.vv.set("c")
        ttk.Label(self, text='Stepper Motor Acceleration', font=LARGE_FONT).grid(padx=(400,400), pady=(50,50))
        
        Rad3 = ttk.Radiobutton(self, text="Fast",variable=self.vv, value="c")                 
        Rad3.grid(padx=20, pady=1)
        Rad4 = ttk.Radiobutton(self, text="Slow",variable=self.vv, value="d")                 
        Rad4.grid(padx=20, pady=1)
        
        button2 = ttk.Button(self, text="Save", command=self.validate_StepperAcc)
        button2.grid(padx=20, pady=15)
        
        self.dc = StringVar()
        self.dc.set("e")
        ttk.Label(self, text='DC Motor', font=LARGE_FONT).grid(padx=(400,400), pady=(50,50))
        Rad5 = ttk.Radiobutton(self, text="Right",variable=self.dc, value="e")                 
        Rad5.grid(padx=20, pady=1)
        Rad6 = ttk.Radiobutton(self, text="Left",variable=self.dc, value="f")                 
        Rad6.grid(padx=20, pady=1)
        
        button3 = ttk.Button(self, text="Save", command=self.validate_DC)
        button3.grid(padx=20, pady=15)
        
        button4 = ttk.Button(self, text='Return to HomePage',
                              command=lambda: controller.show_frame(PageOne))
        button4.grid(padx=20, pady=15)

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
       
   
   
app = MyApp()
app.title('Multi-Page Test App')
app.mainloop()

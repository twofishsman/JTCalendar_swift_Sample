//
//  ViewController.swift
//  SampleCode
//
//  Created by Hasya.Panchasra on 20/04/16.
//  Copyright © 2016 bv. All rights reserved.
//

import UIKit


class ViewController: UIViewController,JTCalendarDelegate {


    @IBOutlet var calendarMenuView      : JTCalendarMenuView!
    @IBOutlet var calendarContentView   : JTHorizontalCalendarView!
    var calendarManager                 : JTCalendarManager!
    var dateSelected                    : NSDate!
    var eventsByDate                    : Dictionary = [String : NSDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        calendarManager = JTCalendarManager()
        calendarManager.delegate = self
    
        self.createRandomEvents()
        self.calendarManager.contentView = self.calendarContentView
        self.calendarManager.menuView = self.calendarMenuView
        calendarManager.setDate(NSDate())
    }

    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
    
        let dayView = dayView as! JTCalendarDayView
        dayView.hidden = false
        
        if(dayView.isFromAnotherMonth){
            dayView.hidden = true
        }
            // Today
        else if(calendarManager.dateHelper.date(NSDate(), isTheSameDayThan:dayView.date))
        {
            dayView.circleView.hidden = false
            dayView.circleView.backgroundColor = UIColor.blueColor()
            dayView.dotView.backgroundColor = UIColor.whiteColor()
            dayView.textLabel.textColor = UIColor.whiteColor()
        }
           // Selected date
        else if((dateSelected != nil) &&
            self.calendarManager.dateHelper.date(dateSelected, isTheSameDayThan:dayView.date)){
            
            dayView.circleView.hidden = false
            dayView.circleView.backgroundColor = UIColor.redColor()
            dayView.dotView.backgroundColor = UIColor.whiteColor()
            dayView.textLabel.textColor = UIColor.whiteColor()
        }
            // Another day of the current month
        else{
            dayView.circleView.hidden = true
            dayView.dotView.backgroundColor = UIColor.redColor()
            dayView.textLabel.textColor = UIColor.blackColor()
        }

            // Your method to test if a date have an event for example
        dayView.dotView.hidden = !self.haveEventForDay(dayView.date)
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!){
        
        let dayView = dayView as! JTCalendarDayView
        self.dateSelected = dayView.date
        self.createRandomEvents()
    
        dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
        UIView.transitionWithView(dayView,
                                  duration:0.3,
                                  options:UIViewAnimationOptions.CurveEaseOut,
                                  animations:{
                    dayView.circleView.transform = CGAffineTransformIdentity
                    self.calendarManager.reload()},
                                  completion:nil)
        
        // Don't change page in week mode because block the selection of days in first and last weeks of the month
        if self.calendarManager.settings.weekModeEnabled == true {
            return
        }
        
        // Load the previous or next page if touch a day from another month
        if(!self.calendarManager.dateHelper.date( self.calendarContentView.date, isTheSameMonthThan:dayView.date)){
            if self.calendarContentView.date.compare(dayView.date) ==  NSComparisonResult.OrderedAscending
            {
                self.calendarContentView.loadNextPageWithAnimation()
            }
            else{
                self.calendarContentView.loadPreviousPageWithAnimation()
            }
        }
    }
    
    //MARK - Fake data
    // Used only to have a key for _eventsByDate
    func dateFormatter() -> NSDateFormatter{
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter
    }

    func haveEventForDay(date : NSDate) -> Bool{

        let key = self.dateFormatter().stringFromDate(date)
        if(( eventsByDate[key] == nil)  && (eventsByDate/*[key]*/.count > 0) ){
            return true
        }
        return false
    }
    
    func createRandomEvents(){
        
       self.eventsByDate = [String : NSDate]()
        
        for _ in 0...29{
            let randomDate = NSDate.init(timeInterval: Double (arc4random()) % (3600 * 24 * 60), sinceDate: NSDate())
            // Use the date as key for eventsByDate
            let key = self.dateFormatter().stringFromDate(randomDate)
            
            if(self.eventsByDate[key] == nil){
                self.eventsByDate.updateValue(randomDate, forKey: key)
            }
        }
    }
}


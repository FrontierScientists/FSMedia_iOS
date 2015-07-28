//
//  ViewController.swift
//  Swift_Navigation
//
//  Created by alandrews3 on 6/4/15.
//  Copyright (c) 2015 alandrews3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer = NSTimer();
    var timerIsActive_bool = false;
    var timerSeconds = 0;
    var timerMinutes = 0;
    var timerIsActive = false;
    @IBOutlet weak var timerOuputLabel: UILabel!
    @IBOutlet weak var play_pause_Button: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateTimer(){
      
            ++timerSeconds;
            
            if(timerSeconds >= 60)
            {
                timerSeconds = 0;
                ++timerMinutes;
            }
        
        stopwatchUpdate();
    }
    
    @IBAction func playButtonPressed(sender: AnyObject) {
        
        if(timerIsActive){
            
            timerIsActive = false;
            timer.invalidate();
            play_pause_Button.image = UIImage(named: "Play_Button.png");
        }
        else{
            
            timerIsActive = true;
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: Selector("updateTimer"),
            userInfo: nil,
            repeats: true);
            play_pause_Button.image = UIImage(named: "Pause_Button.png");
        }
    }

    @IBAction func stopButtonPressed(sender: AnyObject) {
        
        timerIsActive = false;
        timer.invalidate();
        timerSeconds = 0;
        timerMinutes = 0;
        stopwatchUpdate();
    }
    
    func stopwatchUpdate()
    {
        var secondsStr: String;
        var minutesStr: String;
        if(timerSeconds < 10){
            secondsStr = "0\(timerSeconds)";
        }
        else{
            secondsStr = "\(timerSeconds)";
        }
        if(timerMinutes < 10){
            minutesStr = "0\(timerMinutes)";
        }
        else{
            minutesStr = "\(timerSeconds)";
        }
        timerOuputLabel.text = minutesStr + " : " + secondsStr;
    }
}


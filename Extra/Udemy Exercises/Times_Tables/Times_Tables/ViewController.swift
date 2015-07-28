//
//  ViewController.swift
//  Times_Tables
//
//  Created by alandrews3 on 6/5/15.
//  Copyright (c) 2015 alandrews3. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!;
    @IBOutlet weak var questionInputField: UITextField!;
    @IBOutlet weak var questionText: UILabel!;
    @IBOutlet weak var sliderValue: UISlider!;
    @IBOutlet weak var answerResultText: UILabel!;
    var playerNameArr = ["Jen", "Trolo", "Quasimodo", "Nurgle"];
    var playerScoreArr = [0, 0, 0, 0];
    var selectedPlayerIndex: Int? = nil;
    var firstNumber: Int = 0;
    var secondNumber: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewRandomNumbers();
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func sliderMoved(sender: AnyObject) {
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return playerNameArr.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let CELL = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        CELL.textLabel?.text = playerNameArr[indexPath.row];
        CELL.detailTextLabel?.text = "\(playerScoreArr[indexPath.row])"
        CELL.textLabel?.textColor = UIColor.blackColor();
        
        return CELL;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedPlayerIndex = indexPath.row;
        getNewRandomNumbers();
        println("\(indexPath.row)");
    }
    
    @IBAction func submitAnswerButtonPressed(sender: AnyObject) {
        
        var userAnswer = questionInputField.text.toInt();
        
        if(selectedPlayerIndex == nil){
            
            answerResultText.text = "Choose a player!"
        }
        else if(userAnswer != nil && userAnswer == (firstNumber*secondNumber)){
            
            answerResultText.text = "Correct! :D"
            if(firstNumber == 0 && secondNumber == 0){
                
                playerScoreArr[selectedPlayerIndex!] += 1;
            }
            else{
                
                playerScoreArr[selectedPlayerIndex!] += firstNumber+secondNumber;
            }
            self.myTableView.reloadData();
        }
        else{
            
            answerResultText.text = "Nope, the answer is \(firstNumber*secondNumber).";
        }
        
        getNewRandomNumbers();
        self.myTableView.reloadData();
    }
    
    func getNewRandomNumbers()
    {
        firstNumber = Int(arc4random_uniform(uint(sliderValue.value)));
        secondNumber = Int(arc4random_uniform(uint(sliderValue.value)));
        questionText.text = "\(firstNumber) x \(secondNumber)";
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//  GameVC.swift
//  PMTTT
//
//  Created by Pavle Mijatovic on 2/22/16.
//  Copyright © 2016 Pavle Mijatovic. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class GameVC: UIViewController
{
    // MARK: - Properties
    @IBOutlet weak var player1: UITextField!
    @IBOutlet weak var player2: UITextField!
    
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var PlayerTurnsLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    var didPlayerOneWin = false
    var isItATie = false
    
    var goNumber = 1
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var winningCombinations = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    var winner = 0
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        
        label.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        label.center = CGPointMake(label.center.x - 400, label.center.y)
        //        playAgainButton.alpha = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func keyboardWillAppear(notification: NSNotification){
        
        enableBoardFields(false)
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        
        enableBoardFields(true)
        
    }
    
    private func enableBoardFields(shouldEnable: Bool) {
        button0.enabled = shouldEnable; button1.enabled = shouldEnable; button2.enabled = shouldEnable;
        button3.enabled = shouldEnable; button4.enabled = shouldEnable; button5.enabled = shouldEnable;
        button6.enabled = shouldEnable; button7.enabled = shouldEnable; button8.enabled = shouldEnable;
    }
    
    //MARK: - private
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        
        label.text = ""
        
        if gameState[sender.tag] == 0 && winner == 0
        {
            var image = UIImage()
            
            if goNumber % 2 == 0
            {
                
                
                image = UIImage(named: "o")!
                gameState[sender.tag] = 1
                
                let p1 = player1.text! == "" ? "player 1" : player1.text!
                
                PlayerTurnsLabel.text = "It's \(p1)'s Turn"
            }
            else
            {
                
                let p2 = player1.text! == "" ? "player 2" : player2.text!
                
                
                image = UIImage(named: "x")!
                gameState[sender.tag] = 2
                PlayerTurnsLabel.text = "It's \(p2)'s Turn"
                
            }
            
            for combination in winningCombinations
            {
                if gameState[combination[0]] == gameState[combination[1]] &&
                    gameState[combination[0]] == gameState[combination[2]] &&
                    gameState[combination[0]] != 0
                {
                    winner = gameState[combination[0]]
                }
            }
            
            if winner != 0
            {
                
                if winner == 1
                {
                    let p2 = player1.text! == "" ? "player 2" : player2.text!
                    
                    label.text = "\(p2) has won!"
                    self.isItATie = false
                    
                    PlayerTurnsLabel.text = ""
                    
                    self.didPlayerOneWin = false
                    
                    inputStatData()
                    
                }
                else
                {
                    let p1 = player1.text! == "" ? "player 1" : player1.text!
                    
                    label.text = "\(p1) has won!"
                    self.didPlayerOneWin = true
                    self.isItATie = false
                    PlayerTurnsLabel.text = ""
                    
                    inputStatData()
                }
                
                self.label.hidden = false
                self.playAgainButton.hidden = false
                
            }
            
            goNumber++
            sender.setImage(image, forState: UIControlState.Normal)
            
            if goNumber == 10 && winner == 0
            {
                label.text = "No winner!"
                
                self.isItATie = true
                self.label.hidden = false
                self.label.center = CGPointMake(self.label.center.x + 400, self.label.center.y)
                self.playAgainButton.hidden = false
                
                self.PlayerTurnsLabel.text = ""
                
                isItATie = true
                didPlayerOneWin = false
                inputStatData()
                
            }
        }
    }
    
    
    func inputStatData() {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        var finalStatMessage = ""
        var winnerName = ""
        let tieMessage = "it was a tie"
        
        
        if isItATie {
            finalStatMessage = "on the \(timestamp), \(tieMessage)"
        } else {
            if didPlayerOneWin {
                winnerName = player1.text!
            } else {
                winnerName = player2.text!
            }
            
            finalStatMessage = "on the \(timestamp), \(winnerName) won"
        }
        
        
        let statsObject = StatsRealm()
        
        statsObject.player1 = player1.text!
        statsObject.player2 = player2.text!
        statsObject.date = timestamp
        statsObject.finalMessage = finalStatMessage
        
        
        let dbHandler = DBHandler()
        dbHandler.addStatsToDB(statsObject)

    }
    
    @IBAction func playAgainButtonPressed(sender: UIButton) {
        
        goNumber = 1
        winner = 0
        gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
//        label.hidden = true
        label.text = "X starts first"

        
        self.playAgainButton.hidden = true
        
        
        button0.setImage(nil, forState: UIControlState.Normal)
        button1.setImage(nil, forState: UIControlState.Normal)
        button2.setImage(nil, forState: UIControlState.Normal)
        button3.setImage(nil, forState: UIControlState.Normal)
        button4.setImage(nil, forState: UIControlState.Normal)
        button5.setImage(nil, forState: UIControlState.Normal)
        button6.setImage(nil, forState: UIControlState.Normal)
        button7.setImage(nil, forState: UIControlState.Normal)
        button8.setImage(nil, forState: UIControlState.Normal)
    }
}

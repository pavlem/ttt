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
    
    @IBOutlet weak var b11: UIButton!
    @IBOutlet weak var b12: UIButton!
    @IBOutlet weak var b13: UIButton!
    @IBOutlet weak var b21: UIButton!
    @IBOutlet weak var b22: UIButton!
    @IBOutlet weak var b23: UIButton!
    @IBOutlet weak var b31: UIButton!
    @IBOutlet weak var b32: UIButton!
    @IBOutlet weak var b33: UIButton!
    
    @IBOutlet weak var generalInfo: UILabel!
    @IBOutlet weak var playerInfo: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    var didPlayerOneWin = false
    var isItATie = false
    
    var goNumber = 1
    var gameState = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var winningCombinations = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    var winner = 0
    
    let playerX = "Player X"
    let playerO = "Player O"
    let tieMessage = "it was a tie"
    let noWinnerMessage = "No winner!"
    let startingMessage = "X starts first"
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
        
        generalInfo.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        generalInfo.center = CGPointMake(generalInfo.center.x - 400, generalInfo.center.y)
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
        b11.enabled = shouldEnable; b12.enabled = shouldEnable; b13.enabled = shouldEnable;
        b21.enabled = shouldEnable; b22.enabled = shouldEnable; b23.enabled = shouldEnable;
        b31.enabled = shouldEnable; b32.enabled = shouldEnable; b33.enabled = shouldEnable;
    }
    
    //MARK: - private
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func playAction(sender: UIButton) {
        
        generalInfo.text = ""
        
        if gameState[sender.tag] == 0 && winner == 0
        {
            var image = UIImage()
            
            if goNumber % 2 == 0
            {
                
                
                image = UIImage(named: "o")!
                gameState[sender.tag] = 1
                
                let p1 = player1.text! == "" ? playerX : player1.text!
                
                playerInfo.text = "It's \(p1)'s Turn"
            }
            else
            {
                
                let p2 = player1.text! == "" ? playerO : player2.text!
                
                
                image = UIImage(named: "x")!
                gameState[sender.tag] = 2
                playerInfo.text = "It's \(p2)'s Turn"
                
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
                    let p2 = player1.text! == "" ? playerO : player2.text!
                    
                    generalInfo.text = "\(p2) has won!"
                    self.isItATie = false
                    
                    playerInfo.text = ""
                    
                    self.didPlayerOneWin = false
                    
                    inputStatData()
                    
                }
                else
                {
                    let p1 = player1.text! == "" ? playerX : player1.text!
                    
                    generalInfo.text = "\(p1) has won!"
                    self.didPlayerOneWin = true
                    self.isItATie = false
                    playerInfo.text = ""
                    
                    inputStatData()
                }
                
                self.generalInfo.hidden = false
                self.playAgainButton.hidden = false
                
            }
            
            goNumber++
            sender.setImage(image, forState: UIControlState.Normal)
            
            if goNumber == 10 && winner == 0
            {
                generalInfo.text = noWinnerMessage
                
                self.isItATie = true
                self.generalInfo.hidden = false
                self.generalInfo.center = CGPointMake(self.generalInfo.center.x + 400, self.generalInfo.center.y)
                self.playAgainButton.hidden = false
                
                self.playerInfo.text = ""
                
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
        
        
        if isItATie {
            finalStatMessage = "on the \(timestamp), \(tieMessage)"
        } else {
            if didPlayerOneWin {
                
                let p1 = player1.text! == "" ? playerX : player1.text!
                
                winnerName = p1
            } else {
                let p2 = player1.text! == "" ? playerO : player2.text!

                winnerName = p2
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
        generalInfo.text = startingMessage
        
        self.playAgainButton.hidden = true
        
        b11.setImage(nil, forState: UIControlState.Normal); b12.setImage(nil, forState: UIControlState.Normal); b13.setImage(nil, forState: UIControlState.Normal); b21.setImage(nil, forState: UIControlState.Normal); b22.setImage(nil, forState: UIControlState.Normal); b23.setImage(nil, forState: UIControlState.Normal); b31.setImage(nil, forState: UIControlState.Normal); b32.setImage(nil, forState: UIControlState.Normal); b33.setImage(nil, forState: UIControlState.Normal)
    }
}

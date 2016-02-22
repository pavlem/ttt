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
    @IBOutlet weak var playAgainButton: UIButton!
    
    var didPlayerOneWin = false
    var isItATie = false
    
    var goNum = 1
    var game = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var gameWinCombo = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
    var winn = 0
    
    let playerX = "Player X"
    let playerO = "Player O"
    let tieMessage = "it was a tie"
    let noWinnerMessage = "No winner!"
    let startingMessage = "X starts first"
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGestureRecognizers()
        addObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        generalInfo.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: - Public
    func keyboardWillAppear(notification: NSNotification) {
        enableBoardFields(false)
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        enableBoardFields(true)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // MARK: - Private
    private func addGestureRecognizers() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    private func addObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func enableBoardFields(shouldEnable: Bool) {
        b11.enabled = shouldEnable; b12.enabled = shouldEnable; b13.enabled = shouldEnable;
        b21.enabled = shouldEnable; b22.enabled = shouldEnable; b23.enabled = shouldEnable;
        b31.enabled = shouldEnable; b32.enabled = shouldEnable; b33.enabled = shouldEnable;
    }
    
    private func saveStatData() {
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
        
        saveStatObjectToDB(withTimeStamp: timestamp, andFinalMessage: finalStatMessage)
    }
    
    private func saveStatObjectToDB(withTimeStamp timestamp: String, andFinalMessage finalStatMessage:String ) {
        let statsObject = StatsRealm()
        
        statsObject.player1 = player1.text!
        statsObject.player2 = player2.text!
        statsObject.date = timestamp
        statsObject.finalMessage = finalStatMessage
        
        let dbHandler = DBHandler()
        dbHandler.addStatsToDB(statsObject)
    }

    
    // MARK: - Actions
    @IBAction func playAction(sender: UIButton) {
        
        if game[sender.tag] == 0 && winn == 0 {
            var image = UIImage()
            
            if goNum % 2 == 0 {
                image = UIImage(named: "o")!
                game[sender.tag] = 1
                let p1 = player1.text! == "" ? playerX : player1.text!
                generalInfo.text = "It's \(p1)'s Turn"
            } else {
                let p2 = player1.text! == "" ? playerO : player2.text!
                image = UIImage(named: "x")!
                game[sender.tag] = 2
                generalInfo.text = "It's \(p2)'s Turn"
            }
            
            for combination in gameWinCombo {
                if game[combination[0]] == game[combination[1]] && game[combination[0]] == game[combination[2]] && game[combination[0]] != 0 {
                    winn = game[combination[0]]
                }
            }
            
            if winn != 0 {
                if winn == 1 {
                    let p2 = player1.text! == "" ? playerO : player2.text!
                    generalInfo.text = "\(p2) has won!"
                    self.isItATie = false
                    self.didPlayerOneWin = false
                    saveStatData()
                } else {
                    let p1 = player1.text! == "" ? playerX : player1.text!
                    generalInfo.text = "\(p1) has won!"
                    self.didPlayerOneWin = true
                    self.isItATie = false
                    saveStatData()
                }
                
                self.playAgainButton.hidden = false
            }
            
            goNum++
            sender.setImage(image, forState: UIControlState.Normal)
            
            if goNum == 10 && winn == 0 {
                generalInfo.text = noWinnerMessage
                
                self.isItATie = true
                self.playAgainButton.hidden = false
                
                isItATie = true
                didPlayerOneWin = false
                saveStatData()
            }
        }
    }
    
    @IBAction func playAgainButtonPressed(sender: UIButton) {
        game = [0, 0, 0, 0, 0, 0, 0, 0, 0]; goNum = 1; winn = 0
        generalInfo.text = startingMessage
        
        self.playAgainButton.hidden = true
        
        b11.setImage(nil, forState: UIControlState.Normal); b12.setImage(nil, forState: UIControlState.Normal); b13.setImage(nil, forState: UIControlState.Normal); b21.setImage(nil, forState: UIControlState.Normal); b22.setImage(nil, forState: UIControlState.Normal); b23.setImage(nil, forState: UIControlState.Normal); b31.setImage(nil, forState: UIControlState.Normal); b32.setImage(nil, forState: UIControlState.Normal); b33.setImage(nil, forState: UIControlState.Normal)
    }
}

//
//  GameViewController.swift
//  Bop It
//
//  Created by James Young on 3/8/18.
//  Copyright © 2018 James Young. All rights reserved.
//

import Foundation
import UIKit

class GameViewController: UIViewController
{
    //MARK: Properties
    
    @IBOutlet weak var gameNum: UILabel!
    @IBOutlet weak var currentNum: UILabel!
    @IBOutlet weak var perfectDummy: UILabel!
    @IBOutlet weak var goodDummy: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet var gameField: UIView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var settings: UIImageView!
    @IBOutlet weak var action: UILabel!
    var gestures = [ "Swipe Right", "Swipe Left", "Swipe Up", "Swipe Down","Rotate 360", "Tap" ]
    var countdown = Timer()
    var gameTimer = Timer()
    var countdownSeconds = 4
    var gameSeconds = 0
    var gameNumOfGestures = 0
    var currentNumOfGestures = 0
    var rotationModifier = 0
    var randomNum = 0
    var difficulty = ""
    var currentGesture = ""
    var wantedGesture = ""
    var genGesture = UIGestureRecognizer()
    var swipeRight = UISwipeGestureRecognizer()
    var swipeLeft = UISwipeGestureRecognizer()
    var swipeUp = UISwipeGestureRecognizer()
    var swipeDown = UISwipeGestureRecognizer()
    var tap = UITapGestureRecognizer()
    var rotate = UIRotationGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setup(countdownSeconds:countdownSeconds, then: gameStart)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView()
    {
        action.text = difficulty
        gameField.isUserInteractionEnabled = true
        genGesture = UIGestureRecognizer(target: self, action: #selector(self.checkGesture))
        //Init Right
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        gameField.addGestureRecognizer(swipeRight)
        
        //Init Left
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        gameField.addGestureRecognizer(swipeLeft)
        
        //Init Up
        swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        gameField.addGestureRecognizer(swipeUp)
        
        //Init Down
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        gameField.addGestureRecognizer(swipeDown)
        
        //Init Tap
        tap = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        gameField.addGestureRecognizer(tap)
        
        rotate = UIRotationGestureRecognizer(target: self, action: #selector(self.rotationGesture))
        gameField.addGestureRecognizer(rotate)
        
        
    }
    @objc func swipeGesture(sender:UISwipeGestureRecognizer)
    {
        if let swipeGesture = sender as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction{
            case UISwipeGestureRecognizerDirection.right:
                currentGesture = "Swipe Right"
            case UISwipeGestureRecognizerDirection.left:
                currentGesture = "Swipe Left"
            case UISwipeGestureRecognizerDirection.up:
                currentGesture = "Swipe Up"
            case UISwipeGestureRecognizerDirection.down:
                currentGesture = "Swipe Down"
            default:
                break
            }
        }
        if currentGesture == wantedGesture
        {
            status.textColor = UIColor.black
            status.text = "Perfect! +100 points!"
            status.textColor = perfectDummy.textColor
            score.text = String(Int(score.text!)! + 100)
        }
        else
        {
            status.textColor = UIColor.black
            status.text = "Fail! You did \(currentGesture)!"
            status.textColor = UIColor.red
        }
    }

    @objc func tapGesture(sender:UITapGestureRecognizer)
    {
        currentGesture = "Tap"
        if currentGesture == wantedGesture
        {
            status.textColor = UIColor.black
            status.text = "Perfect! +100 points!"
            status.textColor = perfectDummy.textColor
            score.text = String(Int(score.text!)! + 100)
            
        }
        else
        {
            status.textColor = UIColor.black
            status.text = "Fail! You did \(currentGesture)!"
            status.textColor = UIColor.red
        }
    }
    
    @objc func rotationGesture(sender:UIRotationGestureRecognizer)
    {
        if(wantedGesture == "Rotate 360"){
            let rotate = sender
            var degrees = 0
            guard rotate.view != nil else {return}
            if rotate.state == .changed
            {
                action.transform = CGAffineTransform(rotationAngle: rotate.rotation)
            }
            else if rotate.state == .ended
            {
                degrees = Int(abs(rotate.rotation) * 180.0 / CGFloat.pi)
                if (degrees >= 340 && degrees <= 380)
                {
                    currentGesture = "Rotate 360"
                    rotationModifier = 2
                    status.textColor = UIColor.black
                    status.text = "Perfect! \(degrees) Degrees! +200 points!"
                    status.textColor = perfectDummy.textColor
                    
                }
                else if ((degrees > 300 && degrees < 340) || (degrees > 380 && degrees < 420))
                {
                    currentGesture = "Rotate 360"
                    rotationModifier = 1
                    status.textColor = UIColor.black
                    status.text = "Good Enough! \(degrees) Degrees! +100 points!"
                    status.textColor = goodDummy.textColor
                  
                }
                else
                {
                    currentGesture = ""
                    rotationModifier = 0
                    status.textColor = UIColor.black
                    status.text = "Fail! \(degrees) Degrees!"
                    status.textColor = UIColor.red
                    
                }
                action.transform = CGAffineTransform.identity
                rotate.rotation = 0
                if wantedGesture == currentGesture
                {
                    score.text = String(Int(score.text!)! + (100 * rotationModifier))
                }
            }
        }
    }
    func gameStart()
    {
        action.backgroundColor = UIColor(red: 0xff, green: 0xff, blue: 0xff, alpha: 1)
        action.textColor = UIColor(red: 0x00, green:0x00, blue:0x00, alpha:1)
        randomNum = Int(arc4random_uniform(UInt32(gestures.count)))
        //wantedGesture = gestures[5]
        //action.text = gestures[5]
        wantedGesture = gestures[randomNum]
        action.text = gestures[randomNum]
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameClock), userInfo: nil, repeats: true)
        
    /*
        while(gameSeconds > 0)
        {
            while(currentNumOfGestures >= 0)
            {
                print("hey")
                randomNum = Int(arc4random_uniform(UInt32(gestures.count)))
                wantedGesture = gestures[randomNum]
                action.text = gestures[randomNum]
                if currentGesture == wantedGesture
                {
                    if wantedGesture == "Rotate 360"
                    {
                        score.text = String((Int(score.text!)! + 100) * rotationModifier)
                    }
                    else
                    {
                        score.text = String(Int(score.text!)! + 100)
                    }
                    currentNumOfGestures = currentNumOfGestures - 1
                    currentNum.text = String(currentNumOfGestures)
                }
                if currentNumOfGestures == 0
                {
                    win()
                    break
                }
            }
        }
        lose()
 */
    }
    
    func win()
    {
        difficulty = ""
        let finalViewController = storyboard?.instantiateViewController(withIdentifier: "FinalViewController") as! FinalViewController
        finalViewController.scorePassed = score.text!
        finalViewController.resPassed = "You win!"
        self.present(finalViewController, animated:true, completion:nil)
    }
    func lose()
    {
        difficulty = ""
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let finalViewController = storyBoard.instantiateViewController(withIdentifier: "FinalViewController") as! FinalViewController
        finalViewController.scorePassed = score.text!
        finalViewController.resPassed = "You lose."
        self.present(finalViewController, animated:true, completion:nil)
    }
    /*
    func
    {
        action.backgroundColor = UIColor(red: 0x00, green: 0xff, blue: 0x00, alpha: 1)
        action.textColor = UIColor(red: 0x00, green:0x00, blue:0x00, alpha:1)
        countdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.clock), userInfo: nil, repeats: true)
        gameStart()
    }
 */
    private func setDifficulty()
    {
        switch difficulty {
        case "Easy":
            gameSeconds = 60
            gameNumOfGestures = 10
            currentNumOfGestures = 10
        case "Hard":
            gameSeconds = 30
            gameNumOfGestures = 15
            currentNumOfGestures = 15
        case "Nightmare":
            gameSeconds = 15
            gameNumOfGestures = 20
            currentNumOfGestures = 20
        default:
            gameSeconds = 10
            gameNumOfGestures = 10
            currentNumOfGestures = 10
        }
    }
    
    @objc private func gameClock()
    {
       gameSeconds = gameSeconds - 1
        timer.text = String(gameSeconds)
        if currentNumOfGestures == 0
        {
            win()
        }
        if gameSeconds == 0
        {
            lose()
            gameTimer.invalidate()
        }
        if currentGesture == wantedGesture
        {
            wantedGesture = ""
            currentNumOfGestures = currentNumOfGestures - 1
            currentNum.text = String(currentNumOfGestures)
            randomNum = Int(arc4random_uniform(UInt32(gestures.count)))
            //wantedGesture = gestures[5]
            //action.text = gestures[5]
            wantedGesture = gestures[randomNum]
            action.text = " "
            action.text = gestures[randomNum]
            currentGesture = ""
        }
    }
    
    private func setup(countdownSeconds: Int, then:@escaping ()->() ){
        action.backgroundColor = UIColor(red: 0x00, green: 0xff, blue: 0x00, alpha: 1)
        action.textColor = UIColor(red: 0x00, green:0x00, blue:0x00, alpha:1)
        setDifficulty()
        gameNum.text = String(gameNumOfGestures)
        currentNum.text = String(currentNumOfGestures)
        timer.text = String(gameSeconds)
        
        
        var countdownSecondsToCount = countdownSeconds
        countdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ [weak self] timer in
            if (countdownSecondsToCount) > 0{
                countdownSecondsToCount -= 1
                self?.action.text = String((countdownSecondsToCount))
                
                //call closure when your want to print the text.
                //then()
            }
            else{
                //call closure when your want to print the text.
                then()
                self?.countdown.invalidate()
            }
        }
    }
    
    @objc func checkGesture()
    {
        
    }
    
}

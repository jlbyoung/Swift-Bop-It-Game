//
//  FinalViewController.swift
//  Bop It
//
//  Created by James Young on 2018-03-14.
//  Copyright © 2018 James Young. All rights reserved.
//

import Foundation
import UIKit
class FinalViewController : UIViewController
{
    //MARK: Properties
    
    
    @IBOutlet weak var res: UILabel!
    var resPassed:String = ""
    @IBOutlet weak var playAgain: UIButton!
    @IBOutlet weak var quit: UIButton!
    @IBOutlet weak var scoreResult: UILabel!
    var scorePassed:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        res.text = resPassed
        scoreResult.text = scorePassed
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        UIApplication.shared.keyWindow?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "Root_View")
    }
    
    
    
}

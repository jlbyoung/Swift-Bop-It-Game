//
//  DifficultyViewController.swift
//  Bop It
//
//  Created by James Young on 3/8/18.
//  Copyright © 2018 James Young. All rights reserved.
//

import UIKit

class DifficultyViewController: UIViewController
{
    @IBOutlet weak var easy: UIButton!
    @IBOutlet weak var hard: UIButton!
    @IBOutlet weak var nightmare: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func easyPressed(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        myVC.difficulty = easy.currentTitle!
        navigationController?.pushViewController(myVC, animated: true)
    }
    @IBAction func hardPressed(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        myVC.difficulty = hard.currentTitle!
        navigationController?.pushViewController(myVC, animated: true)
    }
    @IBAction func nightmarePressed(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        myVC.difficulty = nightmare.currentTitle!
        navigationController?.pushViewController(myVC, animated: true)
    }
}

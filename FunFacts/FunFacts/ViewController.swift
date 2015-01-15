//
//  ViewController.swift
//  FunFacts
//
//  Created by Kirill Pahnev on 11/01/15.
//  Copyright (c) 2015 Kirill Pahnev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var showFunFactButton: UIButton!

    let factBook = FactBook()
    let colorWheel = ColorWheel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        funFactLabel.text = factBook.randomFact()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func showFunFact() {
        var randomColor = colorWheel.randomColor()
        funFactLabel.text = factBook.randomFact()
        view.backgroundColor = randomColor
        showFunFactButton.tintColor = randomColor
    }
}


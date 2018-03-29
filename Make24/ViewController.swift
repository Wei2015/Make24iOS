//
//  ViewController.swift
//  Make24
//
//  Created by MacBookPro13 on 3/28/18.
//  Copyright © 2018 edu.sjsu.CMPE277. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var sideLeadingConstraint: NSLayoutConstraint!
    var isSlideWindownOpen : Bool = false
    
    @IBOutlet weak var textField: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var attemptLabel: UILabel!
    @IBOutlet weak var failedLabel: UILabel!
    
    
    @IBOutlet weak var firstNum: UIButton!
    @IBOutlet weak var secondNum: UIButton!
    @IBOutlet weak var thirdNum: UIButton!
    @IBOutlet weak var fourthNum: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var selectedNumButton = [UIButton]()
    var attemptCount = 0
    var successCount = 0
    var failureCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sideLeadingConstraint.constant = -200
        isSlideWindownOpen = false
        
        //add number buttons to array
        selectedNumButton.append(firstNum)
        selectedNumButton.append(secondNum)
        selectedNumButton.append(thirdNum)
        selectedNumButton.append(fourthNum)
        
        //disable doneButton
        doneButton.isEnabled = false
        //set textField as empty string
        textField.text = ""
        //set counts labels
        attemptLabel.text = "1"
        successLabel.text = "0"
        failedLabel.text = "0"
    
    }

    @IBAction func slideWindow(_ sender: UIBarButtonItem) {
        if isSlideWindownOpen {
            sideLeadingConstraint.constant = -200
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
        } else {
            sideLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
        }
        isSlideWindownOpen = !isSlideWindownOpen
      
    }
    //action method for operator buttons
    @IBAction func operatorButton(_ sender: UIButton) {
        switch sender.tag {
        case 5:
            textField.text = textField.text! + "+"
        case 6:
            textField.text = textField.text! + "-"
        case 7:
            textField.text = textField.text! + "*"
        case 8:
            textField.text = textField.text! + "/"
        case 9:
            textField.text = textField.text! + "("
        case 10:
            textField.text = textField.text! + ")"
        case 11: //back button
            backButtonClicked()
        default:
            textField.text = textField.text!
        }
        doneButton.isEnabled = true

    }
    //clear button method
    private func backButtonClicked()->Void {
        var expression = textField.text
        if (expression!.count > 0) {
            let lastChar = expression![expression!.index(before:expression!.endIndex)]
            expression!.remove(at: expression!.index(before:expression!.endIndex))
            for i in 0..<4 {
                if (String(lastChar) == selectedNumButton[i].title(for: .normal)){
                    selectedNumButton[i].isEnabled = true
                    break
                }
            }
        }
        textField.text = expression
        doneButton.isEnabled = true
    }
    
    
    //action method for four number buttons
    @IBAction func enterNumber(_ sender: UIButton) {
        textField.text = textField.text! + sender.title(for: .normal)!
        sender.isEnabled = false
        doneButton.isEnabled = true
    }
    //action method for clear icon in Action Bar
    @IBAction func reset(_ sender: UIBarButtonItem) {
        textField.text = ""
        for i in 0..<4 {
            selectedNumButton[i].isEnabled = true
        }
        doneButton.isEnabled = true
    }
    //action method for skip icon in Action Bar
    @IBAction func skipPuzzle(_ sender: UIBarButtonItem) {
        //reset the timer
        
        //set counters as 0s
        
        //reassign new 4 random numbers
        generateFourNumbers()
    }
    
    private func generateFourNumbers() -> Void {
        var random = fourRandomNum()
        while (getSolution(inputArray: random) == "") {
            random = fourRandomNum()
        }
        for i in 0..<4 {
            selectedNumButton[i].setTitle(String(random[i]), for: .normal)
            selectedNumButton[i].isEnabled = true
        }
        textField.text = ""
        attemptCount = 1
        attemptLabel.text = String(attemptCount)
        doneButton.isEnabled = false
        //reset timer
        
    }
   
    @IBAction func calculate(_ sender: UIButton) ->Void {
        let expression = textField.text
        attemptCount += 1
        
        if (checkValid(expression: expression!)) {
            guard let result = NSExpression(format: expression!).expressionValue(with: nil, context: nil) as? Double else {
                return
            }
            if (bingo(x: result)){
                successCount += 1
                attemptCount = 1
                textField.text = ""
                //show alert: "Bingo" + expression + "= 24"
                }
        }else {
            print("try again")
            //show snackbar for "please try again"
        }
        doneButton.isEnabled = false
        updateCounts(f: failureCount, s: successCount, a: attemptCount)
        
    }
    
    private func updateCounts(f: Int, s: Int, a: Int) ->Void {
        successLabel.text = String(s)
        failedLabel.text = String(f)
        attemptLabel.text = String(a)
    }
}


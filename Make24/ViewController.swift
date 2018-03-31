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
    
    @IBOutlet weak var timerLabel: UILabel!
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
    var attemptCount = 1
    var successCount = 0
    var failureCount = 0
    var timer = Timer()
    var seconds = 0
    
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
        
        //generate four random numbers
        generateFourNumbers()
        //empty textField and set counts and timer
        setUp()
        updateCounts(f: failureCount, s: successCount, a: attemptCount)
    
    }
    
    private func startTimer() {
        seconds = 0
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerResult), userInfo: nil, repeats: true)
    }
    private func setUp() -> Void {
        textField.text = ""
        attemptCount = 1
        doneButton.isEnabled = false
        startTimer()
    }
    
    @objc func timerResult() {
        seconds += 1
        let min = seconds / 60 % 60
        let sec = seconds % 60
        timerLabel.text = String(format:"%02i:%02i", min, sec)
    }

    @IBAction func slideWindow(_ sender: UIBarButtonItem) {
        sliding()
    }
    
    private func sliding() {
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
                if (String(lastChar) == selectedNumButton[i].title(for: .normal) && !selectedNumButton[i].isEnabled){
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
        //reassign new 4 random numbers
        generateFourNumbers()
        
        //set up other timer, counts, empty textField
        setUp()
        failureCount += 1
        updateCounts(f: failureCount, s: successCount, a: attemptCount)
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
    }
    //action method for Done button
    @IBAction func calculate(_ sender: UIButton) ->Void {
        let expression = textField.text
        attemptCount += 1
        print(expression!)
        if (checkValid(expression: expression!)) {
            guard let result = NSExpression(format: expression!).expressionValue(with: nil, context: nil) as? Double else {
                return
            }
            if (bingo(x: result)){
                successCount += 1
                //show alert: "Bingo" + expression + "= 24"
                let alert = UIAlertController(title:nil, message:"Bingo! \(expression!) = 24 ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"Next Puzzle", style: .default, handler: { action in
                    self.generateFourNumbers()
                    self.setUp()
                }))
                self.present(alert, animated: true)
                }
        }else {
            print("try again")
            //show snackbar (alert) for "please try again"
            let alert = UIAlertController(title:nil, message:"Incorrect. Please try again!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { action in
                self.attemptCount += 1
                self.doneButton.isEnabled = false
            }))
            self.present(alert, animated: true)
        }
        updateCounts(f: failureCount, s: successCount, a: attemptCount)
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        var nums = [Int]()
        for i in 0..<4 {
            nums.append(Int(selectedNumButton[i].title(for: .normal)!)!)
        }
        let solution = getSolution(inputArray: nums)
        var expression : String
        if (solution != "") {
            expression = "The correct answer is: \(solution)."
        } else {
            expression = "Sorry, there are actually no solutions."
        }
        let alert = UIAlertController(title:nil, message:"\(expression)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Next Puzzle", style: .default, handler: { action in
            
                    self.generateFourNumbers()
                    self.setUp()
                    self.failureCount += 1
                    self.updateCounts(f: self.failureCount, s: self.successCount, a: self.attemptCount)
            
        }))
        self.present(alert, animated: true)
        //slide back navigation window
        sliding()
    }
    
    @IBAction func numberPick(_ sender: UIButton) {
        
    }
    
    private func updateCounts(f: Int, s: Int, a: Int) ->Void {
        successLabel.text = String(s)
        failedLabel.text = String(f)
        attemptLabel.text = String(a)
    }
    
    //unwind segue
    @IBAction func unWindAction(_ segue: UIStoryboardSegue) {
        if let origin = segue.source as? PickerViewController {
            let data = origin.data
            for i in 0..<4 {
                selectedNumButton[i].setTitle(data[i], for: .normal)
                selectedNumButton[i].isEnabled = true
            }
            failureCount += 1
            setUp()
            updateCounts(f: failureCount, s: successCount, a: attemptCount)
            sliding()
        }
    }
}


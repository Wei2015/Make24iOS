//
//  PickerViewController.swift
//  Make24
//
//  Created by MacBookPro13 on 3/29/18.
//  Copyright © 2018 edu.sjsu.CMPE277. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var numberPicker: UIPickerView!
    @IBOutlet weak var firstNum: UIButton!
    @IBOutlet weak var secondNum: UIButton!
    @IBOutlet weak var thirdNum: UIButton!
    @IBOutlet weak var fourthNum: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    var selectedNum = [UIButton]()
    var pickerData : [[Int]] = []
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numberPicker.delegate = self
        self.numberPicker.dataSource = self
        
        //Input data into the array
        for i in 0...3 {
            pickerData.append([])
            for j in 1...9 {
                pickerData[i].append(j)
            }
        }

        //add number buttons to array
        selectedNum.append(firstNum)
        selectedNum.append(secondNum)
        selectedNum.append(thirdNum)
        selectedNum.append(fourthNum)
        
        //set number buttons all 1s
        for i in selectedNum.indices {
           selectedNum[i].setTitle("1", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    //the number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    //the number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    //the data to return for the row and component(column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[component][row])
    }
    //capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedNum[component].setTitle(String(pickerData[component][row]), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        data = getSelectedNum()
    
    }
    
    private func getSelectedNum() -> [String] {
        var selected = [String]()
        for i in selectedNum.indices {
            selected.append(selectedNum[i].title(for: .normal)!)
        }
        return selected
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

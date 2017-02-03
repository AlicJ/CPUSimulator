//
//  InstructionBlockViewController.swift
//  CPUSimulator
//
//  Created by Eric Xiao on 2016-09-01.
//  Copyright © 2016 4ZC3. All rights reserved.
//

import UIKit

class InstructionBlockController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    fileprivate var instructionBlockView = InstructionBlockView(frame: CGRect(x: 400, y: (700-2*240), width: 600, height: 240))
    fileprivate var level = 0
    fileprivate var programCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionBlockView.delegate = self
        instructionBlockView.dataSource = self
        instructionBlockView.isUserInteractionEnabled = false
        instructionBlockView.layer.borderWidth = 2
        instructionBlockView.layer.borderColor = UIColor.red.cgColor
        super.view.addSubview(instructionBlockView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LEVELS[level].count
    }
 
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent col: Int) -> String? {
        switch LEVELS[level][row] {
        case let .load           (rg1, rg2, rg3):
            return instructionToString(row, "Load", [rg1, rg2, rg3])
        case let .store          (rg1, rg2, rg3):
            return instructionToString(row, "Store", [rg1, rg2, rg3])
        case let .loadImmediate  (rg, val):
            return instructionToString(row, "LoadImmediate", [rg, val])
        case let .add            (rg1, rg2, rg3):
            return instructionToString(row, "Add", [rg1, rg2, rg3])
        case let .multiply       (rg1, rg2, rg3):
            return instructionToString(row, "Multiply", [rg1, rg2, rg3])
        case let .and            (rg1, rg2, rg3):
            return instructionToString(row, "And", [rg1, rg2, rg3])
        case let .or             (rg1, rg2, rg3):
            return instructionToString(row, "Or", [rg1, rg2, rg3])
        case let .not            (rg1, rg2):
            return instructionToString(row, "Not", [rg1, rg2])
        case let .rotate         (rg1, rg2, val):
            return instructionToString(row, "Rotate", [rg1, rg2, val])
        case let .compare        (rg1, rg2):
            return instructionToString(row, "Compare", [rg1, rg2])
        case let .branch         (condition, rg1):
            return instructionToString(row, "Branch", condition, rg1)
        case .halt:
            return instructionToString(row, "Halt", [])
        }
    }
    
    // ================
    // CUSTOM FUNCTIONS
    // ================
    
    internal func getCurrentInstruction() -> Instruction {
        return LEVELS[level][programCounter]
    }
    
    fileprivate func instructionToString(_ row: Int, _ name: String, _ values: [Int]) -> String {
        var valueString = ""

            for v in values {
                valueString += String(v).evenPadding(toLength: 3, withPad: " ")
            }
        return String(row).evenPadding(toLength: 3, withPad: " ") + name.evenPadding(toLength: 20, withPad: " ") + valueString
    }
    
    fileprivate func instructionToString(_ row: Int, _ name: String, _ condition: String, _ value: Int) -> String {
            return String(row).evenPadding(toLength: 3, withPad: " ") + name.evenPadding(toLength: 20, withPad: " ") + condition.evenPadding(toLength: 3, withPad: " ") + String(value).evenPadding(toLength: 3, withPad: " ")
    }
    
    fileprivate func pickerSelectRow(_ row: Int, animated: Bool) {
        for i in 0...(instructionBlockView.numberOfComponents - 1) {
            instructionBlockView.selectRow(row, inComponent: i, animated: animated)
        }
    }
    
    internal func nextStage () {
        // still in the same level
        if(programCounter < LEVELS[level].count - 1) {
            programCounter += 1
            // move picker items down by 1
            pickerSelectRow(programCounter, animated: true)
        }
            // move to next level
        else {
            nextLevel()
        }
    }
    
    // reload the view with new components equal to new level
    fileprivate func nextLevel() {
        if level == LEVELS.count - 1 {
            return
        }
        level += 1
        programCounter = 0
        instructionBlockView.reloadAllComponents()
        pickerSelectRow(0, animated: false)
    }
    
    internal func disableScrolling(){
        instructionBlockView.isUserInteractionEnabled = false
    }
    
    internal func enableScrolling(){
        instructionBlockView.isUserInteractionEnabled = true
    }

}

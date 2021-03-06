//
//  InstructionBlockViewController.swift
//  CPUSimulator
//
//  Created by Eric Xiao on 2016-09-01.
//  Copyright © 2016 4ZC3. All rights reserved.
//

import UIKit

protocol InstructionBlockDelegate {
    func onSuccessBranch()
    func endGame()
}

class InstructionBlockController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    fileprivate var instructionBlockView = UIPickerView(frame: Sizes.instructionBlock.frame)
    fileprivate var level: Int = 0
    fileprivate var programCounter: Int = 0
    internal var jumpTo: Int? = nil
    fileprivate var outOfInstructions: Bool = false
    
    var delegate: InstructionBlockDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        instructionBlockView.backgroundColor = Sizes.debugColor
        instructionBlockView.layer.borderWidth = 1
        
        instructionBlockView.delegate = self
        instructionBlockView.dataSource = self
        self.disableScrolling()
        self.view.addSubview(instructionBlockView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Sizes.instructionBlock.rowHeight
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LEVELS[level].count
    }
    
    // on row select
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == jumpTo!{
            self.programCounter = jumpTo! - 1
            self.disableScrolling()
            self.jumpTo = nil
            delegate?.onSuccessBranch()
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent col: Int) -> String? {
        switch LEVELS[level][row] {
        case let .load           (rg1, rg2):
            return instructionToString(row: row, instr: "Load", values: [rg1, rg2])
        case let .store          (rg1, rg2):
            return instructionToString(row: row, instr: "Store", values: [rg1, rg2])
        case let .loadImmediate  (rg, val):
            return instructionToString(row: row, instr: "LoadImmediate", values: [rg, val])
        case let .add            (rg1, rg2, rg3):
            return instructionToString(row: row, instr: "Add", values: [rg1, rg2, rg3])
        case let .multiply       (rg1, rg2, rg3):
            return instructionToString(row: row, instr: "Multiply", values: [rg1, rg2, rg3])
        case let .and            (rg1, rg2, rg3):
            return instructionToString(row: row, instr: "And", values: [rg1, rg2, rg3])
        case let .or             (rg1, rg2, rg3):
            return instructionToString(row: row, instr: "Or", values: [rg1, rg2, rg3])
        case let .not            (rg1, rg2):
            return instructionToString(row: row, instr: "Not", values: [rg1, rg2])
        case let .rotate         (rg1, rg2, val):
            return instructionToString(row: row, instr: "Rotate", values: [rg1, rg2, val])
        case let .compare        (rg1, rg2):
            return instructionToString(row: row, instr: "Compare", values: [rg1, rg2])
        case let .branch         (condition, rg1):
            return instructionToString(row: row, name: "Branch", condition: condition, value: rg1)
        case .halt:
            return instructionToString(row: row, instr: "Halt", values: [])
        }
    }
    
    
    
    internal func getCurrentInstruction() -> Instruction? {
        if self.outOfInstructions {
            return nil;
        }
        return LEVELS[level][programCounter]
    }
    
    fileprivate func instructionToString(row: Int, instr: String, values: [Int]) -> String {
        var valueString = ""
        for v in values {
            valueString += String(v).evenPad(toLength: 3, withPad: " ")
        }
        let str = String(row).leftPad(toLength: 2, withPad: " ") + instr.evenPad(toLength: 20, withPad: " ") + valueString
//        print (".\(str).")

        return str
    }
    
    fileprivate func instructionToString(row: Int, name: String, condition: String, value: Int) -> String {
        let str = String(row).padding(toLength: 2, withPad: " ", startingAt: 0) + name.evenPad(toLength: 20, withPad: " ") + condition.evenPad(toLength: 3, withPad: " ") + String(value).evenPad(toLength: 3, withPad: " ")
//        print (".\(str).")
        return str
    }
    
    internal func nextStage () {
        if(programCounter < LEVELS[level].count - 1) {
            programCounter += 1
            instructionBlockView.selectRow(programCounter, inComponent: 0, animated: true)
        }
        else {
            nextLevel()
        }
    }
    
    fileprivate func nextLevel() {
        if level == LEVELS.count - 1 {
            self.outOfInstructions = true
            delegate!.endGame()
            return
        }
        level += 1
        programCounter = 0
        instructionBlockView.reloadAllComponents()
        instructionBlockView.selectRow(programCounter, inComponent: 0, animated: true)
    }
    
    internal func disableScrolling(){
        instructionBlockView.isUserInteractionEnabled = false
    }
    
    internal func enableScrolling(){
        instructionBlockView.isUserInteractionEnabled = true
    }
    
    internal func isRowSelected(_ selectetd: Int) {
        
    }
    
}

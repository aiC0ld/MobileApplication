//
//  ViewController.swift
//  WA2_Han_4294
//
//  Created by Xinyue Han on 9/19/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var firstNumberTextField: UITextField!
    @IBOutlet var secondNumberTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var subtractButton: UIButton!
    @IBOutlet var multiplyButton: UIButton!
    @IBOutlet var divideButton: UIButton!
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstNumberTextField.keyboardType = .decimalPad
        secondNumberTextField.keyboardType = .decimalPad
        
        addButton.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
        subtractButton.addTarget(self, action: #selector(onSubtractButtonTapped), for: .touchUpInside)
        multiplyButton.addTarget(self, action: #selector(onMultiplyButtonTapped), for: .touchUpInside)
        divideButton.addTarget(self, action: #selector(onDivideButtonTapped), for: .touchUpInside)
    }

    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error!",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
        resultLabel.text = "Result"
    }
    
    func getInputNumbers() -> (Double, Double)? {
        guard let firstNumberText = firstNumberTextField.text, !firstNumberText.isEmpty,
              let secondNumberText = secondNumberTextField.text, !secondNumberText.isEmpty
        else {
            showErrorAlert(message: "Error! The numbers cannot be empty!")
            return nil
            }
        guard let firstNumber = Double(firstNumberText) else {
            showErrorAlert(message: "Error! The input numbers are invalid.")
            return nil
        }
        guard let secondNumber = Double(secondNumberText) else {
            showErrorAlert(message: "Error! The input numbers are invalid.")
            return nil
        }
        return (firstNumber, secondNumber)
    }
    
    @objc func onAddButtonTapped() {
        if let (firstNumber, secondNumber) = getInputNumbers() {
            let result = firstNumber + secondNumber
            resultLabel.text = String(format: "%.2f", result)
        }
    }
    
    @objc func onSubtractButtonTapped() {
        if let (firstNumber, secondNumber) = getInputNumbers() {
            let result = firstNumber - secondNumber
            resultLabel.text = String(format: "%.2f", result)
        }
    }
    
    @objc func onMultiplyButtonTapped() {
        if let (firstNumber, secondNumber) = getInputNumbers() {
            let result = firstNumber * secondNumber
            resultLabel.text = String(format: "%.2f", result)
        }
    }
    
    @objc func onDivideButtonTapped() {
        if let (firstNumber, secondNumber) = getInputNumbers() {
            if secondNumber == 0 {
                showErrorAlert(message: "Error! Cannot divide by zero.")
            } else {
                let result = firstNumber / secondNumber
                resultLabel.text = String(format: "%.2f", result)
            }
        }
    }
}

//
//  KeypadViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/22/25.
//

import UIKit

class KeypadViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var buttonMult: UIButton!
    @IBOutlet weak var buttonHash: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonCall: UIButton!
    
    var enteredNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        styleButtons()
    }
    private func styleButtons() {
        let buttons: [UIButton] = [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9, buttonCall, buttonMult, buttonHash, buttonBack]

        for button in buttons {
            button.layer.cornerRadius = button.frame.size.width / 2
            button.clipsToBounds = true
        }
    }

    @IBAction func numberButtonTapped(_ sender: UIButton) {
        guard let digit = sender.titleLabel?.text, enteredNumber.count < 10 else { return }
        enteredNumber.append(digit)
        updateNumberLabel()
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard !enteredNumber.isEmpty else { return }
        enteredNumber.removeLast()
        updateNumberLabel()
    }

    @IBAction func callButtonTapped(_ sender: UIButton) {
        if enteredNumber.count == 10 {
            showCallAlert()
        } else {
            showIncompleteNumberAlert()
        }
    }

    private func updateNumberLabel() {
        numberLabel.text = enteredNumber
    }

    private func showCallAlert() {
        let alert = UIAlertController(title: "Calling", message: "You are calling \(enteredNumber)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    private func showIncompleteNumberAlert() {
        let alert = UIAlertController(title: "Invalid Number", message: "Please enter a 10-digit number before calling.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

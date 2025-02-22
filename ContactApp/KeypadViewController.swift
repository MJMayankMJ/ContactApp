//
//  KeypadViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/22/25.
//

import UIKit

class KeypadViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel! // Label to display entered numbers

    var enteredNumber: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
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

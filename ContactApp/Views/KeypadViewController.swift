//
//  KeypadViewController.swift
//  ContactApp
//
//  Created by Mayank Jangid on 2/22/25.
//

import UIKit

class KeypadViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    
    // Numeric buttons (including "*" and "#")
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var buttonMult: UIButton!
    @IBOutlet weak var buttonHash: UIButton!
    
    // Icon buttons (call & back)
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    
    var enteredNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // No programmatic layout adjustments here since we rely on the storyboard
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyCornerRadius()
    }
    
    // Only apply the corner radius programmatically
    private func applyCornerRadius() {
        // List all buttons
        let buttons: [UIButton] = [button0, button1, button2, button3, button4,
                                     button5, button6, button7, button8, button9,
                                     buttonMult, buttonHash, buttonBack, buttonCall]
        for button in buttons {
            // Make the button circular by setting the corner radius to half its width.
            button.layer.cornerRadius = button.bounds.width / 2
            button.clipsToBounds = true
        }
    }
    
    // MARK: - Actions
    
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

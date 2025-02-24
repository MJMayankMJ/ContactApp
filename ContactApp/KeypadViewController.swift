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
    @IBOutlet weak var emptyButton: UIButton!
    
    var enteredNumber: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonConstraints()
        adjustButtonSizes()
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

// this is not ideal ... i think
extension KeypadViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let buttons: [UIButton] = [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9, buttonCall, buttonMult, buttonHash, buttonBack, emptyButton]
        let iconButtons: [UIButton] = [buttonCall, buttonBack]
        
        for button in buttons {
            button.layoutIfNeeded()  // Force layout updates
            button.layer.cornerRadius = button.frame.width / 2
            button.clipsToBounds = true
            
            // Adjust font size dynamically based on button width
            let fontSize = button.frame.width * 0.4
            button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        }
        
        for button in iconButtons {
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.frame.width / 2
            button.clipsToBounds = true
            
            // Force image to maintain aspect ratio
            if let imageView = button.imageView {
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.4),
                    imageView.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.4),
                    imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                    imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
                ])
            }
        }
        
    }
    private func setupButtonConstraints() {
        let buttons: [UIButton] = [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9, buttonCall, buttonMult, buttonHash, buttonBack, emptyButton]
            guard let firstButton = buttons.first else { return }

            for button in buttons {
                // Set Equal Width to First Button
                button.translatesAutoresizingMaskIntoConstraints = false
                button.widthAnchor.constraint(equalTo: firstButton.widthAnchor).isActive = true
                button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            }
        }
    
    private func adjustButtonSizes() {
        let buttons: [UIButton] = [button0, button1, button2, button3, button4, button5, button6, button7, button8, button9, buttonCall, buttonMult, buttonHash, buttonBack, emptyButton]
        let screenWidth = UIScreen.main.bounds.width
        let buttonSize = screenWidth / 6
        
        for button in buttons {
            button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true // Square buttons
            // Make Button Round
            button.layer.cornerRadius = button.frame.size.width / 2
            button.clipsToBounds = true
        }

    }

}

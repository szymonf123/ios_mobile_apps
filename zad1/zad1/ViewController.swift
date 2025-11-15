//
//  ViewController.swift
//  zad1
//
//  Created by user279406 on 11/8/25.
//

import UIKit

class ViewController: UIViewController {
    
    var a: Float = 0.0
    var b: Float = 0.0
    var operation: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var label_result: UILabel!
    @IBAction func button0(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "0"
    }
    @IBAction func button1(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "1"
    }
    @IBAction func button2(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "2"
    }
    @IBAction func button3(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "3"
    }
    @IBAction func button4(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "4"
    }
    @IBAction func button5(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "5"
    }
    @IBAction func button6(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "6"
    }
    @IBAction func button7(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "7"
    }
    @IBAction func button8(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "8"
    }
    @IBAction func button9(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "9"
    }
    @IBAction func button_eq(_ sender: Any) {
        b = Float(label_result.text ?? "") ?? 0.0
        if (operation == "+"){
            label_result.text = String(a + b)
        }
        else if (operation == "-"){
            label_result.text = String(a - b)
        }
        else if (operation == "*"){
            label_result.text = String(a * b)
        }
        else if (operation == "/"){
            if (b != 0){
                label_result.text = String(a / b)
            }
            else{
                label_result.text = ""
                let alert = UIAlertController(title: "Uwaga!",
                                                  message: "Nie mozna dzielic przez 0",
                                                  preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "OK", style: .default))

                    present(alert, animated: true)
            }
        }
    }
    @IBAction func button_dot(_ sender: Any) {
        label_result.text = (label_result.text ?? "") + "."
    }
    @IBAction func buttonC(_ sender: Any) {
        label_result.text = ""
        operation = ""
    }
    @IBAction func button_add(_ sender: Any) {
        a = Float(label_result.text ?? "") ?? 0.0
        label_result.text = ""
        operation = "+"
    }
    @IBAction func button_subtract(_ sender: Any) {
        a = Float(label_result.text ?? "") ?? 0.0
        label_result.text = ""
        operation = "-"
    }
    @IBAction func button_multiply(_ sender: Any) {
        a = Float(label_result.text ?? "") ?? 0.0
        label_result.text = ""
        operation = "*"
    }
    @IBAction func button_divide(_ sender: Any) {
        a = Float(label_result.text ?? "") ?? 0.0
        label_result.text = ""
        operation = "/"
    }
}


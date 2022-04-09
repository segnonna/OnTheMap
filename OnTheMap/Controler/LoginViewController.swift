//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Segnonna Hounsou on 09/04/2022.
//

import Foundation
import UIKit

class LoginViewController: UIViewController{
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        loginButton.isEnabled = false
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        setLogIn(true)
        OnMapClient.login(username: emailTextField?.text ?? "", password: passwordTextField?.text ?? "") { data, error in
            self.setLogIn(false)
            if data {
                print(OnMapClient.Sessions.sessionId)
                let storyboard = UIStoryboard (name: "Main", bundle: nil)
                let resultVC = storyboard.instantiateViewController(withIdentifier: "SuccessTabBarController")
                self.navigationController?.pushViewController(resultVC, animated: true)
            } else {
                let alertVC = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController?.topViewController?.present(alertVC, animated: true)
            }
        }
    }
    
    @IBAction func emailChanged(_ sender: Any) {
        enableOrDisableButton()
    }
    @IBAction func passwordChanged(_ sender: Any) {
        enableOrDisableButton()
    }
    
    private func enableOrDisableButton() {
        loginButton.isEnabled = !(emailTextField.text?.isEmpty ?? false) && !(passwordTextField.text?.isEmpty ?? false)
    }
    
    private func setLogIn(_ loggIn: Bool){
        if loggIn {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
        self.loginButton.isHidden = loggIn
    }
    
}

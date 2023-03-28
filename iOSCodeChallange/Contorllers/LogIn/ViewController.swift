//
//  ViewController.swift
//  iOSCodeChallange
//
//  Created by mac on 2023-03-25.
//

import UIKit
import Security

class ViewController: UIViewController {
    
    //MARK: - Proprties
    
    let networkService = StubNetworkService()
    let alertTitleText = "Invalid Email"
    let alertMessageText = "This email address is not available. Choose a different address."
    let alertActionTitleText = "OK"
    var isChecked = false
    let userDafeult = UserDefaults.standard
    
    //MARK: - Outlet
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField! {
        didSet {
            userPasswordTextField.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 15
            loginButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var checkedButton: UIButton! {
        didSet {
            checkedButton.layer.borderWidth = 1
            checkedButton.layer.borderColor = UIColor.systemGreen.cgColor
            checkedButton.layer.cornerRadius = 5
        }
    }
    
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCredentials()
    }
    
    //MARK: - IBAction
    
    @IBAction func checkBoxBtnPressed(_ sender: Any) {
        isChecked = !isChecked
        if isChecked {
            checkedButton.layer.backgroundColor = UIColor.systemGreen.cgColor
            saveCredential()
        } else {
            checkedButton.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        logIn()
        goToCalendarVC()
    }
    
    //MARK: - Methods
    
    func deleteCredentials() {
        userDafeult.removeObject(forKey: "username")
        Keychain().deleteCredentials()
    }
    
    func getCredentials() {
        guard let userEmail = userDafeult.value(forKey: "username") as? String else {
            print("Failed to read user email from user defaults")
            return
        }
        guard let data = Keychain().getCredentials(account: userEmail) else {
            print("Failed to read password")
            return
        }
        let password = String(decoding: data, as: UTF8.self)
        
        userEmailTextField.text = userEmail
        userPasswordTextField.text = password
    }
    
    func saveCredential() {
        let userEmail = userEmailTextField.text ?? ""
        let password = userPasswordTextField.text ?? ""
        
        if userEmail.isEmpty || password.isEmpty {
            return
        }
        deleteCredentials()
        userDafeult.set(userEmail, forKey: "username")
        Keychain().saveCredentials(username: userEmail, password: password)
    }
    
    func createAlert() {
        self.createAlert(alertTitle: alertTitleText,
                         alertMessage: alertMessageText,
                         alertActionTitle: alertActionTitleText)
    }
    
    func goToCalendarVC() {
        let calendarVC = UIStoryboard(name: "Calendar",
                                      bundle: .main)
            .instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    func logIn() {
        let email = userEmailTextField.text ?? ""
        let password = userPasswordTextField.text ?? ""
        if email.isEmpty || password.isEmpty || Validate().validateEmailId(emailID: email) == false {
            createAlert()
            return
        }
        
        networkService.makeLogIn { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
            }
        }
    }
}


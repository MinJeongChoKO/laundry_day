//
//  SignUpViewController.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 4. 14..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var userProfileImage: UIImageView!
    
    var selectedImage: UIImage?
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userContactTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileImage.layer.cornerRadius = 50
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage))
        userProfileImage.addGestureRecognizer(tapGesture)
        userProfileImage.isUserInteractionEnabled = true
        
        signUpButton.backgroundColor = UIColor.lightGray
        signUpButton.isEnabled = false
        handleTextField()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextField() {
        userEmailTextField.addTarget(self, action: #selector(self.textFieldChanged), for: UIControlEvents.editingChanged)
        userPasswordTextField.addTarget(self, action: #selector(self.textFieldChanged), for: UIControlEvents.editingChanged)
        userNameTextField.addTarget(self, action: #selector(self.textFieldChanged), for: UIControlEvents.editingChanged)
        userContactTextField.addTarget(self, action: #selector(self.textFieldChanged), for: UIControlEvents.editingChanged)

        
    }
    
    @objc func textFieldChanged() {
        guard  let email = userEmailTextField.text, !email.isEmpty, let password = userPasswordTextField.text, !password.isEmpty, let name = userNameTextField.text, !name.isEmpty, let contact = userContactTextField.text, !contact.isEmpty else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.lightGray
            return
        }
        signUpButton.isEnabled = true
        signUpButton.backgroundColor = UIColor.darkGray

    }
    
    @objc func handleSelectProfileImage() {
        let imagePickerController = UIImagePickerController()
        present(imagePickerController,animated: true, completion: nil)
        imagePickerController.delegate = self
    }
    
    @IBAction func signUpButton_TUI(_ sender: Any) {
    }
    
    
    
    
    @IBAction func logInButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            userProfileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


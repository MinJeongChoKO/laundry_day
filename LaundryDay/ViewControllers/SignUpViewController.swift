//
//  SignUpViewController.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 4. 14..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

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
        
        //디폴트이미지 누르면 이미지 선택하도록
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage))
        userProfileImage.addGestureRecognizer(tapGesture)
        userProfileImage.isUserInteractionEnabled = true
        
        signUpButton.backgroundColor = UIColor.lightGray
        signUpButton.isEnabled = false
        handleTextField()

    }
    
    //키보드 내리기
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
        //print(ref.description()) //https://laundryday-4027f.firebaseio.com
        Auth.auth().createUser(withEmail: userEmailTextField.text!, password: userPasswordTextField.text!, completion: {(user: User?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            let uid = user?.uid
            
            //스토리지에 유저 uid로 하위폴더 만들어서 이미지 넣음
            let storageRef = Storage.storage().reference(forURL: "gs://laundryday-4027f.appspot.com").child("profileImg").child(uid!)
            if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
                storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                    if error != nil {
                        return
                    }
                    let profileImgURL = metadata?.downloadURL()?.absoluteString
                    
                    self.setUserInfo(userName: self.userNameTextField.text!, email: self.userEmailTextField.text!, contact: self.userContactTextField.text!, profileImgURL: profileImgURL!, uid: uid!)
                })
            }
            
            
        })
        
        
    }
    func setUserInfo(userName: String, email: String, contact: String, profileImgURL: String, uid: String) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users")
        let newUserRef = usersRef.child(uid)
        newUserRef.setValue(["userName": userName, "email": email, "contact": contact, "profileImgURL": profileImgURL])
    }
    
    
    
    //다시 sign in VC 로
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


//
//  addClothesViewController.swift
//  LaundryDay
//
//  Created by MBP03 on 2018. 4. 27..
//  Copyright © 2018년 MBP03. All rights reserved.
//

import UIKit
import ProgressHUD
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class AddClothesViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(self.handleSelectImage))
        productImageView.addGestureRecognizer(tapGesture)
        productImageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }

    @objc func handleSelectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "카메라", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                pickerController.sourceType = .camera
                self.present(pickerController,animated: true, completion: nil)
            } else {
                print("카메라가 비활성화 되어있습니다.")
            }
            }))
        actionSheet.addAction(UIAlertAction(title: "앨범", style: .default, handler: {(action: UIAlertAction) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController,animated: true,completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(actionSheet,animated: true,completion: nil)
        
    }
    
    @IBAction func uploadButton_TUI(_ sender: Any) {
        ProgressHUD.show("Waiting")
        if let productImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(productImg, 0.1) {
            let imageString = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: Config.STROAGE_ROOT_REF).child("clothes").child(imageString)
            storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                let productImgURL = metadata?.downloadURL()?.absoluteString
                guard let productNameText = self.productNameTextField.text else {
                    return
                }       //name안적으면 nil로 들어가는듯
                self.sendDataToDatabase(productImgUrl: productImgURL!,productName: productNameText)
            })
            
            
        } else {
            ProgressHUD.showError("Profile Image should be selected.")
        }
        
    }
    
    
    func sendDataToDatabase(productImgUrl:String, productName:String) {
        let ref = Database.database().reference()
        let clothesRef = ref.child("clothes")
        guard let currentUser = Auth.auth().currentUser else{
            return
        }
        let currentUserID = currentUser.uid
        let currentUserRef = clothesRef.child(currentUserID)
        let newClothesID = currentUserRef.childByAutoId().key
        let newClothesRef = currentUserRef.child(newClothesID)
        newClothesRef.setValue(["productImgUrl":productImgUrl, "productName": productName], withCompletionBlock: {(error, ref) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Success")
            self.dismiss(animated: true, completion: nil)

        })
    }
    
    //추가하기 창 취소
    @IBAction func cancelButton_TUI(_ sender: Any) {
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

extension AddClothesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            productImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}




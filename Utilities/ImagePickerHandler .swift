//
//  ImagePickerHandler.swift
//  DreamAI
//
//  Created by iApp on 08/12/22.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

enum PickerType: String{
    case camera, photoLibrary

}

class ImagePickerHandler:NSObject{
    static let shared = ImagePickerHandler()
    fileprivate var currentVC: UIViewController?
    
    //MARK: - Internal Properties
    var imagePickedHandler: ((UIImage) -> ())?
    
    
    //MARK: - showAttachmentActionSheet
    // This function is used to show the attachment sheet for image, video, photo and file.
    func showAttachmentActionSheet(vc: UIViewController) {
        currentVC = vc
        
//        let actionSheet = UIAlertController(title: "", message: Message.SELECT_OPTION, preferredStyle: .actionSheet)
//
////        actionSheet.addAction(UIAlertAction(title: Message.Camera, style: .default, handler: { (action) -> Void in
////            self.authorisationStatus(pickerType: .camera, vc: self.currentVC!)
////        }))
//
//        actionSheet.addAction(UIAlertAction(title: Message.GALLERY, style: .default, handler: { (action) -> Void in
//            self.authorisationStatus(pickerType: .photoLibrary, vc: self.currentVC!)
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: Message.Cancel, style: .cancel, handler: nil))
//        vc.present(actionSheet, animated: true, completion: nil)
        self.authorisationStatus(pickerType: .photoLibrary, vc: self.currentVC!)
    }
    
    
    //MARK: - Authorisation Status
    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(pickerType: PickerType, vc: UIViewController){
        currentVC = vc
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if pickerType == PickerType.camera{
                openCamera()
            }
            if pickerType == PickerType.photoLibrary{
                photoLibrary()
            }
        case .denied:
            print("permission denied")
            self.addAlertForSettings(pickerType)
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized{
                    // photo library access given
                    
                    if pickerType == PickerType.camera{
                        self.openCamera()
                    }
                    if pickerType == PickerType.photoLibrary{
                        self.photoLibrary()
                    }
                }else{
                    print("restriced manually")
                    self.addAlertForSettings(pickerType)
                }
            })
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings(pickerType)
        default:
            break
        }
    }
    
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        DispatchQueue.main.async {
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - PHOTO PICKER
    func photoLibrary(){
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
            
        }
    }
    
    //MARK: - SETTINGS ALERT
    func addAlertForSettings(_ attachmentTypeEnum: PickerType){
        DispatchQueue.main.async {
            var alertTitle: String = ""
            if attachmentTypeEnum == PickerType.camera{
                alertTitle = Message.CAMERA_ACCESS_MSG
            }
            if attachmentTypeEnum == PickerType.photoLibrary{
                alertTitle = Message.PHOTO_LIBRARY_ACCESS_MSG
            }
            
            let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: Message.Settings, style: .destructive) { (_) -> Void in
                let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: Message.Cancel, style: .default, handler: nil)
            cameraUnavailableAlertController .addAction(cancelAction)
            cameraUnavailableAlertController .addAction(settingsAction)
            self.currentVC?.present(cameraUnavailableAlertController , animated: true, completion: nil)
        }
    }
    
}

//MARK: - IMAGE PICKER DELEGATE
// This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension ImagePickerHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            
            if let image = info[.originalImage] as? UIImage {
                self.imagePickedHandler?(image)
                
            } else{
                print("Something went wrong in  image")
            }
            self.currentVC?.dismiss(animated: true, completion: nil)
        }
    }
}

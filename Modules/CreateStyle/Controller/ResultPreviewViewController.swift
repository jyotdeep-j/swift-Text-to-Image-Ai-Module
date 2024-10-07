//
//  ResultPreviewViewController.swift
//  DreamAI
//
//  Created by iApp on 04/11/22.
//

import UIKit
import SDWebImage

class ResultPreviewViewController: UIViewController {

    public var setImageUrl: String = ""
      
    @IBOutlet weak var shareMediaButton: UIButton!
    @IBOutlet weak var styleOutputImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setImageFromUrl(imageUrl: setImageUrl)
        
    }
    
    private func setImageFromUrl(imageUrl: String){
//        if let finalUrl = URL(string: imageUrl){
//            SwiftLoader.show(animated: true)
//            styleOutputImageView.sd_setImage(with: finalUrl, placeholderImage: UIImage(named: "imgPlaceholder"), options: .scaleDownLargeImages) { image, error, imageCacheType, url in
//                Helper.dispatchMain {
//                    SwiftLoader.hide()
//                }
//            }
////            styleOutputImageView.sd_setImage(with: finalUrl)
//        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareMediaOptionAction(_ sender: UIButton) {
        let resultVC = SaveShareMediaViewController.initiantiate(fromAppStoryboard: .Main)
//        resultVC.setImageUrl = self.setImageUrl
        resultVC.modalPresentationStyle = .overCurrentContext
        self.present(resultVC, animated: false)
//        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func saveMediaInGalleryAction(_ sender: UIButton) {
        guard let finalOutputImage = self.styleOutputImageView.image else {
            let ac = UIAlertController(title: "Save error", message: "No image to save", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
            
        }
        
        UIImageWriteToSavedPhotosAlbum(finalOutputImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                // we got back an error!
                let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Saved!", message: "Your AI image has been saved to your photos.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
}

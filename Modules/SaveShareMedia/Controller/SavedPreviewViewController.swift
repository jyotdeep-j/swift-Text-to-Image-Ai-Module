//
//  SavedPreviewViewController.swift
//  DreamAI
//
//  Created by iApp on 25/01/23.
//

import UIKit
import SDWebImage

class SavedPreviewViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = Bundle.main.url(forResource: "arrowgif", withExtension: "gif") else{return}
        
        gifImageView.sd_setImage(with: url)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.dismiss(animated: true)
        }
        
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}

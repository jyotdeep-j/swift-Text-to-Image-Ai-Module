//
//  HomeViewController.swift
//  DreamAI
//
//  Created by iApp on 01/11/22.
//

import UIKit
//import DropDown
import SDWebImage
class HomeViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var selectedStyleBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var placeholder = "Describe the image you want:"
//    let aiStyledropDown = DropDown()
    let textField = UITextField()
//    lazy var dropDowns: [DropDown] = {
//        return [
//            self.aiStyledropDown
//        ]
//    }()
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        self.textView.text = placeholder
        if placeholder == "Describe the image you want:" {
            textView.textColor = .lightGray
        } else {
            textView.textColor = .black
        }
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        setupDropDowns()
       /* dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        
        DropDown.setupDefaultAppearance()
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
        }*/
        
//        let item = aiStyledropDown.dataSource[0]
//        self.selectedStyleBtn.setTitle(item, for: .normal)
       
        // Do any additional setup after loading the view.
    }
    
    
    func setupDropDowns() {
        setUpAIStyle()
        
    }
    
    @IBAction func brnCrateAiImageAction(_ sender: UIButton) {
        
        if textView.text == placeholder || textView.text.isEmpty{
            let ac = UIAlertController(title: "Alert", message: "please enter text to draw image", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        //fetchhotpotApiData()
       // SwiftLoader.show(title: "", animated: true)
        self.view.endEditing(true)
//        SwiftLoader.show(animated: true)
        Helper.dispatchDelay(deadLine: .now() + 0.1) {
            self.fetchCutProApiData()
            
//            self.fetchhotpotApiData()
        }
        
       
    }
    
    @IBAction func btnSaveAiImage(_ sender: Any) {
        
        //self.imgView.image = UIImage(named: "imgPlaceholder")
        if self.imgView.image != nil{
            UIImageWriteToSavedPhotosAlbum(self.imgView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }else{
            let ac = UIAlertController(title: "Save error", message: "No image to save", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
       
       
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
   
    @IBAction func styleBtnAction(_ sender: UIButton) {
//        aiStyledropDown.show()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func fetchhotpotApiData() {
        var semaphore = DispatchSemaphore (value: 0)
        let style: String = selectedStyleBtn.currentTitle!
        let parameters = [
          [
            "key": "inputText",
            "value": textView.text!,
            "type": "text"
          ],
          [
            "key": "style",
            "value": style,
            "type": "text"
          ]] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if param["contentType"] != nil {
              body += "\r\nContent-Type: \(param["contentType"] as! String)"
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        
        
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://api.hotpot.ai/make-art")!,timeoutInterval: Double.infinity)
       // request.addValue("OLPWZ1KENRq9ZjBm5INU5wbP3U6rBUuWH6Z65w48as5pzOAvw3", forHTTPHeaderField: "Authorization")
        request.addValue("OLPWZ1KENRq9ZjBm5INU5wbP3U6rBUuWH6Z65w48as5pzOAvw3", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("String(describing: response)", response)
            DispatchQueue.main.async {
//                SwiftLoader.hide()
            }
            guard let data1 = data else {
            print(String(describing: error))
             
            semaphore.signal()
            return
          }
            if let img: UIImage = UIImage(data: data1) as? UIImage{
                Helper.dispatchMain {
                    self.imgView.image = img
                }
                
                
            }
            semaphore.signal()
         //print(String(data: data, encoding: .utf8)!)
         
        }
        task.resume()
        semaphore.wait()
    }
    
    
    
    
    func fetchCutProApiData() {
        var semaphore = DispatchSemaphore (value: 0)
        let searchedText = textView.text!
        let style = selectedStyleBtn.currentTitle!
       // let parameters = "{\n    \"prompt\": \"Rocket\"\n}"
        //let parameters = "{\n    \"prompt\": \"\(searchedText)\"\n}"
        
        
        //let parameters = "{\n    \"prompt\" : \"\(searchedText)\",\n    \"style\":  \"\(style)\"\n}"
        
        let parameters = "{\n    \"prompt\" : \"\(searchedText)\",\n    \"style\":  \"\(style)\"\n}"
        debugPrint("pareamter", parameters)
        
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://www.cutout.pro/api/v1/text2image")!,timeoutInterval: Double.infinity)
        request.addValue("f52927399f114cb69555bbcdd4d0beff", forHTTPHeaderField: "APIKEY")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ClientFlag=78bf5a5fdaaa4950804844f8f93ee7c9", forHTTPHeaderField: "Cookie")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let data1 = data else {
            print(String(describing: error))
              DispatchQueue.main.async {
                 // SwiftLoader.hide()
              }
            semaphore.signal()
            return
          }
            do {
                let json = try JSONSerialization.jsonObject(with: data1, options: [])
                let cutoutData = try JSONDecoder().decode(CutOutModel.self, from: data1)
                print("response data:", cutoutData)
                DispatchQueue.main.async {
//                    SwiftLoader.hide()
                }
                if let imgStringUrl = cutoutData.data{
//                    if let finalUrl = URL(string: imgStringUrl){
//                        self.imgView.sd_setImage(with: finalUrl) { image, error, type, url in
//                            
//                        }
//                    }
                }
                print(json)
            } catch {
                print(error)
                DispatchQueue.main.async {
//                    SwiftLoader.hide()
                }
            }
            
            
          //print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }
        task.resume()
        semaphore.wait()
           
            
    }
    
    

    
    //MARK:- TextView Delegates
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .lightGray {
                textView.text = nil
                textView.textColor = .black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = "Describe the image you want:"
                textView.textColor = UIColor.lightGray
               // placeholder = ""
            } else {
               // placeholder = textView.text
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            //placeholder = textView.text
        }
        
    
    
    
    func setUpAIStyle() {
    /*    aiStyledropDown.anchorView = selectedStyleBtn
        
        // Will set a custom with instead of anchor view width
        //        dropDown.width = 100
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
        aiStyledropDown.bottomOffset = CGPoint(x: 0, y: selectedStyleBtn.bounds.height)
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        aiStyledropDown.dataSource = [
                       "All",
                       "Hotpot Art 6",
                        "Hotpot Art 5",
                        "Hotpot Art 2",
                        "Photo General 1",
                        "Photo Volumetric 1",
                        "Fantasy 1",
                        "Fantasy 2",
                        "Anime 1",
                        "Anime Korean 1",
                        "Pixel Art",
                        "Comic Book 1",
                        "Sketch 1",
                        "Watercolor",
                        "Oil Painting",
                        "3D 1",
                        "Sculpture",
                        "Graffiti",
                        "Doom 2",
                        "Portrait 1",
                        "Portrait Game",
                        "Icon Black White",
                        "Icon Flat",
                        "Logo Clean 1",
                        "Logo Detailed 1",
                        "Acrylic Art",
                        "Architecture General 1",
                        "Architecture Interior 1",
                        "Charcoal 1",
                        "Sticker",
                        "Steampunk",
                        "Gothic",
                        "Illustration Flat",
                        "Illustration General",
                        "Line Art"
        ]*/
        
//        aiStyledropDown.dataSource = [
//            "Random",
//            "Concept Art",
//            "Realistic Anime",
//            "Photorealistic",
//            "Vector Art",
//            "Cute",
//            "West Coast",
//            "Photo",
//            "Dystopia",
//            "Fantasy",
//            "Cyber",
//            "Europa",
//            "Ethereal",
//            "Sci-Fi",
//            "Techpunk",
//            "Ghibli"
//        ]
        
       
        
        
        // Action triggered on selection
//        aiStyledropDown.selectionAction = { [weak self] (index, item) in
//            self?.selectedStyleBtn.setTitle(item, for: .normal)
//        }
        
//        aiStyledropDown.multiSelectionAction = { [weak self] (indices, items) in
//            print("Muti selection action called with: \(items)")
//            if items.isEmpty {
//                self?.selectedStyleBtn.setTitle("", for: .normal)
//            }
//        }
        
    }
}

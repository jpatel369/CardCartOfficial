//
//  DisplayReceiptsViewController.swift
//  CardCart
//
//  Created by Jay Patel on 7/18/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DisplayReceiptsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate  {
    var image: UIImage?
    var receipt: Receipt?
    

    @IBOutlet weak var rActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var receiptEnterTitle: UITextField!
    @IBOutlet weak var receiptEnterStore: UITextField!
    
    @IBOutlet weak var rImageView: UIImageView!
    @IBOutlet weak var receiptAddPhoto: AddPhotoR!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image = nil
        if let receipt = receipt {
            
            receiptEnterTitle.text = receipt.title
            receiptEnterStore.text = receipt.store
            resultTextView.text = receipt.info
            rImageView.image = receipt.image
            
        } else {
            
            receiptEnterTitle.text = ""
            receiptEnterStore.text = ""
            resultTextView.text = ""
            rImageView.image = nil
            
            receiptEnterStore.delegate = self
            receiptEnterTitle.delegate = self
            resultTextView.delegate = self
        }
        
            NotificationCenter.default.addObserver(self, selector: #selector(DisplayReceiptsViewController.keyboardWillGoUp(notification:)) , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(DisplayReceiptsViewController.keyboardWillGoDown(notification:)) , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            
            tap.delegate = self
            self.view.addGestureRecognizer(tap)
        }


        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            receiptEnterStore.resignFirstResponder()
            
            receiptEnterTitle.resignFirstResponder()
            return(true)
        }
        
        func keyboardWillGoUp(notification:NSNotification) {
            if let keyboardSize = (notification.userInfo? [UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= 30 //keyboardSize.height
            }
        }
        
        func keyboardWillGoDown(notification:NSNotification) {
            self.view.frame.origin.y = 0
        }
        
        func handleTap(_ gestureRecognizer: UIGestureRecognizer){
            
            //        if (enterBusinessCardCompany.text?.characters.count)! > 0 && (enterBusinessCardTitle.text?.characters.count)! == 0 {
            //            enterBusinessCardCompany.resignFirstResponder()
            //        } else {
            //            enterBusinessCardTitle.resignFirstResponder()
            //        }
            resultTextView.resignFirstResponder()
            receiptEnterStore.resignFirstResponder()
            receiptEnterTitle.resignFirstResponder()
        }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
       

    
    @IBAction func receiptAddPhotoButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
                
            }else {
                print("Camera Not Available")
            }
            
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
       rImageView.image = image
        
        callOCRSpace()
        
        


        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiptTableViewController = segue.destination as! ReceiptsTableViewController
        if segue.identifier == "saveR" {
            if let receipt = receipt {
                
                receipt.title = receiptEnterTitle.text ?? ""
                receipt.store = receiptEnterStore.text ?? ""
                receipt.info = resultTextView.text ?? ""
                receipt.image = rImageView.image ?? nil
                receiptTableViewController.tableView.reloadData()
                
                
            } else {
                // 3
                let newReceipt = Receipt()
                newReceipt.title = receiptEnterTitle.text ?? ""
                newReceipt.store = receiptEnterStore.text ?? ""
                newReceipt.info = resultTextView.text ?? ""
                newReceipt.image = rImageView.image ?? nil
                receiptTableViewController.receipts.append(newReceipt)
                
                CoreDataHelper.saveRecepitCard(title: newReceipt.title, store: newReceipt.store, info: newReceipt.info, image: newReceipt.image)
            }
        }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func resizeImageIfNeededAndReturnData(image: UIImage) -> Data {
        var imageData: Data = UIImageJPEGRepresentation(image, 1.0)!
        
        let bytes = Double(imageData.count)
        // Resize the image if it exceeds the 1MB API limit
        if (bytes / (1024*1024) > 0.99) {
            let oldSize: CGSize = image.size
            let newSize: CGSize = CGSize(width: 400, height: oldSize.height / oldSize.width * 400)
            imageData = resizeImage(newSize, image: image)
            return imageData
        } else {
            return imageData
        }
        
    }
    
    func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = UIImagePNGRepresentation(newImage!)
        UIGraphicsEndImageContext()
        return resizedImage!
 
    }

    
    
    func callOCRSpace() {
        // Create URL request
        let url: URL = URL(string: "https://api.ocr.space/Parse/Image")!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "randomString"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let session: URLSession = URLSession.shared
        
        // Image file and parameters
        let imageData = resizeImageIfNeededAndReturnData(image: self.image!)
        
        
        let parametersDictionary: [String : String] = ["apikey": "50a3c1170988957", "language": "eng", "isOverlayRequired": "True"]
        
        
        
        // Create multipart form body
        let imageName = self.image?.accessibilityIdentifier
       let data = self.createBodyWithBoundary(boundary: boundary, parameters: parametersDictionary, imageData: imageData, filename:  "\(imageName).jpg")
        self.image = nil
        
        request.httpBody = data as Data
       
        //start spin

        self.rActivityIndicator.startAnimating();
        
        // Start data session
        let task: URLSessionTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            //stop spinning
            self.rActivityIndicator.stopAnimating();
            
            guard error == nil else {
                print("\(#function): \(error!.localizedDescription)")
                
                //showAlertController with this error message
                return
            }
            
            guard data != nil else {
                print("\(#function): no data found )")
                //showAlertController with this error message
                return
            }
            
            
            
            do {
//                let result = try JSONSerialization.jsonObject(with: data!, options: [])
                let json = JSON(data)
                let parsedText = json["ParsedResults"][0]["ParsedText"].stringValue
                
                
                DispatchQueue.main.async {
                    self.resultTextView.text = parsedText
                }
                print(json)
                
                
                
                
            } catch let error as NSError {
                print("\(#function) \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func createBodyWithBoundary(boundary: String, parameters: [String : String], imageData data: Data, filename: String) -> Data {
        
        let body: NSMutableData = NSMutableData()
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\("file")\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(data)
        body.append("".data(using: String.Encoding.utf8)!)
        
        for key in parameters.keys {
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("\(parameters[key] ?? "")\r\n".data(using: String.Encoding.utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        return body as Data
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

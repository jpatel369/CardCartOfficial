//
//  DisplayBusinessCardsViewController.swift
//  CardCart
//
//  Created by Jay Patel on 7/18/17.
//  Copyright © 2017 JP Apps. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class DisplayBusinessCardsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    var image: UIImage?
    var businesscard: BusinessCardData?

    @IBOutlet weak var bcSaveActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bcActivityIndicator: UIActivityIndicatorView!
   @IBOutlet weak var addPhotoButton: AddPhotoButton!
    @IBOutlet weak var bcImageView: UIImageView!
   
    @IBOutlet weak var enterBusinessCardCompany: UITextField!
    @IBOutlet weak var enterBusinessCardTitle: UITextField!
    
    @IBOutlet weak var bcresultTextView: UITextView!
    
    // code for API
   // let apiKey = "e05343d8c98a1777"
    
   // var params: Parameters = [:]
    
    //var cardFrontImage = UIImage()

    @IBAction func saveButton(_ sender: Any)
    {
        performSegue(withIdentifier: "backToTableViewSegue", sender: self)

        
       //CoreDataHelper.saveBusinessCard(title: enterBusinessCardTitle.text!, company: enterBusinessCardCompany.text!, image: bcImageView.image!)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.image = nil
        
        if let businesscard = businesscard {
            
            enterBusinessCardTitle.text = businesscard.title
            enterBusinessCardCompany.text = businesscard.company
            bcresultTextView.text = businesscard.info
            if let imageData = businesscard.image,
            let savedImage = UIImage.init(data: imageData as Data) {
                bcImageView.image = savedImage
                self.image = savedImage
            }
            
        } else {
            
            enterBusinessCardTitle.text = ""
            enterBusinessCardCompany.text = ""
            bcresultTextView.text = ""
            bcImageView.image = nil
            
        }
        
        enterBusinessCardCompany.delegate = self
        enterBusinessCardTitle.delegate = self
        bcresultTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(DisplayBusinessCardsViewController.keyboardWillGoUp(notification:)) , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DisplayBusinessCardsViewController.keyboardWillGoDown(notification:)) , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterBusinessCardCompany.resignFirstResponder()
        enterBusinessCardTitle.resignFirstResponder()
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
     bcresultTextView.resignFirstResponder()
        enterBusinessCardCompany.resignFirstResponder()
        enterBusinessCardTitle.resignFirstResponder()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        
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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.image = image
        
        bcImageView.image = image
        
        callBcOCRSpace()
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let businessCardTableViewController = segue.destination as! BusinessCardTableViewController
        if segue.identifier == "backToTableViewSegue" {
            // Create new card
            if businesscard == nil {
                businesscard = CoreDataHelper.newBusinessCard()
                businessCardTableViewController.businesscards.append(businesscard!)
            }
            // Setting card values
            businesscard!.title = enterBusinessCardTitle.text ?? ""
            businesscard!.company = enterBusinessCardCompany.text ?? ""
            businesscard!.info = bcresultTextView.text ?? ""
            if let image = bcImageView.image,
                let imageData = UIImageJPEGRepresentation(image, 0.7) {
                businesscard!.image = imageData as NSData
            }
            // save to core data
            CoreDataHelper.save()
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
    
    
    
    func callBcOCRSpace() {
        // Create URL request
        let url: URL = URL(string: "https://api.ocr.space/Parse/Image")!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "randomString"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let session: URLSession = URLSession.shared
        
        // Image file and parameters
        let imageData = resizeImageIfNeededAndReturnData(image: self.image!)
        
        
        let parametersDictionary: [String : String] = ["apikey": "9b00d37cea88957", "language": "eng", "isOverlayRequired": "True"]
        
        
        
        // Create multipart form body
        let imageName = self.image?.accessibilityIdentifier
        let data = self.createBodyWithBoundary(boundary: boundary, parameters: parametersDictionary, imageData: imageData, filename:  "\(imageName).jpg")
        self.image = nil
        
        request.httpBody = data as Data
        
        //start spin
        
        self.bcActivityIndicator.startAnimating();
        
        // Start data session
        let task: URLSessionTask = session.dataTask(with: request as URLRequest) { data, response, error in
            
            //stop spinning
            self.bcActivityIndicator.stopAnimating();
            
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
                    self.bcresultTextView.text = parsedText
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

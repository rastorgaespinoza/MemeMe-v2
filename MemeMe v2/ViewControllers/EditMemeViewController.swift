//
//  EditMemeViewController.swift
//  MemeMe v2
//
//  Created by Rodrigo Astorga on 03-04-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let textFieldDelegate = TextFieldDelegate()
    
    var meme: Meme?
    
    //MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        
        if let meme = meme {
            topTextField.text = meme.topString
            bottomTextField.text = meme.bottomString
            imagePickerView.image = meme.image
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        if imagePickerView.image == nil {
            shareButton.enabled = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: - Actions.
    
    func setupTextFields() {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),             NSForegroundColorAttributeName : UIColor.whiteColor(),             NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        let textFieldArray = [topTextField, bottomTextField]
        
        for i in 0...1 {
            i == 0 ? (topTextField.text = "TOP") : (bottomTextField.text = "BOTTOM")
            
            
            textFieldArray[i].defaultTextAttributes = memeTextAttributes
            textFieldArray[i].textAlignment = .Center
            textFieldArray[i].delegate = textFieldDelegate
        }
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        let memedImage = generateMemedImage()
        
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?) -> Void in
            guard activityError == nil else {
                let alert = UIAlertController(title: "Error al compartir Meme", message: "No se pudo. Intente de nuevo más tarde por favor", preferredStyle: .Alert)
                self.presentViewController(alert , animated: true, completion: nil)
                return
            }
            guard completed == true else {
                print("se cancelo")
                return
            }
            print("se envio el meme")
            self.saveMeme(memedImage)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        navigationBar.hidden = true
        bottomToolbar.hidden = true
        
        let imageRect = calculateRectOfImageInfUIImageView(imagePickerView)
        topConstraint.constant = (imageRect.origin.y + 0.0)
        bottomConstraint.constant = view.frame.size.height - (imageRect.origin.y + imageRect.size.height)
        // Render view to an image
//        UIGraphicsBeginImageContext(view.frame.size)
//        view.drawViewHierarchyInRect(view.frame,
//                                     afterScreenUpdates: true)
        
        // code retrieved from:
        // stackoverflow: Screenshot Only Part of Screen - Swift
        //	rakeshbs, 16 Jan 2015
        //	http://stackoverflow.com/questions/27975954/screenshot-only-part-of-screen-swift
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, 0)
        let rect = CGRectMake(-imageRect.origin.x, -imageRect.origin.y, view.bounds.size.width, view.bounds.size.height)
        view.drawViewHierarchyInRect(rect, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        navigationBar.hidden = false
        bottomToolbar.hidden = false
        
        topConstraint.constant = 54.0
        bottomConstraint.constant = 54.0
        
        
        return memedImage
    }
    
    func saveMeme(memedImage: UIImage) {
        let meme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    // code modified from:
    // stackoverflow: UIImageView get the position of the showing Image
    //	Marcus, 13 Oct 2014
    //	http://stackoverflow.com/questions/26348736/uiimageview-get-the-position-of-the-showing-image
    
    func calculateRectOfImageInfUIImageView(imgView: UIImageView) -> CGRect{
        let imgViewSize = imgView.frame.size        //size of UIImageView
        let imgSize = imgView.image!.size           //size of the image, currently displayed
        
        //Calculate the aspect, assuming imgView.contentMode == UIViewContentModeScaleAspectFit
        
        let scaleW = imgViewSize.width / imgSize.width
        let scaleH = imgViewSize.height / imgSize.height
        let aspect = fmin(scaleW, scaleH)

        var imageRect = CGRectMake(0.0,0.0, (imgSize.width * aspect), (imgSize.height * aspect))
        
        // Center image
        imageRect.origin.x = (imgViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imgViewSize.height - imageRect.size.height) / 2
        
        // Add imageView offset
        imageRect.origin.x += imgView.frame.origin.x
        imageRect.origin.y += imgView.frame.origin.y
        
        return imageRect
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        shareButton.enabled = false
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImageFrom(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImageFrom(.Camera)
    }
    
    func pickAnImageFrom(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
}

//MARK: - imagepicker delegate
extension EditMemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            shareButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
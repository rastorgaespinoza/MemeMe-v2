//
//  Helper.swift
//  MemeMe v2
//
//  Created by Rodrigo Astorga on 03-04-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    class func presentEditMeme(viewController: UIViewController, meme: Meme?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewControllerWithIdentifier("EditMemeVC") as! EditMemeViewController
        editVC.meme = meme
        viewController.presentViewController(editVC, animated: true, completion: nil)
    }
    
    class func presentDetailMeme(viewController: UIViewController, meme: Meme) {
        //Grab the DetailVC from Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let object: AnyObject = storyboard.instantiateViewControllerWithIdentifier("DetailMemeViewController")
        let detailVC = object as! DetailMemeViewController
        
        //Populate view controller with data from the selected item
        detailVC.meme = meme
        
        //Present the view controller using navigation
        viewController.navigationController!.pushViewController(detailVC, animated: true)
    }
}
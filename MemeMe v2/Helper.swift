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
    class func presentEditMeme(viewController: UIViewController, memeIndex: Int?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyboard.instantiateViewControllerWithIdentifier("EditMemeVC") as! EditMemeViewController
        editVC.memeIndex = memeIndex
        viewController.presentViewController(editVC, animated: true, completion: nil)
    }
    
    class func presentDetailMeme(viewController: UIViewController, memeIndex: Int) {
        //Grab the DetailVC from Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let object: AnyObject = storyboard.instantiateViewControllerWithIdentifier("DetailMemeViewController")
        let detailVC = object as! DetailMemeViewController
        
        //Populate view controller with data from the selected item
        detailVC.memeIndex = memeIndex
        
        //Present the view controller using navigation
        viewController.navigationController!.pushViewController(detailVC, animated: true)
    }
}
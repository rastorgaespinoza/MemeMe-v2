//
//  DetailMemeViewController.swift
//  MemeMe v2
//
//  Created by Rodrigo Astorga on 03-04-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

class DetailMemeViewController: UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    
//    internal var meme: Meme!
    internal var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    var memeIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = memes[memeIndex].memedImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
    }
    
    @IBAction func editMemeAction(sender: AnyObject) {
        Helper.presentEditMeme(self, memeIndex: memeIndex)
        navigationController?.popViewControllerAnimated(true)
    }
}

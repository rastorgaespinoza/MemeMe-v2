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
    
    internal var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme.memedImage
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
    }
    
    @IBAction func editMemeAction(sender: AnyObject) {
        Helper.presentEditMeme(self, meme: meme)
        navigationController?.popViewControllerAnimated(true)
    }
}

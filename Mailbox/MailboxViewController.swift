//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Tony Yeung on 6/5/16.
//  Copyright © 2016 Tony Yeung. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    @IBOutlet weak var singleMsgView: UIImageView!
    @IBOutlet weak var feedMessageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var singleMsgContainerView: UIView!
    var singleMsgContainerOriginalCenter: CGPoint!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set the scrollview to the size of the feed message image
        scrollView.contentSize = feedMessageView.image!.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    @IBAction func didPanSingleMsgContainer(sender: UIPanGestureRecognizer) {
      let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            //Save the single message view container's original center
            singleMsgContainerOriginalCenter = singleMsgContainerView.center
            
            //Update the background color to gray when the panning starts
            self.view.backgroundColor = UIColor.lightGrayColor()
            print("panning BEGAN")
        } else if sender.state == UIGestureRecognizerState.Changed {
            print("panning CHANGED")
            singleMsgContainerView.center = CGPoint(x: singleMsgContainerOriginalCenter.x + translation.x, y: singleMsgContainerOriginalCenter.y)
        } else if sender.state == UIGestureRecognizerState.Ended {
            print("panning ENDED")
            print("panning x \(singleMsgContainerView.frame.origin.x)")
            if singleMsgContainerView.frame.origin.x > -60 {
                singleMsgContainerView.center = CGPoint(x: singleMsgContainerOriginalCenter.x, y: singleMsgContainerOriginalCenter.y)
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Tony Yeung on 6/5/16.
//  Copyright © 2016 Tony Yeung. All rights reserved.
//

import UIKit
import Foundation

class MailboxViewController: UIViewController {
    @IBOutlet weak var singleMsgView: UIImageView!
    @IBOutlet weak var feedMessageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var singleMsgContainerView: UIView!
    var singleMsgContainerOriginalCenter: CGPoint!
    @IBOutlet weak var deleteIconImageView: UIImageView!
    @IBOutlet weak var archiveIconImageView: UIImageView!

    @IBOutlet weak var laterIconImageView: UIImageView!
    @IBOutlet weak var listIconImageView: UIImageView!
    
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    
    var xOriginalDistance: CGFloat = 0.0
    var yOriginalDistance: CGFloat = 0.0
    var originCenter: CGPoint
    
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
    
    func isGoingLeft (velocity: CGPoint) -> Bool {
        if (velocity.x > 0) {
            return false
        } else {
            return true
        }
    }

    @IBAction func onCloseRescheduleBtn(sender: AnyObject) {
        self.listImageView.alpha = 0.0
        self.rescheduleImageView.alpha = 0.0
    }
    
    @IBAction func onResetViewsBtn(sender: AnyObject) {
        //Reset message view
//        self.singleMsgContainerView.frame.origin.x = 0.0
//        self.singleMsgContainerView.frame.origin.y = 130.0
        self.singleMsgContainerView.frame.origin = originCenter
        self.singleMsgContainerView.alpha = 1.0
        
        //Reset feedview
        self.feedMessageView.frame.origin.y += 81
        self.view.backgroundColor = UIColor.whiteColor()
        
        //hide the later icon
        laterIconImageView.alpha = 0
        
        //hide the listing icon
        listIconImageView.alpha = 0
    
    }
    
    @IBAction func didPanSingleMsgContainer(sender: UIPanGestureRecognizer) {
      let translation = sender.translationInView(view)
      
      //Offset constants for left swipe
      var minLeftTransitionDistance = CGFloat(60.0)
      var minLeftListingDistance = CGFloat(260.0)
      var minDistanceLeftSwipe = CGFloat(40.0)
      let laterIconOffset = CGFloat(10.0)
      let leftSwipeIconPos = singleMsgView.frame.origin.x + singleMsgView.frame.size.width + laterIconOffset
      let rightSwipeIconPos = singleMsgView.frame.origin.x + singleMsgView.frame.size.width - 360

      //current x distance made to the left
      originCenter = singleMsgContainerView.frame.origin
      xOriginalDistance = singleMsgContainerView.frame.origin.x
      yOriginalDistance = singleMsgContainerView.frame.origin.y
        
      var xDistance = abs(singleMsgContainerView.frame.origin.x) //using absolute value for easier logical statement

      //use velocity to deterimine if it's going left or right
      let velocity = sender.velocityInView(view)
        
        
      func isLTMinLeftDist (xDistance: CGFloat, minDistanceLeftSwipe: CGFloat) -> Bool {
          if xDistance > 0 &&  xDistance < minDistanceLeftSwipe {
              return true
          }
          return false
      }
        
        func isGTMinRightDist (xOriginalDistance: CGFloat, xDistance: CGFloat, minDistanceLeftSwipe: CGFloat) -> Bool {
            if xOriginalDistance > 0 && xDistance > minDistanceLeftSwipe {
                return true
            }
            return false
        }
        
        func isBetweenLeftTransition (xDistance: CGFloat, minDistanceLeftSwipe: CGFloat, minLeftTransitionDistance: CGFloat, minLeftListingDistance: CGFloat) -> Bool {
            if (xDistance > minDistanceLeftSwipe && xDistance < minLeftTransitionDistance) || (xDistance < minLeftListingDistance && xDistance > minLeftTransitionDistance) {
                return true
            }
            return false
        }

        func isBetweenRightTransition (xOriginalDistance: CGFloat, xDistance: CGFloat, minDistanceLeftSwipe: CGFloat, minLeftTransitionDistance: CGFloat, minLeftListingDistance: CGFloat) -> Bool {
            if (xOriginalDistance > 0 && xDistance < minDistanceLeftSwipe && xDistance > minLeftTransitionDistance) || (xOriginalDistance > 0 && xDistance > minLeftListingDistance && xDistance < minLeftTransitionDistance) {
                return true
            }
            return false
        }
        
        func isFullLeftTransition (xDistance: CGFloat, minLeftListingDistance: CGFloat) -> Bool {
           if xDistance > minLeftListingDistance {
                return true
            }
            return false
        }
        
        func isFullRightTransition (xOriginalDistance: CGFloat, xDistance: CGFloat, minLeftListingDistance: CGFloat) -> Bool {
            if xOriginalDistance > 0 && xDistance < minLeftListingDistance {
                return true
            }
            return false
        }
        
        func shouldCloseTheMsgView (xOrigin: CGFloat, minLeftTransitionDistance: CGFloat) -> Bool {
            if abs(xOrigin) < minLeftTransitionDistance {
                return true
            }
            return false
        }
        
        if sender.state == UIGestureRecognizerState.Began {
            //Save the single message view container's original center
            singleMsgContainerOriginalCenter = singleMsgContainerView.center
            
            print("panning BEGAN")
        } else if sender.state == UIGestureRecognizerState.Changed {
            print("panning CHANGED")
            print("panning ORIGINAL x \(singleMsgContainerView.frame.origin.x)")
            print("panning x \(abs(singleMsgContainerView.frame.origin.x))")
            

            /*
                going LEFT - original x is less than 0
            */
            if isLTMinLeftDist(xDistance, minDistanceLeftSwipe: minDistanceLeftSwipe) {
                //animate the later icon
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.laterIconImageView.alpha = 1
                })

                //Update the background color to gray when the panning starts
                print("updating background color to gray")
                self.view.backgroundColor = UIColor.lightGrayColor()
            }
            
            if isBetweenLeftTransition(xDistance, minDistanceLeftSwipe: minDistanceLeftSwipe, minLeftTransitionDistance: minLeftTransitionDistance, minLeftListingDistance: minLeftListingDistance) {
                //initialize the later icon position
                laterIconImageView.frame.origin.x = leftSwipeIconPos
                
                //show the later icon
                laterIconImageView.alpha = 1
                
                //hide the listing icon
                listIconImageView.alpha = 0
                
                //update the color to yellow
                print("updating background color to yellow")
                self.view.backgroundColor = UIColor(red:255/255, green: 204/255, blue: 0/255, alpha: 1.0)

                //update later icon frame position
                self.laterIconImageView.frame = laterIconImageView.frame
            }
            
            if isFullLeftTransition(xDistance, minLeftListingDistance: minLeftListingDistance) {
                //hide the later icon
                laterIconImageView.alpha = 0
            
                //show the listing icon
                listIconImageView.alpha = 1
                
                //initialize the later icon position
                listIconImageView.frame.origin.x = leftSwipeIconPos
                
                //update the color to brown
                self.view.backgroundColor = UIColor(red:216/255, green: 165/255, blue: 117/255, alpha: 1.0)
                
                //update listing icon frame position
                self.listIconImageView.frame = listIconImageView.frame
            }
            
            
            /*
                going RIGHT - original x is always greater than 0
            */
            xDistance = -1 * xDistance
            minDistanceLeftSwipe = -1 * minDistanceLeftSwipe
            minLeftTransitionDistance = -1 * minLeftTransitionDistance
            minLeftListingDistance = -1 * minLeftListingDistance
            
            if isGTMinRightDist(xOriginalDistance, xDistance: xDistance, minDistanceLeftSwipe: minDistanceLeftSwipe) {
                //animate the later icon
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.archiveIconImageView.alpha = 1
                })
                
                //Update the background color to gray when the panning starts
                print("updating background color to gray")
                self.view.backgroundColor = UIColor.lightGrayColor()
            }
            
            if isBetweenRightTransition(xOriginalDistance, xDistance: xDistance, minDistanceLeftSwipe: minDistanceLeftSwipe, minLeftTransitionDistance: minLeftTransitionDistance, minLeftListingDistance: minLeftListingDistance) {
                //initialize the archive icon position
                archiveIconImageView.frame.origin.x = rightSwipeIconPos
                
                //show the archive icon
                archiveIconImageView.alpha = 1
                
                //hide the delete icon
                deleteIconImageView.alpha = 0
                
                //update the color to green
                print("updating background color to green")
                self.view.backgroundColor = UIColor.greenColor()
                
                //update archive icon frame position
                self.archiveIconImageView.frame = archiveIconImageView.frame
            }
            
            if isFullRightTransition(xOriginalDistance, xDistance: xDistance, minLeftListingDistance: minLeftListingDistance) {
                //hide the archive icon
                archiveIconImageView.alpha = 0
                
                //show the delete icon
                deleteIconImageView.alpha = 1
                
                //initialize the delete icon position
                deleteIconImageView.frame.origin.x = rightSwipeIconPos
                
                //update the color to red
                self.view.backgroundColor = UIColor.redColor()
                
                //update delete icon frame position
                self.deleteIconImageView.frame = deleteIconImageView.frame
            }
            //keep moving the single message view container
            singleMsgContainerView.center = CGPoint(x: singleMsgContainerOriginalCenter.x + translation.x, y: singleMsgContainerOriginalCenter.y)

        } else if sender.state == UIGestureRecognizerState.Ended {
            print("panning ENDED")
            print("panning x \(abs(singleMsgContainerView.frame.origin.x))")
            
            if isGoingLeft(velocity) {
                print("need to close the LEFT side")
                //Reverses the values from having to check the RIGHT side in the "changed" state
                if isLTMinLeftDist(xDistance, minDistanceLeftSwipe: minDistanceLeftSwipe) {
                    // Animate the message back into its original position
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.listImageView.alpha = 0.0
                        self.rescheduleImageView.alpha = 0.0
                        self.singleMsgContainerView.frame.origin.x = self.singleMsgContainerView.frame.size.width - 320
                    })
                }
                
                if isBetweenLeftTransition(xDistance, minDistanceLeftSwipe: minDistanceLeftSwipe, minLeftTransitionDistance: minLeftTransitionDistance, minLeftListingDistance: minLeftListingDistance) {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.listImageView.alpha = 0.0
                        self.rescheduleImageView.alpha = 1.0
                    })
                }
                
                if isFullLeftTransition(xDistance, minLeftListingDistance: minLeftListingDistance) {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.listImageView.alpha = 1.0
                        self.rescheduleImageView.alpha = 0.0
                    })
                }
            } else {
                xDistance = -1 * xDistance
                minDistanceLeftSwipe = -1 * minDistanceLeftSwipe
                minLeftTransitionDistance = -1 * minLeftTransitionDistance
                minLeftListingDistance = -1 * minLeftListingDistance

                print("need to close the RIGHT side")
                if isGTMinRightDist(xOriginalDistance, xDistance: xDistance, minDistanceLeftSwipe: minDistanceLeftSwipe) {
                    // Animate the message back into its original position
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.singleMsgContainerView.frame.origin.x = self.singleMsgContainerView.frame.size.width - 320
                    })
                }
                
                if isBetweenRightTransition(xOriginalDistance, xDistance: xDistance, minDistanceLeftSwipe: minDistanceLeftSwipe, minLeftTransitionDistance: minLeftTransitionDistance, minLeftListingDistance: minLeftListingDistance) {
                    //hide the message
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.singleMsgContainerView.frame.origin.x = self.singleMsgContainerView.frame.size.width - 320
                        self.singleMsgContainerView.alpha = 0.0
                        
                        //hide the message
                        self.feedMessageView.frame.origin.y -= 81
                        self.view.backgroundColor = UIColor.whiteColor()
                    })
                }
                
                if isFullRightTransition(xOriginalDistance, xDistance: xDistance, minLeftListingDistance: minLeftListingDistance) {
                    //hide the message
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.singleMsgContainerView.frame.origin.x = self.singleMsgContainerView.frame.size.width - 320
                        self.singleMsgContainerView.alpha = 0.0
                        
                        //hide the message
                        self.feedMessageView.frame.origin.y -= 81
                        self.view.backgroundColor = UIColor.whiteColor()
                    })
                }
                
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

//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Suraj Upreti on 4/04/17.
//  Copyright © 2017 Suraj Upreti. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    var trayViewOriginalCenter = CGPoint()
    var trayDownOffSet: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newFaceCreated: UIImageView!
    var newFaceCreatedOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trayDownOffSet = 200
        self.trayUp = trayView.center
        self.trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffSet)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            self.trayViewOriginalCenter = trayView.center
        }
        
        else if sender.state == .changed {
            self.trayView.center = CGPoint(x: trayViewOriginalCenter.x, y: trayViewOriginalCenter.y + translation.y)
        }
        
        else if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [], animations: {
                    self.trayView.center = self.trayDown
                }, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [], animations: {
                    self.trayView.center = self.trayUp
                }, completion: nil)
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            let imageView = sender.view as! UIImageView
            self.newFaceCreated = UIImageView(image: imageView.image)
            view.addSubview(newFaceCreated)
            newFaceCreated.center = imageView.center
            newFaceCreated.center.y += trayView.frame.origin.y
            newFaceCreatedOriginalCenter = newFaceCreated.center
            
            // this will scale the face out after the start of the dragging
            UIView.animate(withDuration: 0.3, animations: {
                self.newFaceCreated.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
        }
        
        else if sender.state == .changed {
            newFaceCreated.center = CGPoint(x: newFaceCreatedOriginalCenter.x + translation.x, y: newFaceCreatedOriginalCenter.y + translation.y)
        }
        
        else if sender.state == .ended {
            print("ended pan face")
            
            // after the face is droped the face will scale back to it initial size
            UIView.animate(withDuration: 0.4, animations: {
                self.newFaceCreated.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
            // this piece will add the gestureRecognizer to the newly created faces in the main view after they are created.
            let addGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanFaceFromTheMainView(sender:)))
            addGestureRecognizer.delegate = self
            newFaceCreated.isUserInteractionEnabled = true
            newFaceCreated.addGestureRecognizer(addGestureRecognizer)
        }
        
    }
    
    func didPanFaceFromTheMainView(sender: UIPanGestureRecognizer) {
        NSLog("Paned from the main View")
        let translation = sender.translation(in: view)
        if sender.state == .began {
            newFaceCreated = sender.view as! UIImageView
            newFaceCreatedOriginalCenter = newFaceCreated.center
            
            UIView.animate(withDuration: 0.3, animations: {
                self.newFaceCreated.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
        }
            
        else if sender.state == .changed {
            newFaceCreated.center = CGPoint(x: newFaceCreatedOriginalCenter.x + translation.x, y: newFaceCreatedOriginalCenter.y + translation.y)
        }
            
        else if sender.state == .ended {
            UIView.animate(withDuration: 0.4, animations: {
                self.newFaceCreated.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        
    }
}

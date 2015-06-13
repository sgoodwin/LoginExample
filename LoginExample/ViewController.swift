//
//  ViewController.swift
//  LoginExample
//
//  Created by Samuel Goodwin on 6/12/15.
//  Copyright (c) 2015 Roundwall Software. All rights reserved.
//

import UIKit

enum LoginStatus {
    case LoggedOut
    case LoggedIn(apiKey: String)
}

extension UIViewController {
    func embedFullScreenController(controller: UIViewController){
        controller.willMoveToParentViewController(self)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        addChildViewController(controller)
    }
}

class LoggedInViewController: UIViewController {
    var status: LoginStatus?
}

class LoggedOutViewController: UIViewController {
    var gatewayViewController: GatewayViewController?
    
    @IBAction func login() {
        // Assume login magically worked just fine.
        gatewayViewController?.status = .LoggedIn(apiKey: "someimportantapikey")
    }
}

class GatewayViewController: UIViewController {
    var status = LoginStatus.LoggedOut {
        didSet {
            showAppropriateController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showAppropriateController()
    }
    
    private func removeOldChildren() {
        for controller in childViewControllers as! [UIViewController] {
            controller.removeFromParentViewController()
        }
    }
    
    private func showAppropriateController() {
        removeOldChildren()
        
        switch status {
        case .LoggedOut:
            let controller = storyboard?.instantiateViewControllerWithIdentifier("loggedOut") as? LoggedOutViewController
            controller?.gatewayViewController = self
            map(controller, embedFullScreenController)
        case .LoggedIn(let apiKey):
            let controller = storyboard?.instantiateViewControllerWithIdentifier("loggedIn") as? LoggedInViewController
            controller?.status = self.status
            map(controller, embedFullScreenController)
        }
    }
}


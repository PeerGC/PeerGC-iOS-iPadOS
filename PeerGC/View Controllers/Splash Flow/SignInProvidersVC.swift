//
//  SignInProvidersVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 8/3/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class SignInProvidersVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var signInWithEmailButton: DesignableButton!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var signInWithGoogleButton: DesignableButton!
    @IBOutlet weak var googleIcon: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        titleLabel.font = titleLabel.font.withSize( (3.0/71) * UIScreen.main.bounds.height)
        
        subTitleLabel.font = subTitleLabel.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
        
        signInWithEmailButton.titleLabel!.font = signInWithEmailButton.titleLabel!.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
        
        signInWithGoogleButton.titleLabel!.font = signInWithGoogleButton.titleLabel!.font.withSize( (1.5/71) * UIScreen.main.bounds.height)
        
        if GenericStructureViewController.sendToDatabaseData[DatabaseKey.accountType.name] == DatabaseValue.mentor.name {
            subTitleLabel.text = subTitleLabel.text! + " Please note that mentors must use a .edu email address."
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        signInWithEmailButton.isHidden = false
        emailIcon.isHidden = false
        signInWithGoogleButton.isHidden = false
        googleIcon.isHidden = false
        activityIndicator.isHidden = true
    }

    @IBAction func signInWithGoogleButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signInWithEmailButtonPressed(_ sender: Any) {
        show(EmailVC(), sender: self)
    }
    
}

extension SignInProvidersVC: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            return
        }
        
        signInWithEmailButton.isHidden = true
        emailIcon.isHidden = true
        signInWithGoogleButton.isHidden = true
        googleIcon.isHidden = true
        activityIndicator.isHidden = false

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                return
            }
            
            let uid = Auth.auth().currentUser!.uid
            let docRef = Firestore.firestore().collection(DatabaseKey.users.name).document(uid)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    Firestore.firestore().collection(DatabaseKey.users.name).document(uid).collection(DatabaseKey.allowList.name).getDocuments(completion: { (querySnapshot, error) in
                        Utilities.loadHomeScreen()
                    })
                } else {
                    self.navigationController!.pushViewController(ProfilePictureVC(), animated: true)
                }
            }
            
            
        }
        
    }
    
}

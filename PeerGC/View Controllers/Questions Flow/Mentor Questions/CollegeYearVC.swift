//
//  CollegeYearVC.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/24/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class CollegeYearVC: GenericStructureViewController {
    override func viewDidLoad() {
        metaDataDelegate = self
        buttonsDelegate = self
        super.viewDidLoad()
    }
}

extension CollegeYearVC: GenericStructureViewControllerMetadataDelegate {
    func title() -> String {
        return "What year of college are you in?"
    }
    
    func subtitle() -> String? {
        return "This information will be displayed on your public profile and is used by our matching algorithm."
    }
    
    func nextViewController() -> UIViewController? {
        return CollegeNameVC()
    }
}

extension CollegeYearVC: ButtonsDelegate {
    func databaseIdentifier() -> DatabaseKey {
        return .What_Year_Of_College
    }
    
    func buttons() -> [DatabaseValue] {
        return [.freshman, .sophomore, .junior, .senior]
    }
}

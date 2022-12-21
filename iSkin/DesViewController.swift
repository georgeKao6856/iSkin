//
//  DesViewController.swift
//  iSkin
//
//  Created by Ada Birge Kilic on 11/26/22.
//

import UIKit


class DesViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    var name = ""
    var scoreDict:[String: String] = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detail.numberOfLines = 0
        productName.textAlignment = .center
        productName.numberOfLines = 0
        if(name != ""){
            self.productName.text = name
        }
        
        if(descripDict[name] != ""){
            self.detail.text = descripDict[name]
        }
        
        if(scoreDictPng[scoreDict[name]!] != ""){
            let sourceImage = UIImage(named: scoreDictPng[scoreDict[name]!]!)
            self.imageView.image = sourceImage
        }
    }
}

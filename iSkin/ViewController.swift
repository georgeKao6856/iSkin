//
//  ViewController.swift
//  iSkin
//
//  Created by Ada Kilic  on 11/15/22.
//

import UIKit
import Vision
import Foundation
import Alamofire
import Kanna
import SwiftSoup
import WebKit

var descripDict: [String: String] = [String: String]()

class ViewController: UIViewController {

    @IBOutlet weak var actiVityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    //@IBOutlet weak var textView: UITextView!
    var textString = ""
    var request = VNRecognizeTextRequest(completionHandler: nil)
    var scoreDict:[String: String] = [String: String]()
    var url_list=[
        "https://www.ewg.org/skindeep/ingredients/702620-GLYCERIN/",
        "https://www.ewg.org/skindeep/ingredients/703428-LAURIC_ACID/",
        "https://www.ewg.org/skindeep/ingredients/701535-COCOGLUCOSIDE/",
        "https://www.ewg.org/skindeep/ingredients/701385-CITRIC_ACID/",
        "https://www.ewg.org/skindeep/ingredients/701520-COCAMIDOPROPYL_BETAINE",
        "https://www.ewg.org/skindeep/ingredients/701741-CYCLOPENTASILOXANE/",
        "https://www.ewg.org/skindeep/ingredients/702344-ETHYLHEXYL_ISONONANOATE/",
        "https://www.ewg.org/skindeep/ingredients/704134-NIACINAMIDE/",
        "https://www.ewg.org/skindeep/ingredients/702011-DIMETHICONE/",
        "https://www.ewg.org/skindeep/ingredients/705749-SALIX_ALBA_WHITE_WILLOW_BARK_EXTRACT/",
        "https://www.ewg.org/skindeep/ingredients/706025-SODIUM_CHLORIDE/",
        "https://www.ewg.org/skindeep/ingredients/706071-SODIUM_HYALURONATE/",
        "https://www.ewg.org/skindeep/ingredients/700946-CAFFEINE/",
        "https://www.ewg.org/skindeep/ingredients/700555-ASCORBYL_PALMITATE_VITAMIN_C_PALMITATE/",
        "https://www.ewg.org/skindeep/ingredients/700861-BUTYLENE_GLYCOL/",
        "https://www.ewg.org/skindeep/ingredients/704811-PHENOXYETHANOL/",
        "https://www.ewg.org/skindeep/ingredients/706776-UNDECYLENOYL_GLYCINE/",
        "https://www.ewg.org/skindeep/ingredients/702146-DISODIUM_EDTA/",
        "https://www.ewg.org/skindeep/ingredients/706075-SODIUM_HYDROXIDE/",
        "https://www.ewg.org/skindeep/ingredients/703949-MICA/",
        "https://www.ewg.org/skindeep/ingredients/705070-POLYMETHYL_METHACRYLATE/",
        "https://www.ewg.org/skindeep/ingredients/702011-DIMETHICONE/",
        "https://www.ewg.org/skindeep/ingredients/704741-PENTAERYTHRITYL_TETRAISOSTEARATE/",
        "https://www.ewg.org/skindeep/ingredients/701240-CETEARYL_ETHYLHEXANOATE/",
        "https://www.ewg.org/skindeep/ingredients/707076-ZINC_STEARATE/",
        "https://www.ewg.org/skindeep/ingredients/707051-ZEA_MAYS_CORN_STARCH/",
        "https://www.ewg.org/skindeep/ingredients/701067-CAPRYLYL_GLYCOL/",
        "https://www.ewg.org/skindeep/ingredients/702352-ETHYLHEXYLGLYCERIN/",
        "https://www.ewg.org/skindeep/ingredients/705225-POTASSIUM_SORBATE/",
        "https://www.ewg.org/skindeep/ingredients/701327-CHLORPHENESIN/",
        "https://www.ewg.org/skindeep/ingredients/706569-TOCOPHERYL_ACETATE/",
        "https://www.ewg.org/skindeep/ingredients/707096-PRUNUS_AMYGDALUS_DULCIS_SWEET_ALMOND_OIL/",
        "https://www.ewg.org/skindeep/ingredients/723330-ROSA_MULTIFLORA_FLOWER_WAX/",
        "https://www.ewg.org/skindeep/ingredients/706510-TETRASODIUM_EDTA/",
        "https://www.ewg.org/skindeep/ingredients/702044-DIMETHICONOL/",
        "https://www.ewg.org/skindeep/ingredients/702030-DIMETHICONE_PEG_10_15_CROSSPOLYMER/"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopAnimating()
    }

    @IBAction func touchPlusButton(_ sender: Any) {
        setupGallery()
    }
    
    @IBAction func touchCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func setupGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePhotoLibraryPicker = UIImagePickerController()
            imagePhotoLibraryPicker.delegate = self
            imagePhotoLibraryPicker.allowsEditing = true
            imagePhotoLibraryPicker.sourceType = .photoLibrary
            self.present(imagePhotoLibraryPicker, animated: true, completion: nil)
        }
    }
    
    private func setupVersionTextRecognizemage(image:UIImage?){
        //setupTextRecognition
        var textString = ""
        request = VNRecognizeTextRequest(completionHandler: {(request, error) in
            guard let observations = request.results as?[VNRecognizedTextObservation]else{fatalError("Recieved Invalid Observation")}
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else{
                    print("No Candidate")
                    continue
                }
                textString += "\n\(topCandidate.string)"
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    //self.textView.text = textString
                    self.textString = textString
                }
            }
        })
        
        //add some properties
        request.customWords = ["cust0m"]
        request.minimumTextHeight = 0.03125
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en_US"]
        request.usesLanguageCorrection = true
        
        let requests = [request]
        
        //create request handler
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let img = image?.cgImage else {fatalError("Missing image to scan")}
            let handler = VNImageRequestHandler(cgImage: img, options: [:])
            try? handler.perform(requests)
        }
    }
    
    //get ingredient score
    func score(word :String)-> String{
        var check = false
        var url_catagory = [String]()
        let url_c = word
        let url = URL(string:url_c)!
        let html = try! String(contentsOf: url)
        let els: Elements = try! SwiftSoup.parse(html).select("img")
        
        for link in els.array() {
            let linkHref: String = try! link.attr("src")
            url_catagory.append(linkHref)
        }
        
        for i in url_catagory{
            if i.contains("/show.svg") && check == false{
                //get score number
                let myURL = URL(string: "https://www.ewg.org" + i)
                var str = i
                let start = str.index(str.endIndex, offsetBy: -13)
                let end = str.index(str.endIndex, offsetBy: -12)
                let range = start..<end
                let mySubstring = str[range]//score
                check = true
                return String(mySubstring)
            }
        }
        return String(0)
    }
    
    //get ingredient description
    private func fetchRecruitInfo(url:String, completion: @escaping (String, Bool) -> Void){
        var des = ""
        self.startAnimating()
        AF.request(url).responseString { response in
            self.startAnimating()
            if let html = response.value { //send request
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) { //get html code
                    var contents = [String]()
                    for value in doc.xpath("//div[1]/div[3]/section/p") {//use xpath to find html
                        guard let text = value.text else { continue }
                        contents.append(text) //use contents to carry value
                        //dump(contents)
                    }
                    let contentString = contents.joined(separator: "") // change to string
                    des = contentString
                    //print(contentString)
                }
            }
            self.stopAnimating()
            completion(des, true)
        }
    }
    
    private func webSearch(ingredlist: [String]){
        for item in ingredlist{
            var check = false
            var replaced = item.uppercased().replacingOccurrences(of: " ", with: "_")
            replaced = replaced.replacingOccurrences(of: "/", with: "_")
            replaced = replaced.replacingOccurrences(of: "-", with: "_")
            for j in url_list{
                if j.contains(replaced) && check == false{
                    fetchRecruitInfo(url: j, completion: {(data, success) in
                        if(success){
                            descripDict[item] = data
                        }
                    })
                    scoreDict[item] = score(word: j)
                    check = true
                }
            }
            if (!check) {
                descripDict[item] = "No Result."
                scoreDict[item] = "No Result"
            }
        }
    }
    
    
    @IBAction func CanelImage(_ sender: Any) {
        self.imageView.image = UIImage(named: "iskinlogo")
        self.textString = ""
        scoreDict.removeAll()
        descripDict.removeAll()
    }
    
    
    @IBAction func webcrawler(_ sender: Any) {
        let ingredlist = self.textString.components(separatedBy: ",")
        var newingredlist = [String]()
        for item in ingredlist{
            var newItem = item.replacingOccurrences(of: "\n", with: " ")
            newItem = newItem.trimmingCharacters(in: .whitespaces)
            newItem = newItem.replacingOccurrences(of: "|", with: "l")
            newItem = newItem.replacingOccurrences(of: "!", with: "l")
            newItem = newItem.replacingOccurrences(of: "INGREDIENTS: ", with: "")
            newingredlist.append(newItem)
        }
        
        webSearch(ingredlist: newingredlist)
        
        let storyboard = storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        storyboard.ingredlist = newingredlist
        storyboard.scoreDict = self.scoreDict
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    private func startAnimating(){
        self.actiVityIndicator.startAnimating()
    }
    
    private func stopAnimating(){
        self.actiVityIndicator.stopAnimating()
    }
}

extension ViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]){
        
        picker.dismiss(animated: true, completion: nil)
        
        startAnimating()
        //self.textView.text = ""
        self.textString = ""
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage]as?UIImage else {return}
        self.imageView.image = image
        
        setupVersionTextRecognizemage(image: image)
    }
}

//
//  ListViewController.swift
//  iSkin
//
//  Created by Ada Birge Kilic on 11/26/22.
//

import UIKit

var myIndex = 0
var scoreDictPng:[String: String] = [
    "1" : "score1.png",
    "2" : "score2.png",
    "3" : "score3.png",
    "4" : "score4.png",
    "5" : "score5.png",
    "6" : "score6.png",
    "7" : "score7.png",
    "9" : "score9.png",
    "10" : "score10.png",
    "No Result": "NoResult.png"
]

class ListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var ingredlist = [String]()
    var scoreDict:[String: String] = [String: String]()
    
    struct Ingredient {
        let title: String
        let imageName: String
    }
    
    /*let data: [Ingredient] = [
        Ingredient(title: "1", imageName: "iskinlogo"),
        Ingredient(title: "2", imageName: "iskinlogo"),
        Ingredient(title: "3", imageName: "iskinlogo"),
        Ingredient(title: "4", imageName: "iskinlogo"),
        Ingredient(title: "5", imageName: "iskinlogo"),
    ]*/
    
    var data: [Ingredient] = []

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        if(ingredlist.count != 0){
            for item in ingredlist{
                var score = scoreDict[item]
                data.append(Ingredient(title: item, imageName: scoreDictPng[score!]!))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient = data[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        cell.label.numberOfLines = 0
        cell.label.text = ingredient.title
        cell.iconImageView.image = UIImage(named: ingredient.imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        table.deselectRow(at: indexPath, animated: true)
        let storyboard = storyboard?.instantiateViewController(withIdentifier: "DesViewController") as! DesViewController
        storyboard.name = ingredlist[myIndex]
        storyboard.scoreDict = self.scoreDict
        self.navigationController?.pushViewController(storyboard, animated: true)
        
        //performSegue(withIdentifier: "describe", sender: self)
        /*let desviewController:DesViewController = DesViewController()
        viewController.name = ingredlist[myIndex]
        self.navigationController?.pushViewController(viewController, animated: true)*/
        
    }
}

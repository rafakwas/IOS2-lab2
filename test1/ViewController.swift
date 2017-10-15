//
//  ViewController.swift
//  test1
//
//  Created by Rafał on 15/10/2017.
//  Copyright © 2017 Rafał. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var counter : Int = 0
    var current : Int = 0
    var length : Int = 0
    var json : [[String:Any]]?
    @IBOutlet var record: UILabel!
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var authorLabel: UITextField!
    @IBOutlet var genreLabel: UITextField!
    @IBOutlet var productionYearLabel: UITextField!
    @IBOutlet var tracksLabel: UITextField!
    
    @IBOutlet var removeButton: UIButton!
    var titleTemp : String = ""
    var authorTemp : String = ""
    var genreTemp : String = ""
    var productionYearTemp : String = ""
    var tracksTemp : String = ""
    var recordTemp : String = ""
    
    @IBOutlet var previousButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeJson()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func previous(_ sender: Any) {
        current = current - 1
        tempRecord(index: current)
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
    @IBAction func next(_ sender: Any) {
        current = current + 1
        if (current >= length) {
            current = length
            emptyNewRecord()
        } else {
            tempRecord(index: current)
        }
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    
    func updateView() {
        authorLabel.text = authorTemp
        titleLabel.text = titleTemp
        genreLabel.text = genreTemp
        productionYearLabel.text = productionYearTemp
        tracksLabel.text = tracksTemp
        record.text = recordTemp
  
        if (current == 0) {
            previousButton.isHidden = true
        } else {
            previousButton.isHidden = false
        }
        
        if (length == 0) {
            removeButton.isHidden = true
        } else {
            removeButton.isHidden = false
        }
        
        
    }
    
    func initializeJson() {
        let urlString = URL(string : "https://isebi.net/albums.php")
        let task = URLSession.shared.dataTask(with: urlString!) {data,response,error in
            self.json = try! JSONSerialization.jsonObject(with : data!) as? [[String:Any]]
            self.length = self.json!.count
        }
        print("initialize json")
        task.resume()
    }
    
    func printJson(index : Int) {
        for data in json! {
            let artist = data["artist"] as? String
            print(artist)
        }
        let genre = json![0]["genre"] as? String
        print(genre!)
    }
    
    @IBAction func newRecord(_ sender: Any) {
        emptyNewRecord()
        DispatchQueue.main.async {
            self.updateView()
        }
    }

    @IBAction func deleteRecord(_ sender: Any) {
        json!.remove(at: current)
        length = length - 1
        if (current == length) {
            current = current - 1
        }
        
        if (length == 0) {
            current = 0
            emptyNewRecord()
            //hide remove button
        } else {
            tempRecord(index: current)
        }
        
        DispatchQueue.main.async {
            self.updateView()
        }
    }
    @IBAction func saveRecord(_ sender: Any) {
        var newElement : [String : Any]
        newElement["album"] = titleLabel.text!
        newElement["genre"] = genreLabel.text!
        newElement["artist"] =  authorLabel.text!
        newElement["year"] = productionYearLabel.text!
        newElement["tracks"] = tracksLabel.text!
        if (current == length) {
            json?.append(newElement)
        } else {
            
        }
    }
    
    func tempRecord(index : Int) {
        //normalny rekord
        let currentRecord = json![index]
        self.titleTemp = currentRecord["album"] as! String
        self.genreTemp = currentRecord["genre"] as! String
        let year = currentRecord["year"] as! Int
        self.productionYearTemp = "\(year)"
        self.authorTemp = currentRecord["artist"] as! String
        let track = currentRecord["tracks"] as! Int
        self.tracksTemp = "\(track)"
        self.recordTemp = "Rekord \(current) z \(length)"
    }
    
    func emptyNewRecord() {
        self.titleTemp = ""
        self.genreTemp = ""
        self.productionYearTemp = ""
        self.authorTemp = ""
        self.tracksTemp = ""
        self.recordTemp = "Nowy rekord"
    }
}

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
    @IBOutlet var saveButton: UIButton!
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
        initializeJson(withCompletion: {
            self.tempRecord(index: 0)
            DispatchQueue.main.async { [unowned self] in
                self.updateView();
            }
        })
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
        self.authorLabel.text = authorTemp
        self.titleLabel.text = titleTemp
        self.genreLabel.text = genreTemp
        self.productionYearLabel.text = productionYearTemp
        self.tracksLabel.text = tracksTemp
        self.record.text = recordTemp
  
        if (self.current == 0) {
            self.previousButton.isHidden = true
        } else {
            self.previousButton.isHidden = false
        }
        
        if (self.length == 0) {
            self.removeButton.isHidden = true
        } else {
            self.removeButton.isHidden = false
        }
        
        self.saveButton.isHidden = true
    }
    
    func initializeJson(withCompletion completion : @escaping (()->Void)) {
        let urlString = URL(string : "https://isebi.net/albums.php")
        let task = URLSession.shared.dataTask(with: urlString!) {data,response,error in
            self.json = try! JSONSerialization.jsonObject(with : data!) as? [[String:Any]]
            self.length = self.json!.count
            completion()
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
        var newElement = [String: Any]()
       
        titleTemp = titleLabel.text!
        genreTemp = genreLabel.text!
        authorTemp = authorLabel.text!
        productionYearTemp = productionYearLabel.text!
        tracksTemp = tracksLabel.text!
        recordTemp = record.text!
        
        newElement["album"] = titleLabel.text!
        newElement["genre"] = genreLabel.text!
        newElement["artist"] =  authorLabel.text!
        newElement["year"] = (productionYearLabel.text! as NSString).integerValue
        newElement["tracks"] = (tracksLabel.text! as NSString).integerValue
        if (current == length) {
            json?.append(newElement)
            length = length + 1
            recordTemp = "Record \(current) z \(length)"
        } else {
            json![current]["album"] = newElement["album"]
            json![current]["genre"] = newElement["genre"]
            json![current]["artist"] = newElement["artist"]
            json![current]["year"] = newElement["year"]
            json![current]["tracks"] = newElement["tracks"]
        }
        
        DispatchQueue.main.async {
            self.updateView()
        }
        
    }
    
    func tempRecord(index : Int) {
        print("temp record")
        let currentRecord = json![index]
        self.titleTemp = currentRecord["album"] as! String
        self.genreTemp = currentRecord["genre"] as! String
        let year = currentRecord["year"] as! Int
        self.productionYearTemp = "\(year)"
        self.authorTemp = currentRecord["artist"] as! String
        let track = currentRecord["tracks"] as! Int
        self.tracksTemp = "\(track)"
        self.recordTemp = "Rekord \(current) z \(length-1)"
    }
    
    func emptyNewRecord() {
        self.titleTemp = ""
        self.genreTemp = ""
        self.productionYearTemp = ""
        self.authorTemp = ""
        self.tracksTemp = ""
        self.recordTemp = "Nowy rekord"
    }
    
    @IBAction func onTitleChanged(_ sender: Any) {
            saveButton.isHidden = false
    }
    @IBAction func onArtistChanged(_ sender: Any) {
        saveButton.isHidden = false
    }
    @IBAction func onGenreChanged(_ sender: Any) {
        saveButton.isHidden = false
    }
    @IBAction func onYearChanged(_ sender: Any) {
        saveButton.isHidden = false
    }
    @IBAction func onTracksChanged(_ sender: Any) {
        saveButton.isHidden = false
    }
    }

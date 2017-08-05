//
//  ViewController.swift
//  Cut&Paste
//
//  Created by Arendelle on 2017/7/14.
//  Copyright © 2017年 AdTech. All rights reserved.
//

import UIKit

let dict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Points_alt", ofType: "plist")!)
let dirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
let dirPathNS = dirPath as NSString
let docDir = dirPathNS.appendingPathComponent("B")

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var Content = [String]()
    var people = [String]()
    @IBOutlet weak var x:UIStepper!
    @IBOutlet weak var y:UIStepper!
    @IBOutlet weak var table:UITableView!
    var current = 1
    var number = ""
    var xV = 0
    var yV = 0
    
    override func viewDidLoad() {
        do {
            try Content = FileManager.default.contentsOfDirectory(atPath: docDir)
        } catch {
            print(error)
        }
        print(Content)
        let image = Content[1]
        let img = UIImage(contentsOfFile: (docDir as NSString).appendingPathComponent(image))
        let index = image.index(image.endIndex, offsetBy: -4)
        number = image.substring(to: index)
        cutImg(image: img!,xV,yV,number: Int(number)!)
        
        table.reloadData()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func NeXT(){
        current += 1
        if Content.count < current {
            print("finished")
            return
        }
        let image = Content[current]
        if image == ".DS_Store"{
            print("nullified")
            return
        }
        let img = UIImage(contentsOfFile: (docDir as NSString).appendingPathComponent(image))
        let index = image.index(image.endIndex, offsetBy: -4)
        number = image.substring(to: index)
        cutImg(image: img!,xV,yV,number: Int(number)!)
        table.reloadData()
    }
    
    @IBAction func Xchange(){
        xV = Int(x.value)
        refresh()
        
    }
    
    @IBAction func Ychange() {
        yV = Int(y.value)
        refresh()
    }
    
    func refresh() {
        if Content.count < current {
            print("finished")
            return
        }
        let image = Content[current]
        if image == ".DS_Store"{
            print("nullified")
            return
        }
        let img = UIImage(contentsOfFile: (docDir as NSString).appendingPathComponent(image))
        cutImg(image: img!,xV,yV,number: Int(number)!)
        let index = image.index(image.endIndex, offsetBy: -4)
        number = image.substring(to: index)
        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dict?.allKeys.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        (cell?.viewWithTag(419) as! UIImageView).image = UIImage(contentsOfFile: (dirPathNS.appendingPathComponent(number) as NSString).appendingPathComponent(dict?.allKeys[indexPath.item] as! String) + ".png")
        return cell!
    }
    
}


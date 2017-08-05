//
//  ViewController.swift
//  Solemn
//
//  Created by Arendelle on 2017/7/15.
//  Copyright © 2017年 AdTech. All rights reserved.
//

import UIKit

var dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
var CustomizeFolder = (dir as NSString).appendingPathComponent("SpecialCare")
var CFNS = CustomizeFolder as NSString

class ViewController: UIViewController {
    
    var allPeople = [String]()
    var currentPeople = 1
    var currentMoraiPeople = 0
    var moraiPeople = [String]()
    var currentDir = CFNS
    var currentImage = UIImage()
    var orgImage = UIImage()
    
    @IBOutlet weak var image:UIImageView!
    @IBOutlet weak var x:UIStepper!
    @IBOutlet weak var y:UIStepper!
    @IBOutlet weak var l:UILabel!
    
    override func viewDidLoad() {
        do {
            try allPeople = FileManager.default.contentsOfDirectory(atPath: CustomizeFolder)
        } catch {
            print(error)
        }
        do {
            try moraiPeople = FileManager.default.contentsOfDirectory(atPath: CFNS.appendingPathComponent(allPeople[1]))
        } catch {
            print(error)
        }
        currentDir = CFNS.appendingPathComponent(allPeople[currentPeople]) as NSString
        orgImage = UIImage(contentsOfFile: currentDir.appendingPathComponent(moraiPeople[currentMoraiPeople]))!
        currentImage = cutImg(image: orgImage, Int(x.value), Int(y.value))
        image.image = currentImage
        l.text = "\(allPeople.count):\(allPeople.count):\(moraiPeople.count):\(moraiPeople.count)"
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func NeXT() {
        let data = UIImagePNGRepresentation(currentImage)
        let dirURL = URL(fileURLWithPath: currentDir.appendingPathComponent(moraiPeople[currentMoraiPeople]))
        do {
            try data?.write(to: dirURL)
        } catch {
            print(error)
        }
        currentMoraiPeople += 1
        if currentMoraiPeople == moraiPeople.count {
            print("One Done")
            currentPeople += 1
            currentDir = CFNS.appendingPathComponent(allPeople[currentPeople]) as NSString
            do {
                try moraiPeople = FileManager.default.contentsOfDirectory(atPath: currentDir as String)
            } catch {
                print(error)
            }
            if moraiPeople[0] == ".DS_Store" {
                currentMoraiPeople = 1
            } else {
                currentMoraiPeople = 0
            }
            if currentPeople == allPeople.count {
                print("All Done")
                return
            }
        }
        orgImage = UIImage(contentsOfFile: currentDir.appendingPathComponent(moraiPeople[currentMoraiPeople]))!
        currentImage = cutImg(image: orgImage, Int(x.value), Int(y.value))
        image.image = currentImage
        l.text = "\(allPeople.count - currentPeople):\(allPeople.count):\(moraiPeople.count - currentMoraiPeople):\(moraiPeople.count)"
    }
    
    @IBAction func modify() {
        currentImage = cutImg(image: orgImage, Int(x.value), Int(y.value))
        image.image = currentImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


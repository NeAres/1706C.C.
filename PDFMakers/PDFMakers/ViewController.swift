//
//  ViewController.swift
//  PDFMakers
//
//  Created by Arendelle on 2017/7/15.
//  Copyright © 2017年 AdTech. All rights reserved.
//

import UIKit

let docDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
let docDirNS = docDir as NSString
let BasicInformDir = docDirNS.appendingPathComponent("BasicInf")
let BIDirNS = BasicInformDir as NSString
let ThemeDir = docDirNS.appendingPathComponent("Theme")
let TDirNS = ThemeDir as NSString
let SelfDefineDir = docDirNS.appendingPathComponent("SelfDefine")
let SDDirNS = SelfDefineDir as NSString
let SpecialCareDir = docDirNS.appendingPathComponent("SpecialCare")
let SCDirNS = SpecialCareDir as NSString
let SaveDir = docDirNS.appendingPathComponent("SavedContent")
let SDDDirNS = SaveDir as NSString
let classDict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "classes", ofType: "plist")!)
let nameDict = NSDictionary(contentsOfFile:Bundle.main.path(forResource: "Name", ofType: "plist")!)

class ViewController: UIViewController {
    
    var timer = Timer()
    var loopFlag = 44
    var classmateFlag = 0
    var currentTheme = ""
    var currentThemeDir = ""
    var currentNumber = 0
    var currentDir = ""
    var currentSaveDir = ""
    var CSDirNS = NSString()
    var numberContent = [String]()
    var scArray = NSMutableDictionary()
    //@IBOutlet weak var currentClassmate:UILabel!
    //@IBOutlet weak var currentDoing:UILabel!
    //@IBOutlet weak var preview:UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        /*classDict?.allValues[loopFlag] as! NSDictionary*/
        if plistLoad("Progress", key: "classmateFlag") != "0" {
            classmateFlag = Int(plistLoad("Progress", key: "classmateFlag"))!
            loopFlag = Int(plistLoad("Progress", key: "loopFlag"))!
        }
        let classmate = classDict?.allValues[loopFlag] as! NSDictionary
        currentTheme = classmate.value(forKey: "Theme") as! String
        currentSaveDir = SDDDirNS.appendingPathComponent(classDict?.allKeys[loopFlag] as! String)
        CSDirNS = currentSaveDir as NSString
        currentNumber = Int(classDict?.allKeys[loopFlag] as! String)!
        do {
            try FileManager.default.createDirectory(atPath: currentSaveDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
        currentThemeDir = currentTheme == "" ? SDDirNS.appendingPathComponent("\(currentNumber)") :  TDirNS.appendingPathComponent(currentTheme)
        var themeContent = [String]()
        for i in 0...61 {
            scArray.setValue(NSMutableArray.init(object: "0"), forKey: "\(i)")
        }
        do {
            try numberContent = FileManager.default.contentsOfDirectory(atPath: BasicInformDir)
            try themeContent = FileManager.default.contentsOfDirectory(atPath: currentThemeDir)
        } catch {
            print(error)
        }
        var specialCare = [String]()
        do {
            try specialCare = FileManager.default.contentsOfDirectory(atPath: SpecialCareDir)
        } catch {
            print(error)
        }
        for number in specialCare {
            if number == ".DS_Store" {
                continue
            }
            var cp = [String]()
            do {
                try cp = FileManager.default.contentsOfDirectory(atPath: SCDirNS.appendingPathComponent(number))
            } catch {
                print(error)
            }
            for c in cp {
                if c == ".DS_Store"{
                    continue
                }
                let idx = c.index(c.endIndex, offsetBy: -4)
                let sss = c.substring(to: idx)
                if let _ = scArray.value(forKey: sss) {
                    let array = scArray.value(forKey: sss) as! NSMutableArray
                    array.add(number)
                    scArray.setValue(array, forKey: sss)
                } else {
                    scArray.setValue(NSMutableArray(object: number), forKey: sss)
                }
                
            }
        }
        if classmateFlag < numberContent.count {
        } else {
            classmateFlag = 1
            loopFlag += 1
            currentNumber = Int(classDict?.allKeys[loopFlag] as! String)!
            currentSaveDir = SDDDirNS.appendingPathComponent(classDict?.allKeys[loopFlag] as! String)
            do {
                try FileManager.default.createDirectory(atPath: currentSaveDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        if currentTheme == "" {
            let content = numberContent[classmateFlag]
            let cti = Int(arc4random()) % (themeContent.count - 3) + 1
            var image = UIImage()
            let strr = (currentNumber == 54 || currentNumber == 9 || currentNumber == 25) ? ".png" : ".jpg"
            if cti <= 9 {
                image = UIImage(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("0\(cti)" + strr))!
            } else {
                image = UIImage(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti)" + strr))!
            }
            let nimage = add(backImages: image, frontImagesDir: BIDirNS.appendingPathComponent(content), isThemeWhite: false)
            
            let data = UIImageJPEGRepresentation(nimage, 1)
            do {
                try data?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+".jpg")))
            } catch {
                print(error)
            }
            if (scArray.object(forKey: "\(currentNumber)") as! NSMutableArray).contains(content) {
                let sci = #imageLiteral(resourceName: "2_s.png")
                let scci = UIImage(contentsOfFile: (SCDirNS.appendingPathComponent(content) as NSString).appendingPathComponent("\(currentNumber).png"))
                let simage = addSpecialCare(backImage: sci, specialCareImage: scci!, isThemeBlack: false, origin: CGPoint(x: 131, y: 40))
                
                let sdata = UIImageJPEGRepresentation(simage, 1)
                do {
                    try sdata?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+"_s"+".jpg")))
                } catch {
                    print(error)
                }
            }
        } else if currentTheme == "中国水墨" || currentTheme == "工业白" {
            let content = numberContent[classmateFlag]
            let cti = Int(arc4random()) % ((themeContent.count / 2 - 1)) + 1
            let image = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti).png"))
            let nimage = addA(backImage: image!, frontImagesDir: BIDirNS.appendingPathComponent(content), isThemeBlack: true)
            
            let data = UIImageJPEGRepresentation(nimage, 1)
            do {
                try data?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+".jpg")))
            } catch {
                print(error)
            }
            if (scArray.object(forKey: "\(currentNumber)") as! NSMutableArray).contains(content) {
                let sci = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti)_s.png"))
                let scci = UIImage(contentsOfFile: (SCDirNS.appendingPathComponent(content) as NSString).appendingPathComponent("\(currentNumber).png"))
                let simage = addSpecialCare(backImage: sci!, specialCareImage: scci!, isThemeBlack: true, origin: CGPoint(x: 131, y: 20))
                
                let sdata = UIImageJPEGRepresentation(simage, 1)
                do {
                    try sdata?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+"_s"+".jpg")))
                } catch {
                    print(error)
                }
            }
        } else if currentTheme == "九色奇迹" {
            let content = numberContent[classmateFlag]
            let cti = Int(arc4random()) % ((themeContent.count / 2 - 1)) + 1
            let image = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti).png"))
            let bb = ( cti == 4 || cti == 5 || cti == 6 )
            let nimage = add(backImage: image!, frontImagesDir: BIDirNS.appendingPathComponent(content), isThemeBlack: bb)
            
            let data = UIImageJPEGRepresentation(nimage, 1)
            do {
                try data?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+".jpg")))
            } catch {
                print(error)
            }
            if (scArray.object(forKey: "\(currentNumber)") as! NSMutableArray).contains(content) {
                let sci = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti)_s.png"))
                let scci = UIImage(contentsOfFile: (SCDirNS.appendingPathComponent(content) as NSString).appendingPathComponent("\(currentNumber).png"))
                let simage = addSpecialCare(backImage: sci!, specialCareImage: scci!, isThemeBlack: bb, origin: CGPoint(x: 131, y: 20))
                
                let sdata = UIImageJPEGRepresentation(simage, 1)
                do {
                    try sdata?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+"_s"+".jpg")))
                } catch {
                    print(error)
                }
            }
        } else {
            let content = numberContent[classmateFlag]
            let cti = Int(arc4random()) % ((themeContent.count / 2 - 1)) + 1
            let image = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti).png"))
            
            let nimage = add(backImages: image!, frontImagesDir: BIDirNS.appendingPathComponent(content), isThemeWhite: false)
            
            let data = UIImageJPEGRepresentation(nimage, 1)
            do {
                try data?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+".jpg")))
            } catch {
                print(error)
            }
            if (scArray.object(forKey: "\(currentNumber)") as! NSMutableArray).contains(content) {
                let sci = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti)_s.png"))
                let scci = UIImage(contentsOfFile: (SCDirNS.appendingPathComponent(content) as NSString).appendingPathComponent("\(currentNumber).png"))
                let simage = addSpecialCare(backImage: sci!, specialCareImage: scci!, isThemeBlack: false, origin: CGPoint(x: 131, y: 423))
                
                let sdata = UIImageJPEGRepresentation(simage, 1)
                do {
                    try sdata?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+"_s"+".jpg")))
                } catch {
                    print(error)
                }
            }
        }
        nextx()
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func nextx(){
        for _ in 0...1000000{
            if classmateFlag < numberContent.count {
                classmateFlag += 1
            } else {
                classmateFlag = 1
                loopFlag += 1
                currentNumber = Int(classDict?.allKeys[loopFlag] as! String)!
                currentSaveDir = SDDDirNS.appendingPathComponent(classDict?.allKeys[loopFlag] as! String)
                do {
                    try FileManager.default.createDirectory(atPath: currentSaveDir, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error)
                }
            }
            plist("Progress", setValue: "\(classmateFlag)", forKey: "classmateFlag")
            plist("Progress", setValue: "\(loopFlag)", forKey: "loopFlag")
            let classmate = classDict?.allValues[loopFlag] as! NSDictionary
            currentTheme = classmate.value(forKey: "Theme") as! String
            currentThemeDir = currentTheme == "" ? SDDirNS.appendingPathComponent("\(currentNumber)") :  TDirNS.appendingPathComponent(currentTheme)
            var themeContent = [String]()
            do {
                try themeContent = FileManager.default.contentsOfDirectory(atPath: currentThemeDir)
            } catch {
                print(error)
            }
            if loopFlag == classDict?.count {
                print("All is well")
                return
            }
            if currentTheme == "" {
                let content = numberContent[classmateFlag]
                let cti = Int(arc4random()) % (themeContent.count - 3) + 1
                var image = UIImage()
                let strr = (currentNumber == 54 || currentNumber == 9 || currentNumber == 25) ? ".png" : ".jpg"
                if cti <= 9 {
                    image = UIImage(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("0\(cti)" + strr))!
                } else {
                    image = UIImage(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti)" + strr))!
                }
                let nimage = add(backImages: image, frontImagesDir: BIDirNS.appendingPathComponent(content), isThemeWhite: false)
                
                let data = UIImageJPEGRepresentation(nimage, 1)
                do {
                    try data?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+".jpg")))
                } catch {
                    print(error)
                }
                if (scArray.object(forKey: "\(currentNumber)") as! NSMutableArray).contains(content) {
                    let sci = UIImage(contentsOfFile: Bundle.main.path(forResource: "2_s", ofType: "png")!)!
                    let scci = UIImage(contentsOfFile: (SCDirNS.appendingPathComponent(content) as NSString).appendingPathComponent("\(currentNumber).png"))
                    let simage = addSpecialCare(backImage: sci, specialCareImage: scci!, isThemeBlack: true, origin: CGPoint(x: 131, y: 40))
                    let sdata = UIImageJPEGRepresentation(simage, 1)
                    do {
                        try sdata?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+"_s"+".jpg")))
                    } catch {
                        print(error)
                    }
                }
            } else if currentTheme == "中国水墨" || currentTheme == "工业白" {
                let content = numberContent[classmateFlag]
                let cti = Int(arc4random()) % ((themeContent.count / 2 - 1)) + 1
                let image = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti).png"))
                let nimage = addA(backImage: image!, frontImagesDir: BIDirNS.appendingPathComponent(content), isThemeBlack: true)
                let data = UIImageJPEGRepresentation(nimage, 1)
                do {
                    try data?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+".jpg")))
                } catch {
                    print(error)
                }
                if (scArray.object(forKey: "\(currentNumber)") as! NSMutableArray).contains(content) {
                    let sci = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti)_s.png"))
                    let scci = UIImage(contentsOfFile: (SCDirNS.appendingPathComponent(content) as NSString).appendingPathComponent("\(currentNumber).png"))
                    let simage = addSpecialCare(backImage: sci!, specialCareImage: scci!, isThemeBlack: true, origin: CGPoint(x: 131, y: 20))
                    let sdata = UIImageJPEGRepresentation(simage, 1)
                    do {
                        try sdata?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+"_s"+".jpg")))
                    } catch {
                        print(error)
                    }
                }
            } else if currentTheme == "九色奇迹" {
                let content = numberContent[classmateFlag]
                let cti = Int(arc4random()) % ((themeContent.count / 2 - 1)) + 1
                let image = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti).png"))
                let bb = ( cti == 4 || cti == 5 || cti == 6 )
                let nimage = add(backImage: image!, frontImagesDir: BIDirNS.appendingPathComponent(content), isThemeBlack: bb)
                let data = UIImageJPEGRepresentation(nimage, 1)
                do {
                    try data?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+".jpg")))
                } catch {
                    print(error)
                }
                if (scArray.object(forKey: "\(currentNumber)") as! NSMutableArray).contains(content) {
                    let sci = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti)_s.png"))
                    let scci = UIImage(contentsOfFile: (SCDirNS.appendingPathComponent(content) as NSString).appendingPathComponent("\(currentNumber).png"))
                    let simage = addSpecialCare(backImage: sci!, specialCareImage: scci!, isThemeBlack: bb, origin: CGPoint(x: 131, y: 20))
                    let sdata = UIImageJPEGRepresentation(simage, 1)
                    do {
                        try sdata?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+"_s"+".jpg")))
                    } catch {
                        print(error)
                    }
                }
            } else {
                let content = numberContent[classmateFlag]
                let cti = Int(arc4random()) % ((themeContent.count / 2 - 1)) + 1
                let image = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti).png"))
                let nimage = add(backImages: image!, frontImagesDir: BIDirNS.appendingPathComponent(content), isThemeWhite: false)
                
                let data = UIImageJPEGRepresentation(nimage, 1)
                do {
                    try data?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+".jpg")))
                } catch {
                    print(error)
                }
                if (scArray.object(forKey: "\(currentNumber)") as! NSMutableArray).contains(content) {
                    let sci = UIImage.init(contentsOfFile: (currentThemeDir as NSString).appendingPathComponent("\(cti)_s.png"))
                    let scci = UIImage(contentsOfFile: (SCDirNS.appendingPathComponent(content) as NSString).appendingPathComponent("\(currentNumber).png"))
                    let simage = addSpecialCare(backImage: sci!, specialCareImage: scci!, isThemeBlack: false, origin: CGPoint(x: 131, y: 423))
                    
                    let sdata = UIImageJPEGRepresentation(simage, 1)
                    do {
                        try sdata?.write(to: URL(fileURLWithPath: CSDirNS.appendingPathComponent(content+"_s"+".jpg")))
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func present(){
        
    }
    
}

//from viewdidappear
/*let selfDefineDir = docDirNS.appendingPathComponent("SelfDefine")
 let SDDirNS = selfDefineDir as NSString
 var fileArr = [String]()
 do {
 try fileArr = FileManager.default.contentsOfDirectory(atPath: selfDefineDir)
 } catch {
 print(error)
 }
 for file in fileArr {
 if file == ".DS_Store" {
 continue
 }
 let numberDir = SDDirNS.appendingPathComponent(file)
 let NDirNS = numberDir as NSString
 var allImages = [String]()
 do {
 try allImages = FileManager.default.contentsOfDirectory(atPath: numberDir)
 } catch {
 print(error)
 }
 let theme = arc4random()%10
 for imageSingle in allImages {
 if imageSingle == ".DS_Store" {
 continue
 }
 fitFileRead(fileDir: NDirNS.appendingPathComponent(imageSingle), theme: Int(theme))
 }
 }*/

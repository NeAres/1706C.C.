//
//  Add.swift
//  PDFMakers
//
//  Created by Arendelle on 2017/7/21.
//  Copyright © 2017年 AdTech. All rights reserved.
//

import UIKit

func addA(backImage:UIImage, frontImagesDir:String, isThemeBlack:Bool) -> UIImage {
    let PtsDict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Pts", ofType: "plist")!)
    var Images = [String]()
    let FIDirNS = frontImagesDir as NSString
    do {
        try Images = FileManager.default.contentsOfDirectory(atPath: frontImagesDir)
    } catch {
        print(error)
    }
    UIGraphicsBeginImageContext(CGSize(width: 2480, height: 3508))
    backImage.draw(at: CGPoint(x:0,y:0))
    //Images = [Images[1]]
    for img in Images {
        if img == ".DS_Store" {
            continue
        }
        let idx = img.index(img.endIndex, offsetBy: -4)
        let name = img.substring(to: idx)
        if name == "Photo" {
            continue
        }
        let x1 = ((PtsDict?.value(forKey: name) as! NSArray)[0] as! NSNumber).intValue
        let y1 = ((PtsDict?.value(forKey: name) as! NSArray)[1] as! NSNumber).intValue
        let x2 = ((PtsDict?.value(forKey: name) as! NSArray)[2] as! NSNumber).intValue
        let y2 = ((PtsDict?.value(forKey: name) as! NSArray)[3] as! NSNumber).intValue
        let w = Double(x2 - x1)
        let h = Double(y2 - y1)
        var ratio = 0.0
        let image = UIImage(contentsOfFile: FIDirNS.appendingPathComponent(img))
        let iw = Double((image?.cgImage?.width)!)
        let ih = Double((image?.cgImage?.height)!)
        if Double(iw)/w > Double(ih)/h { //w ad
            ratio = w/Double(iw)
        } else { //h ad
            ratio = h/Double(ih)
        }
        image?.draw(in: CGRect(x: Double(x1), y: Double(y1), width: ratio*iw, height: ratio*ih))
    }
    let imgs = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return imgs!
}

func add(backImages:UIImage, frontImagesDir:String, isThemeWhite:Bool) -> UIImage {
    if frontImagesDir.contains(".DS_Store") {
        return backImages
    }
    let PtsDict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Pts", ofType: "plist")!)
    var Images = [String]()
    let FIDirNS = frontImagesDir as NSString
    do {
        try Images = FileManager.default.contentsOfDirectory(atPath: frontImagesDir)
    } catch {
        print(error)
    }
    UIGraphicsBeginImageContext(CGSize(width: 2480, height: 3508))
    backImages.draw(at: CGPoint(x:0,y:0))
    //Images = [Images[1]]
    for img in Images {
        if img == ".DS_Store" {
            continue
        }
        let idx = img.index(img.endIndex, offsetBy: -4)
        let name = img.substring(to: idx)
        if name == "Photo" {
            continue
        }
        let x1 = ((PtsDict?.value(forKey: name) as! NSArray)[0] as! NSNumber).intValue
        let y1 = ((PtsDict?.value(forKey: name) as! NSArray)[1] as! NSNumber).intValue
        let x2 = ((PtsDict?.value(forKey: name) as! NSArray)[2] as! NSNumber).intValue
        let y2 = ((PtsDict?.value(forKey: name) as! NSArray)[3] as! NSNumber).intValue
        let w = Double(x2 - x1)
        let h = Double(y2 - y1)
        var ratio = 0.0
        var image = UIImage(contentsOfFile: FIDirNS.appendingPathComponent(img))
        let iw = Double((image?.cgImage?.width)!)
        let ih = Double((image?.cgImage?.height)!)
        if Double(iw)/w > Double(ih)/h { //w ad
            ratio = w/Double(iw)
        } else { //h ad
            ratio = h/Double(ih)
        }
        let ciimages = CIFilter(name: "CIColorMatrix", withInputParameters: [
            kCIInputImageKey : CIImage(image: image!),
            "inputRVector" : CIVector(x: -1, y: 0, z: 0),
            "inputGVector" : CIVector(x: 0, y: -1, z: 0),
            "inputBVector" : CIVector(x: 0, y: 0, z: -1),
            "inputBiasVector" : CIVector(x: 1, y: 1, z: 1),
            ])?.outputImage
        image = UIImage(ciImage: ciimages!)
        image?.draw(in: CGRect(x: Double(x1), y: Double(y1), width: ratio*iw, height: ratio*ih))
    }
    let imgs = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return imgs!
}

func add(backImage:UIImage, frontImagesDir:String, isThemeBlack:Bool) -> UIImage{
    let PtsDict = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Pts", ofType: "plist")!)
    var Images = [String]()
    let FIDirNS = frontImagesDir as NSString
    var data = backImage.cgImage?.dataProvider?.data as! CFMutableData
    var dataPointer = CFDataGetMutableBytePtr(data)
    do {
        try Images = FileManager.default.contentsOfDirectory(atPath: frontImagesDir)
    } catch {
        print(error)
    }
    //Images = [Images[1]]
    for img in Images {
        if img == ".DS_Store" {
            continue
        }
        let idx = img.index(img.endIndex, offsetBy: -4)
        let name = img.substring(to: idx)
        if name == "Photo" {
            continue
        }
        let x1 = ((PtsDict?.value(forKey: name) as! NSArray)[0] as! NSNumber).intValue
        let y1 = ((PtsDict?.value(forKey: name) as! NSArray)[1] as! NSNumber).intValue
        let x2 = ((PtsDict?.value(forKey: name) as! NSArray)[2] as! NSNumber).intValue
        let y2 = ((PtsDict?.value(forKey: name) as! NSArray)[3] as! NSNumber).intValue
        let w = Double(x2 - x1)
        let h = Double(y2 - y1)
        var xDest = x2
        var yDest = y2
        let image = UIImage(contentsOfFile: FIDirNS.appendingPathComponent(img))
        var altedImage = image!
        if Double((image?.cgImage?.width)!)/Double((image?.cgImage?.height)!) > w/h { //w ad
            yDest = (altedImage.cgImage?.height)! > Int(h) ? y2 : y1 + (altedImage.cgImage?.height)!
        } else { //h ad
            xDest = (altedImage.cgImage?.width)! > Int(w) ? x2 : x1 + (altedImage.cgImage?.width)!
        }
        let addedData = altedImage.cgImage?.dataProvider?.data as! CFMutableData
        let addedDataPointer = CFDataGetMutableBytePtr(addedData)
        for x in x1...xDest {
            for y in y1...yDest {
                if isThemeBlack {
                    let currentPxl = (y * 2480 + x)*4
                    let ACP = ((y - y1) * (altedImage.cgImage?.width)! + x - x1)*4
                    let r = (addedDataPointer?[ACP])!
                    let g = (addedDataPointer?[ACP + 1])!
                    let b = (addedDataPointer?[ACP + 2])!
                    if isWhite(r: Int(r), g: Int(g), b: Int(b)) || addedDataPointer?[ACP+3] == 0 {
                        continue
                    } else {
                        if isBlack(r: Int(r), g: Int(g), b: Int(b)) {
                            dataPointer?[currentPxl] = 0
                            dataPointer?[currentPxl + 1] = 0
                            dataPointer?[currentPxl + 2] = 0
                        } else {
                            dataPointer?[currentPxl] = r
                            dataPointer?[currentPxl + 1] = g
                            dataPointer?[currentPxl + 2] = b
                        }
                    }
                } else {
                    let currentPxl = (y * 2480 + x)*4
                    let ACP = ((y - y1) * (altedImage.cgImage?.width)! + x - x1)*4
                    let r = (addedDataPointer?[ACP])!
                    let g = (addedDataPointer?[ACP + 1])!
                    let b = (addedDataPointer?[ACP + 2])!
                    if isWhite(r: Int(r), g: Int(g), b: Int(b)) || addedDataPointer?[ACP+3] == 0 {
                        continue
                    } else {
                        if isBlack(r: Int(r), g: Int(g), b: Int(b)) {
                            dataPointer?[currentPxl] = 255
                            dataPointer?[currentPxl + 1] = 255
                            dataPointer?[currentPxl + 2] = 255
                        } else {
                            dataPointer?[currentPxl] = r
                            dataPointer?[currentPxl + 1] = g
                            dataPointer?[currentPxl + 2] = b
                        }
                    }
                }
            }
        }
    }
    let imgs = UIImage(cgImage: (CGContext(data: dataPointer, width: (backImage.cgImage?.width)!, height: (backImage.cgImage?.height)!, bitsPerComponent: (backImage.cgImage?.bitsPerComponent)!, bytesPerRow: (backImage.cgImage?.bytesPerRow)!, space: (backImage.cgImage?.colorSpace)!, bitmapInfo: (backImage.cgImage?.bitmapInfo.rawValue)!)?.makeImage())!)
    dataPointer = nil
    return imgs
    
}

func isWhite(r:Int,g:Int,b:Int) -> Bool {
    if r > 200 && g > 200 && b > 200 {
        return true
    } else {
        return false
    }
}

func isBlack(r:Int, g:Int, b:Int) -> Bool {
    if abs(r-g) < 20 && abs(g-b) < 20 && abs(b-r) < 20 {
        return true
    } else {
        return false
    }
}

func addSpecialCare(backImage:UIImage, specialCareImage:UIImage, isThemeBlack:Bool, origin:CGPoint) -> UIImage{
    let data = backImage.cgImage?.dataProvider?.data as! CFMutableData
    let dataPointer = CFDataGetMutableBytePtr(data)
    let x1 = Int(origin.x)
    let y1 = Int(origin.y)
    let x2 = x1 + 2218
    let y2 = y1 + 2663
    let w = 2218.0
    let h = 2663.0
    var xDest = x2
    var yDest = y2
    let image = specialCareImage
    var altedImage = image
    if Double((image.cgImage?.width)!)/Double((image.cgImage?.height)!) > w/h { //w ad
        yDest = (altedImage.cgImage?.height)! > Int(h) ? y2 : y1 + (altedImage.cgImage?.height)!
    } else { //h ad
        xDest = (altedImage.cgImage?.width)! > Int(w) ? x2 : x1 + (altedImage.cgImage?.width)!
    }
    let addedData = altedImage.cgImage?.dataProvider?.data as! CFMutableData
    let addedDataPointer = CFDataGetMutableBytePtr(addedData)
    for x in x1...xDest {
        for y in y1...yDest {
            if isThemeBlack {
                let currentPxl = (y * 2480 + x)*4
                let ACP = ((y - y1) * (altedImage.cgImage?.width)! + x - x1)*4
                let r = (addedDataPointer?[ACP])!
                let g = (addedDataPointer?[ACP + 1])!
                let b = (addedDataPointer?[ACP + 2])!
                if isWhite(r: Int(r), g: Int(g), b: Int(b)) || addedDataPointer?[ACP+3] == 0 {
                    continue
                } else {
                    if isBlack(r: Int(r), g: Int(g), b: Int(b)) {
                        dataPointer?[currentPxl] = 0
                        dataPointer?[currentPxl + 1] = 0
                        dataPointer?[currentPxl + 2] = 0
                    } else {
                        dataPointer?[currentPxl] = r
                        dataPointer?[currentPxl + 1] = g
                        dataPointer?[currentPxl + 2] = b
                    }
                }
            } else {
                let currentPxl = (y * 2480 + x)*4
                let ACP = ((y - y1) * (altedImage.cgImage?.width)! + x - x1)*4
                let r = (addedDataPointer?[ACP])!
                let g = (addedDataPointer?[ACP + 1])!
                let b = (addedDataPointer?[ACP + 2])!
                if isWhite(r: Int(r), g: Int(g), b: Int(b)) || addedDataPointer?[ACP+3] == 0 {
                    continue
                } else {
                    if isBlack(r: Int(r), g: Int(g), b: Int(b)) {
                        dataPointer?[currentPxl] = 255
                        dataPointer?[currentPxl + 1] = 255
                        dataPointer?[currentPxl + 2] = 255
                    } else {
                        dataPointer?[currentPxl] = r
                        dataPointer?[currentPxl + 1] = g
                        dataPointer?[currentPxl + 2] = b
                    }
                }
            }
        }
    }
    return UIImage(cgImage: (CGContext(data: dataPointer, width: (backImage.cgImage?.width)!, height: (backImage.cgImage?.height)!, bitsPerComponent: (backImage.cgImage?.bitsPerComponent)!, bytesPerRow: (backImage.cgImage?.bytesPerRow)!, space: (backImage.cgImage?.colorSpace)!, bitmapInfo: (backImage.cgImage?.bitmapInfo.rawValue)!)?.makeImage())!)
}

func scale(image:UIImage,ratio:Double) -> UIImage {
    let fullRect = CGSize(width: Double((image.cgImage?.width)!) * ratio, height: Double((image.cgImage?.height)!) * ratio)
        UIGraphicsBeginImageContext(fullRect)
    image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: fullRect))
    let i = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return i!
}

func plistLoad(_ plistName:String,key:String) -> String{
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let documentsDirectory:NSString = paths[0] as NSString
    let path = documentsDirectory.appendingPathComponent(plistName+".plist")
    let manag = FileManager()
    if manag.fileExists(atPath: path) {
        let data = NSDictionary(contentsOfFile: path)
        if let _ = data
        {
            if let _ = data?.object(forKey: key){
                return data?.object(forKey: key) as! String
            }
            else{
                return "0"
            }
        }
        else
        {
            return "0"
        }
    }
    else{
        return "0"
    }
}

func plist(_ plistname:String,setValue:String,forKey:String!){
    var paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    let documentsDirectory:NSString = paths[0] as NSString
    let path = documentsDirectory.appendingPathComponent(plistname+".plist")
    let fileManager = FileManager.default
    let fileExists:Bool = fileManager.fileExists(atPath: path)
    var data:NSMutableDictionary?
    if fileExists == false{
        data = NSMutableDictionary()
    }
    else{
        data = NSMutableDictionary(contentsOfFile: path)
    }
    data?.setValue(setValue, forKey: forKey!)
    data?.write(toFile: path, atomically: true)
}


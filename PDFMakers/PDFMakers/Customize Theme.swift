//
//  Customize Theme.swift
//  PDFMakers
//
//  Created by Arendelle on 2017/7/19.
//  Copyright © 2017年 AdTech. All rights reserved.
//

import UIKit

func fitFileRead(fileDir:String, theme:Int) {
    let themeImage = Bundle.main.path(forResource: "\(theme)", ofType: "png")
    let image = UIImage(contentsOfFile: fileDir)!
    if Double((image.cgImage?.width)!)/Double((image.cgImage?.height)!) > 2480.0/3508.0 {
        let croppedWidth = Double((image.cgImage?.height)!) / 3508.0 * 2480.0
        var themedImage = UIImage(contentsOfFile: themeImage!)
        UIGraphicsBeginImageContext(CGSize(width: 2480, height: 3508))
        var croppedCGImage = image.cgImage?.cropping(to: CGRect(x: (Double((image.cgImage?.width)!) - croppedWidth) / 2.0, y: 0, width: croppedWidth, height: Double((image.cgImage?.height)!)))
        var croppedUIImage = UIImage(cgImage: croppedCGImage!)
        var blackMask = #imageLiteral(resourceName: "ZERO.png")
        croppedUIImage.draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
        blackMask.draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
        themedImage?.draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
        var finalDerivedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imageData = UIImageJPEGRepresentation(finalDerivedImage!, 1.0)
        do {
            try imageData?.write(to: URL.init(fileURLWithPath: fileDir))
        } catch {
            print(error)
        }
        imageData = nil
        finalDerivedImage = nil
        croppedCGImage = nil
        themedImage = nil
    } else {
        let croppedHeight = Double((image.cgImage?.width)!) / 2480.0 * 3508.0
        var themedImage = UIImage(contentsOfFile: themeImage!)
        UIGraphicsBeginImageContext(CGSize(width: 2480, height: 3508))
        var croppedCGImage = image.cgImage?.cropping(to: CGRect(x: 0, y: (Double((image.cgImage?.height)!) - croppedHeight) / 2.0, width: Double((image.cgImage?.width)!), height: croppedHeight))
        var croppedUIImage = UIImage(cgImage: croppedCGImage!)
        var blackMask = #imageLiteral(resourceName: "ZERO.png")
        croppedUIImage.draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
        blackMask.draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
        themedImage?.draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
        var finalDerivedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imageData = UIImageJPEGRepresentation(finalDerivedImage!, 1.0)
        do {
            try imageData?.write(to: URL.init(fileURLWithPath: fileDir))
        } catch {
            print(error)
        }
        imageData = nil
        finalDerivedImage = nil
        croppedCGImage = nil
        themedImage = nil
    }
}

func enlongFile(fileInString:String) {
    let image = UIImage(contentsOfFile: fileInString)
    var image0 = UIImage()
    if (image?.cgImage?.width)! > (image?.cgImage?.height)! {
        image0 = UIImage(ciImage: (image?.ciImage?.applyingOrientation(Int32(UIImageOrientation.right.rawValue)))!)
    }
    var imageData = UIImageJPEGRepresentation(image0, 1.0)
    do {
        try imageData?.write(to: URL(fileURLWithPath: fileInString))
    } catch {
        print(error)
    }
    imageData = nil
}

func enlongImage(image:UIImage) -> UIImage {
    if (image.cgImage?.width)! > (image.cgImage?.height)! {
        return UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: UIImageOrientation.right)
    } else {
        return image
    }
}

func blurImage(cgImage:CGImage) -> UIImage {
    return UIImage(cgImage: cgImage)
}

class CustomThemeManager {
    
    func fitDirRead(fileDir:String) { //one for all, read every image, random select font, synth.
        var allImages = [String]()
        do {
            try allImages = FileManager.default.contentsOfDirectory(atPath: fileDir)
        } catch {
            print(error)
        }
        let theme = arc4random()%10
        let themeImage = Bundle.main.path(forResource: "\(theme)", ofType: "png")
        for imageSingle in allImages {
            if imageSingle == ".DS_Store" {
                continue
            }
            let image = UIImage(contentsOfFile: (fileDir as NSString).appendingPathComponent(imageSingle))!
            if Double((image.cgImage?.width)!)/Double((image.cgImage?.height)!) > 2480.0/3508.0 {
                let croppedWidth = Double((image.cgImage?.height)!) / 3508.0 * 2480.0
                UIGraphicsBeginImageContext(CGSize(width: 2480, height: 3508))
                let croppedCGImage = image.cgImage?.cropping(to: CGRect(x: (Double((image.cgImage?.width)!) - croppedWidth) / 2.0, y: 0, width: croppedWidth, height: Double((image.cgImage?.height)!)))
                blurImage(cgImage: croppedCGImage!).draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
                UIImage(contentsOfFile: themeImage!)?.draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
                let finalDerivedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                print("x")
                let imageData = UIImageJPEGRepresentation(finalDerivedImage!, 1.0)
                do {
                    try imageData?.write(to: URL.init(fileURLWithPath: (fileDir as NSString).appendingPathComponent(imageSingle)))
                } catch {
                    print(error)
                }
            } else {
                let croppedHeight = Double((image.cgImage?.width)!) / 2480.0 * 3508.0
                UIGraphicsBeginImageContext(CGSize(width: 2480, height: 3508))
                let croppedCGImage = image.cgImage?.cropping(to: CGRect(x: 0, y: (Double((image.cgImage?.height)!) - croppedHeight) / 2.0, width: Double((image.cgImage?.width)!), height: croppedHeight))
                blurImage(cgImage: croppedCGImage!).draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
                UIImage(ciImage: CIImage(color: CIColor(red: 0, green: 0, blue: 0, alpha: 0.4))).draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
                UIImage(contentsOfFile: themeImage!)?.draw(in: CGRect(x: 0, y: 0, width: 2480, height: 3508))
                let finalDerivedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let imageData = UIImageJPEGRepresentation(finalDerivedImage!, 1.0)
                do {
                    try imageData?.write(to: URL.init(fileURLWithPath: (fileDir as NSString).appendingPathComponent(imageSingle)))
                } catch {
                    print(error)
                }
            }
        }
    }
    
}

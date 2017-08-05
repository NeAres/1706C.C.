//
//  Helper.swift
//  Cut&Paste
//
//  Created by Arendelle on 2017/7/14.
//  Copyright © 2017年 AdTech. All rights reserved.
//

import UIKit

func cutImg(image:UIImage, _ xdis:Int, _ ydis:Int, number:Int) {
    let fileManager = FileManager()
    let imagePath = dirPathNS.appendingPathComponent("\(number)")
    if !fileManager.fileExists(atPath: imagePath) {
        do {
            try fileManager.createDirectory(atPath: imagePath, withIntermediateDirectories: false, attributes: nil)
        } catch {
            print(error)
        }
    }
    for item in dict! {
        let array = item.value as! NSArray
        let x1 = (array[0] as! NSNumber).intValue - 14 + xdis
        let y1 = (array[1] as! NSNumber).intValue + 25 + ydis
        let x2 = (array[2] as! NSNumber).intValue - 20 + xdis
        let y2 = (array[3] as! NSNumber).intValue + 25 + ydis
        let w = x2 - x1 - 45
        let h = y2 - y1 - 15
        let im = image.cgImage?.cropping(to: CGRect(x: x1, y: y1, width: w, height: h))
        //print("\(item),\(im)")
        let singleImagePath = (imagePath as NSString).appendingPathComponent("\(item.key as! String).png")
        let url = URL(fileURLWithPath: singleImagePath)
        let imageData = UIImagePNGRepresentation(UIImage(cgImage: im!))
        do {
            try imageData?.write(to: url)
        } catch {
            print(error)
        }
    }
}

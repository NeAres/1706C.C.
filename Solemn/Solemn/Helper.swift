//
//  Helper.swift
//  Cut&Paste
//
//  Created by Arendelle on 2017/7/14.
//  Copyright © 2017年 AdTech. All rights reserved.
//

import UIKit

func cutImg(image:UIImage, _ xdis:Int, _ ydis:Int) -> UIImage {
    let x1 = 102 + xdis
    let y1 = 162 + ydis
    let w = 2218
    let h = 2663
    let im = image.cgImage?.cropping(to: CGRect(x: x1, y: y1, width: w, height: h))
    return UIImage(cgImage: im!)
}


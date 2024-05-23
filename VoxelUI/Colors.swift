//
//  Colors.swift
//  VoxelUI
//
//  Created by Jonathan French on 21.05.24.
//

import Foundation
import UIKit

let colors_w = 512;
let colors_h = 512;


//void set_palette() {
//    unsigned short *pal = 0xff8240;
//    *pal++ = 0x133 + 0x008;1133bb
//    *pal++ = 0x110 + 0x008;111188
//    *pal++ = 0x110 + 0x808;991188
//    *pal++ = 0x112 + 0x080;119922
//    *pal++ = 0x120 + 0x008;112288
//    *pal++ = 0x211 + 0x080;229911
//    *pal++ = 0x221 + 0x008;222299
//    *pal++ = 0x221 + 0x080;22aa11
//    *pal++ = 0x221 + 0x808;aa2299
//    *pal++ = 0x231 + 0x008;223399
//    *pal++ = 0x322 + 0x080;33aa22
//    *pal++ = 0x322 + 0x080;33aa22
//    *pal++ = 0x232 + 0x800;aa3322
//    *pal++ = 0x332 + 0x008;3333aa
//    *pal++ = 0x333 + 0x880;bbbb33
//    *pal++ = 0x333 + 0x888;bbbbbb
//}

//Identified colors in no order

//0 #ffffff
//1 #a5ab72
//2 #6e593d
//3 #51bffd
//8 #bea686
//? #ccbaa5
//7 #91b65d
//? #a28963
//9 #a5c971
//? #6e9741
//? #d3c89d
//? #b4c88d
//? #f0ecd7
//? #607072
//15 #000000
//? #8ea69c

//Tan           #bea686
//Tan           #ccbaa5
//DarkSeaGreen  #91b65d
//Gray          #a28963
//YellowGreen   #a5c971
//OliveDrab     #6e9741
//Tan           #d3c89d
//DimGray       #6e593d
//DarkSeaGreen  #b4c88d
//DeepSkyBlue   #51bffd
//DarkKhaki     #a5ab72
//Beige         #f0ecd7
//White         #ffffff
//DimGray       #607072
//Black         #000000
//DarkGray      #8ea69c



func getColor(index: Int) -> UIColor {
    switch index {
    case 0:
//        return UIColor(rgb: 0xffffff)//White
        return UIColor(rgb: 0x000000)//Black
    case 1:
        return UIColor(rgb: 0xa5ab72)//Greeny Brown
    case 2:
        return UIColor(rgb: 0x6e593d)//?? Magenta nah Darker brown
    case 3:
        //return UIColor(rgb: 0x51bffd)//Blue?
        return UIColor(rgb: 0x6e9741)//OliveDrab?
    case 4:
        //return UIColor(rgb: 0x112288)//Dark Blue
        return UIColor(rgb: 0x91b65d)//DarkSeaGreen
    case 5:
//        return UIColor(rgb: 0x229911)//Green
        return UIColor(rgb: 0xa5ab72)//DarkKhaki
    case 6:
        return UIColor(rgb: 0x51bffd)//Deep Blue
    case 7:
        return UIColor(rgb: 0x91b65d)//light green
    case 8:
        return UIColor(rgb: 0xbea686)//light brown
    case 9:
        return UIColor(rgb: 0xa5c971)//light green
    case 10:
        return UIColor(rgb: 0xbea686)// Tan 1
    case 11:
        return UIColor(rgb: 0xccbaa5)// Tan 2
    case 12:
        return UIColor(rgb: 0xd3c89d)// Tan 3
    case 13:
       // return UIColor(rgb: 0x3333aa)// ??Another dark blue
        return UIColor(rgb: 0x607072)// ??607072
    case 14:
        //return UIColor(rgb: 0xbbbb33)// ??Mustardy yellow
        return UIColor(rgb: 0x8ea69c)// ??DarkGray
    case 15:
        return UIColor(rgb: 0xffffff)//White
//        return UIColor(rgb: 0x000000)//Black

    default:
        return .clear
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension CALayer {
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void){
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}

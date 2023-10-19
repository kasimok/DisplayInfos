//
//  ViewController.swift
//  DisplayInfos
//
//  Created by 0x67 on 2023-10-19.
//

import Cocoa
import CoreGraphics

let kReferencePeakHDRLuminanceKey = "ReferencePeakHDRLuminance"
let kNonReferencePeakHDRLuminance = "NonReferencePeakHDRLuminance"
let kReferencePeakSDRLuminanceKey = "ReferencePeakSDRLuminance"
let kProdcutName = "DisplayProductName"

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    listScreenInfos()
  }

  private func listScreenInfos() {
    // get display count
    var displayCount: UInt32 = UInt32(NSScreen.screens.count)
    
    // allocate memory for the display IDs
    let displays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: Int(displayCount))
    
    // Get the online display IDs
    CGGetOnlineDisplayList(displayCount, displays, &displayCount)
    
    // print the display count and IDs
    print("Display Count: \(displayCount)")
    for i in 0..<displayCount {
      let currentDisplay: CGDirectDisplayID = displays[Int(i)]
      guard let displayInfo = CoreDisplay_DisplayCreateInfoDictionary(currentDisplay)?.takeRetainedValue() as? [String: AnyObject] else {
        fatalError("CoreDisplay_DisplayCreateInfoDictionary fetch failed")
      }
      guard let productNames = displayInfo[kProdcutName] as? [String: AnyObject] else {
        fatalError("\(kProdcutName) not found")
      }
      
      let name = productNames["en_US"] as! String
      
      let peakHDRLuminance = displayInfo[kReferencePeakHDRLuminanceKey] as? Int
      let nrPeakHDRLuminance = displayInfo[kNonReferencePeakHDRLuminance] as? Int
      let sdrLuminance = displayInfo[kReferencePeakSDRLuminanceKey] as? Int
      
      print("[\(name)]", "peakHDRLuminance: \(peakHDRLuminance)", "nrPeakHDRLuminance:\(nrPeakHDRLuminance)", "sdrLuminance:\(sdrLuminance)")
      
    }
    
    displays.deallocate()
  }

}


//
//  Hud.swift
//  Foodly
//
//  Created by Decagon on 09/06/2021.
//

import Foundation
import SVProgressHUD

final class HUD {
    class func show(status: String) {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setForegroundColor(foodlyPurple ?? .systemTeal)
            SVProgressHUD.setBackgroundColor(.black)
            SVProgressHUD.setBackgroundLayerColor(.clear)
            SVProgressHUD.show(withStatus: status)
        }
    }
    
    class func hide() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}

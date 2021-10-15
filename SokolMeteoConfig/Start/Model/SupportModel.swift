//
//  SupportModel.swift
//  SOKOL
//
//  Created by Володя Зверев on 20.04.2021.
//  Copyright © 2021 zverev. All rights reserved.
//

import UIKit
import FittedSheets

class SupportModel: NSObject {
    
    static func transitionSupport() -> SheetViewController {
        let controller = SupportController()
        
        let sheetController = SheetViewController(
            controller: controller,
            sizes: [.percent(0.2), .fixed(screenH * 0.2), .fullscreen])
        
        // The size of the grip in the pull bar
        sheetController.gripSize = CGSize(width: 50, height: 6)
        
        // The color of the grip on the pull bar
        sheetController.gripColor = UIColor(white: 0.868, alpha: 1)
        
        // The corner radius of the sheet
        sheetController.cornerRadius = 35
        
        // minimum distance above the pull bar, prevents bar from coming right up to the edge of the screen
        sheetController.minimumSpaceAbovePullBar = screenH * 0.8
        
        // Set the pullbar's background explicitly
        sheetController.pullBarBackgroundColor = UIColor.white
        
        // Determine if the rounding should happen on the pullbar or the presented controller only (should only be true when the pull bar's background color is .clear)
        sheetController.treatPullBarAsClear = false
        
        // Disable the dismiss on background tap functionality
        sheetController.dismissOnOverlayTap = true
        
        // Disable the ability to pull down to dismiss the modal
        sheetController.dismissOnPull = true
        
        /// Allow pulling past the maximum height and bounce back. Defaults to true.
        sheetController.allowPullingPastMaxHeight = true
        
        /// Automatically grow/move the sheet to accomidate the keyboard. Defaults to true.
        sheetController.autoAdjustToKeyboard = true
        return sheetController
    }
}

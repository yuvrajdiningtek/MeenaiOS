//
//  SideMenuHandlerVC.swift
//  TiffinApp
//
//  Created by yuvraj kakkar on 03/05/18.
//  Copyright © 2018 YAY. All rights reserved.
//

import UIKit
import SideMenuController

class SideMenuHandlerVC: SideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        performSegue(withIdentifier: "toHome", sender: nil)
        performSegue(withIdentifier: "toSideMenu", sender: nil)
//        performSegue(withIdentifier: "toOrderAhead", sender: nil)

        // Do any additional setup after loading the view.
    }
    required init?(coder aDecoder: NSCoder) {
        
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.interaction.panningEnabled = false
        SideMenuController.preferences.interaction.swipingEnabled = false
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMove(toParent parent: UIViewController?) {
        
    }
    

}

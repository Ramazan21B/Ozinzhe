//
//  TabBarController.swift
//  MyNewProject
//
//  Created by Aitzhan Ramazan on 16.02.2025.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabImages()
        // Do any additional setup after loading the view.
    }
    func setTabImages(){
        let homeselectedimage = UIImage(named: "HomeSelected")!.withRenderingMode(.alwaysOriginal)
        let searchselectedimage = UIImage(named: "SearchSelected")!.withRenderingMode(.alwaysOriginal)
        let favouriteselectedimage = UIImage(named: "FavoriteSelected")!.withRenderingMode(.alwaysOriginal)
        let profileselectedimage = UIImage(named: "ProfileSelected")!.withRenderingMode(.alwaysOriginal)

        tabBar.items?[0].selectedImage = homeselectedimage
        tabBar.items?[1].selectedImage = searchselectedimage
        tabBar.items?[2].selectedImage = favouriteselectedimage
        tabBar.items?[3].selectedImage = profileselectedimage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

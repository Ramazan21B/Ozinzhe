//
//  ProfileViewController.swift
//  MyNewProject
//
//  Created by Aitzhan Ramazan on 05.03.2025.
//

import UIKit
import Localize_Swift
class ProfileViewController: UIViewController, LanguageProtocol {
    
    func languageDidChange() {
        configureViews()
    }
    
    @IBOutlet weak var myProfileLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        configureViews()
    }
    
    func configureViews(){
        myProfileLabel.text = "MY_PROFILE".localized()
        languageButton.setTitle("LANGUAGE".localized(), for: .normal)
        
        if Localize.currentLanguage() == "kk"{
            languageLabel.text = "Қазақша"
        }
        if Localize.currentLanguage() == "en"{
            languageLabel.text = "English"
        }
        if Localize.currentLanguage() == "ru"{
            languageLabel.text = "Русский"
        }
    }
    
    @IBAction func languageShow(_ sender: Any) {
        let languageVC = storyboard?.instantiateViewController(identifier: "LanguageViewController") as! LanguageViewController
        
        languageVC.modalPresentationStyle = .overFullScreen
        
        languageVC.delegate = self
        
        present(languageVC, animated: true, completion: nil)
    }
    
    
    func languageDidChange(_ category: String) {
        configureViews()
    }
    @IBAction func logOutButton(_ sender: Any) {
        let logOut = self.storyboard?.instantiateViewController(withIdentifier: "LogOutViewController") as! LogOutViewController
        logOut.modalPresentationStyle = .overFullScreen
        
        self.present(logOut, animated: true, completion: nil)
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

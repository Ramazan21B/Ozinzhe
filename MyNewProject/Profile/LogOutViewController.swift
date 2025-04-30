//
//  LogOutViewController.swift
//  MyNewProject
//
//  Created by Aitzhan Ramazan on 09.04.2025.
//

import UIKit

class LogOutViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var logOutLabel: UILabel!
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))

        // Do any additional setup after loading the view.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: backgroundView))!{
            return false
        }
        return true
    }
    func configureView(){
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        logOutButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        let rootVC = self.storyboard?.instantiateViewController(identifier: "SignInNavigationController") as! UINavigationController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        appDelegate.window?.makeKeyAndVisible()
    }
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDismiss(sender: UIPanGestureRecognizer){
        switch sender.state {
            case .changed:
                viewTranslation = sender.translation(in: view)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.backgroundView.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
                
            case .ended:
                if viewTranslation.y < 100 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.backgroundView.transform = .identity
                    })
                } else {
                    dismiss(animated: true, completion: nil)
                }
                
            default:
                break
            }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
                                                         
    @IBAction func cancelButton(_ sender: Any) {
        dismissView()
    }
    
                                                         

}

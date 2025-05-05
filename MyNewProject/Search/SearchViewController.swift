//
//  SearchViewController.swift
//  MyNewProject
//
//  Created by Aitzhan Ramazan on 15.04.2025.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchTextField: TextFieldWithPadding!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableViewToCollectionConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewToLabelConstraint: NSLayoutConstraint!
    
    var categories: [Category] = []
    var movies: [Movie] = []
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearButton.isHidden = true
        hideKeyboardWhenTappedAround()
        configureViews()
        downloadCategories()
//        NotificationCenter.default.addObserver(self, selector: #selector(updateTexts), name: NSNotification.Name("LanguageChanged"), object: nil)
        // Do any additional setup after loading the view.
    }
    func refreshUI() {
        // Call the same code from `configureViews()` to refresh the UI text after language change
        configureViews()
        
        // If needed, trigger reloading of other data-dependent UI components (like tables, collection views, etc.)
        collectionView.reloadData()
        tableView.reloadData()
    }

    func configureViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //topLabel.text = "TOP_LABEL".localized()
        searchTextField.placeholder = "SEARCH_TEXT_FIELD".localized()
        //navigationItem.title = "SEARCH_TITLE".localized()
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 24.0, bottom: 16.0, right: 24.0)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 100
        collectionView.collectionViewLayout = layout
        
        
        //searchTextField
        searchTextField.padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        searchTextField.layer.cornerRadius = 12
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        //tableview
        tableView.delegate = self
        tableView.dataSource = self
        let MovieCellnib = UINib(nibName: "MovieCell", bundle: nil)
        tableView.register(MovieCellnib, forCellReuseIdentifier: "MovieCell")
        
    }
    @IBAction func TextFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func TextFieldEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    @IBAction func textFieldDidChange(_ sender: Any) {
        downloadSearchMovies()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let categoryTableViewController = storyboard?.instantiateViewController(identifier: "CategoryTableViewController") as! CategoryTableViewController
        categoryTableViewController.categoryID = categories[indexPath.row].id
        categoryTableViewController.categoryName = categories[indexPath.row].name
        navigationController?.show(categoryTableViewController, sender: self)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = categories[indexPath.row].name
        
        let backgroundview = cell.viewWithTag(1000)
        backgroundview!.layer.cornerRadius = 8
        
        return cell
    }
    
    func hideKeyboardWhenTappedAround(){
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
   
    @IBAction func clearButton(_ sender: Any) {
        searchTextField.text = ""
        downloadSearchMovies()
    }
    @IBAction func searchButton(_ sender: Any) {
        downloadSearchMovies()
    }
    
    func downloadSearchMovies(){
        if searchTextField.text!.isEmpty {
            topLabel.text = "Cанаттар"
            collectionView.isHidden = false
            tableViewToLabelConstraint.priority = .defaultLow
            tableViewToCollectionConstraint.priority = .defaultHigh
            tableView.isHidden = true
            movies.removeAll()
            tableView.reloadData()
            clearButton.isHidden = true
            return
        } else {
            topLabel.text = "Іздеу нәтижелері"
            collectionView.isHidden = true
            tableViewToLabelConstraint.priority = .defaultHigh
            tableViewToCollectionConstraint.priority = .defaultLow
            tableView.isHidden = false
            clearButton.isHidden = false
        }
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        
        let parametrs = ["search": searchTextField.text!]
        AF.request(Urls.SEARCH_MOVIES_URL, method: .get, parameters: parametrs, headers: headers).responseData {
            response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    self.movies.removeAll()
                    self.tableView.reloadData()
                    for item in array {
                        let movie = Movie(json: item)
                        self.movies.append(movie)
                    }
                    self.tableView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    func downloadCategories(){
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        
        AF.request(Urls.CATEGORIES_URL, method: .get, headers: headers).responseData {
            response in
            
            SVProgressHUD.dismiss()
            
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    for item in array {
                        let category = Category(json: item)
                        self.categories.append(category)
                    }
                    self.collectionView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + "\(sCode)"
                }
                ErrorString = ErrorString + "\(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell

        // Configure the cell...
        cell.setData(movie: movies[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        153.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieInfoVC = self.storyboard?.instantiateViewController(identifier: "MovieInfoViewController") as! MovieInfoViewController
        
        movieInfoVC.movie = movies[indexPath.row]
        
        navigationController?.show(movieInfoVC, sender: self)
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

//
//  SelectCourseViewController.swift
//  wasocial
//
//  Created by 陆倚颖 on 4/15/17.
//  Copyright © 2017 陈逸山. All rights reserved.
//

import UIKit

class SelectCourseViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    
    @IBOutlet weak var displayTableView: UITableView!
    @IBOutlet weak var selectedTableView: UITableView!
    var displayList: [String]=[]
    @IBOutlet weak var addCourseText: UITextField!
    
    @IBAction func addCourses(_ sender: UIButton) {
        var courseList = UserDefaults.standard.stringArray(forKey: "courseList")
        //        print("favorites: \(favorites)")
        let defaults = UserDefaults.standard
        if courseList == nil{
            var string: [String] = []
            string.append(addCourseText.text!)
            defaults.set(string, forKey: "courseList")
        }
        else{
            courseList?.append(addCourseText.text!)
            print("courseList: ", courseList)
            defaults.set(courseList, forKey: "courseList")
            
        }
        
        fetchDataForTableView()
        self.displayTableView.reloadData()

    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActivated: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedTableView.dataSource = self
        selectedTableView.delegate = self
        displayTableView.dataSource = self
        displayTableView.delegate = self
        fetchDataForTableView()
        self.displayTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchDataForTableView() {
        displayList.removeAll()
        let searchContent = searchBar.text!
        if let courseList = UserDefaults.standard.stringArray(forKey: "courseList") {
            for course in courseList{
                displayList.append(course)
            }
        }
        if(!searchContent.isEmpty){
            var searchList: [String]=[]
            for course in displayList{
                if (course.lowercased() == searchContent.lowercased()){
                    searchList.append(course)
                }
            }
            displayList = searchList
        }
       
        
        
    }

    //search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActivated = true
        
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActivated = true
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActivated = false
       
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActivated = true
        
        let searchContent = searchBar.text!
        if (!searchContent.isEmpty && searchActivated == true){
            DispatchQueue.global(qos: .userInitiated).async {
                self.displayList.removeAll()
                self.fetchDataForTableView()
                DispatchQueue.main.async {
//                    self.selectedTableView.reloadData()
                    self.displayTableView.reloadData()
                }
            }
            
            
        }
        
    }

    
    // set up displayTableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell =  UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if(tableView == self.displayTableView){
        cell.textLabel!.text = displayList[indexPath.row]
        if let comment = UserDefaults.standard.string(forKey: displayList[indexPath.row]){
            cell.detailTextLabel!.text = comment
        }
        }
        
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.displayTableView){
            return displayList.count
        }
        else{
            return 1
        }
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

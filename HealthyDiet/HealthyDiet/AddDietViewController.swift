//
//  AddDietViewController.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/11.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import UIKit
import SWXMLHash
import Alamofire
import PKHUD

class AddDietViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, NSXMLParserDelegate {
    
    // 提供常用的名字，点击搜索后发送请求
    
    var dietList = ["Apple", "Apricot", "Banana", "Blueberry", "Cantaloupe", "Cherry","Clementine", "Coconut", "Cranberry", "Fig", "Grape", "Grapefruit","Kiwi fruit", "Lemon", "Lime", "Lychee", "Mandarine", "Mango","Melon", "Nectarine", "Olive", "Orange", "Papaya", "Peach","Pear", "Pineapple", "Raspberry", "Strawberry","asparagus","apples","avacado","alfalfa","acorn squash","almond","arugala","artichoke","applesauce","asian noodles","antelope","ahi tuna","albacore tuna","juice","Avocado roll","Bruscetta","bacon","black beans","bagels","baked beans","BBQ","bison","barley","beer","bisque","bluefish","bread","broccoli","buritto","babaganoosh","Cabbage","cake","carrots","carne asada","celery","cheese","chicken","catfish","chips","chocolate","chowder","clams","coffee","cookies","corn","cupcakes","crab","curry","cereal","chimichanga","dates","dips","duck","dumplings","donuts","eggs","enchilada","eggrolls","English muffins","edimame","sushi","fajita","falafel","fish","franks","fondu","French toast","French dip","Garlic","ginger","gnocchi","goose","granola","grapes","green beans","Guancamole","gumbo","grits","Graham crackers","ham","halibut","hamburger","honey","huenos rancheros","hash browns","hot dogs","haiku roll","hummus","ice cream","Irish stew","Indian food","Italian bread","jambalaya","jelly","jam","jerky","jalapeño","kale","kabobs","ketchup","kiwi","kidney beans","kingfish","lobster","Lamb","Linguine","Lasagna","Meatballs","Moose","Milk","Milkshake","Noodles","Ostrich","Pizza","Pepperoni","Porter","Pancakes","Quesadilla","Quiche","Reuben","Spinach","Spaghetti","Tater tots","Toast","Venison","Waffles","Wine","Walnuts","Yogurt","Ziti","Zucchini"]
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredDiets = [String]()
    var searched : Bool = false  // 有没有点击search按钮
    var diets = [Diet?]()
    let dataModel = DataController()
    
    // MARK: - life circle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setSearchController()
        if self.navigationController != nil {
            self.title = "Add Diet"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        // 直接显示键盘
        
        searchController.searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - tableview data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AddDietTableViewCell", forIndexPath: indexPath)
        
        // 搜索本地index
        if (!searched){
            let diet:String
            if searchController.active && searchController.searchBar.text != "" {
                diet = filteredDiets[indexPath.row]
            } else {
                diet = dietList[indexPath.row]
            }
            cell.textLabel?.text = diet
        } else {
            // 如果点击了searched，则加载搜索过的内容
            cell.textLabel?.text = diets[indexPath.row]?.name
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!searched) {
            if searchController.active && searchController.searchBar.text != "" {
                return filteredDiets.count
            }
            return dietList.count
        }
        
        return diets.count
    }
    
    // MARK: - tableview delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (!searched) {
            // 通过预加载的内容去搜索想要的内容
            print("hasn't selected search button")
            searchDiets(tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text, quantity: 25)
            return
        } else {
            // 将获取到的diet传给主页面并dismiss本页面
            if self.navigationController != nil {
                if let parent = self.backViewController() as? DietTableViewController{
//                    parent.diets.append(diets[indexPath.row]!)
                    // TODO: get image from supermarket API
                    do {
                        try self.dataModel.storeDiets(diets[indexPath.row]!)
                    } catch {
                        print("\(error)")
                    }
                    self.navigationController?.popViewControllerAnimated(true)
                    return
                }
            }
        }
        HUD.show(.Error)
        HUD.hide(afterDelay: 2.0)
    }
    
    // MARK: - search results updating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // MARK: - search bar delegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        if self.navigationController != nil {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchController.searchBar.text != nil {
            self.searchDiets(nil,quantity: 25)
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searched = false
        tableView.reloadData()
    }
    
    // MARK: - helper
    
    func setSearchController() {
        // set search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
    }
    
    func searchDiets(searchText: String?, quantity: Int) {
        searched = true
        if let searchBarText = searchController.searchBar.text  {
            HUD.show(.Progress)
            // TODO: 往下拉继续加载
            var parameters : [String:String] = [
                "api_key":API_KEY.NNDB.key(),
                "q":searchBarText,
                "max":"\(quantity)",
                "format":"XML"
            ]
            if (searchText != nil) {
                parameters["q"] = searchText
            }
            Alamofire.request(.GET, URL.SearchDiet.url(), parameters: parameters)
                .responseString { response in
                    if let responseString = response.result.value {
                        let xml = SWXMLHash.parse(responseString)
                        self.diets.removeAll()
                        for element in xml["list"]["item"] {
                            self.diets.append(Diet(name: element["name"].element!.text!, id: element["ndbno"].element!.text!, category: element["group"].element!.text!, searchText: parameters["q"]!))
                        }
                        self.tableView.reloadData()
                        HUD.flash(.Success)
                    } else {
                        HUD.show(.Error)
                        HUD.hide(afterDelay: 2.0)
                    }
            }
        }

    }
    
    func filterContentForSearchText(searchText: String) {
        filteredDiets = dietList.filter { diet in
            return diet.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
}

extension UIViewController {
    
    func backViewController() -> UIViewController? {
        if let stack = self.navigationController?.viewControllers {
            for(var i=stack.count-1;i>0;--i) {
                if(stack[i] == self) {
                    return stack[i-1]
                }
            }
        }
        return nil
    }
}

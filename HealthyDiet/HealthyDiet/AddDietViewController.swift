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

class AddDietViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, NSXMLParserDelegate {
    
    // 提供常用的名字，点击搜索后发送请求
    
    var dietList = ["Apple", "Apricot", "Banana", "Blueberry", "Cantaloupe", "Cherry","Clementine", "Coconut", "Cranberry", "Fig", "Grape", "Grapefruit","Kiwi fruit", "Lemon", "Lime", "Lychee", "Mandarine", "Mango","Melon", "Nectarine", "Olive", "Orange", "Papaya", "Peach","Pear", "Pineapple", "Raspberry", "Strawberry","asparagus","apples","avacado","alfalfa","acorn squash","almond","arugala","artichoke","applesauce","asian noodles","antelope","ahi tuna","albacore tuna","juice","Avocado roll","Bruscetta","bacon","black beans","bagels","baked beans","BBQ","bison","barley","beer","bisque","bluefish","bread","broccoli","buritto","babaganoosh","Cabbage","cake","carrots","carne asada","celery","cheese","chicken","catfish","chips","chocolate","chowder","clams","coffee","cookies","corn","cupcakes","crab","curry","cereal","chimichanga","dates","dips","duck","dumplings","donuts","eggs","enchilada","eggrolls","English muffins","edimame","sushi","fajita","falafel","fish","franks","fondu","French toast","French dip","Garlic","ginger","gnocchi","goose","granola","grapes","green beans","Guancamole","gumbo","grits","Graham crackers","ham","halibut","hamburger","honey","huenos rancheros","hash browns","hot dogs","haiku roll","hummus","ice cream","Irish stew","Indian food","Italian bread","jambalaya","jelly","jam","jerky","jalapeño","kale","kabobs","ketchup","kiwi","kidney beans","kingfish","lobster","Lamb","Linguine","Lasagna","Meatballs","Moose","Milk","Milkshake","Noodles","Ostrich","Pizza","Pepperoni","Porter","Pancakes","Quesadilla","Quiche","Reuben","Spinach","Spaghetti","Tater tots","Toast","Venison","Waffles","Wine","Walnuts","Yogurt","Ziti","Zucchini"]
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredDiets = [String]()
    var searched : Bool = false  // 有没有点击search按钮
    var parser: NSXMLParser?
    var directoryValid = false
    var url: NSURL?
    var diets = [Diet?]()
    
    // MARK: - life circle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // set search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
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
            // TODO: 通过预加载的内容去搜索想要的内容
            print("hasn't selected search button")
        } else {
            // TODO: 将获取到的diet传给主页面并dismiss本页面
        }
    }
    
    // MARK: - search results updating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    // MARK: - search bar delegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // text did change
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searched = true
        
//        if let searchText = searchController.searchBar.text {
//            // create parser
//            url = NSURL(string: "http://api.nal.usda.gov/ndb/search/?format=xml&q="+searchText+"&max=25&offset=0&api_key=5OMJXRPPVdX7LrXDQucMslEiYy9hVy4X0fsKE7v8")
//            parser = NSXMLParser(contentsOfURL: url!)
//            parser?.delegate = self
//            parser?.parse()
//        }
        refreshControl?.beginRefreshing()
        self.searchDiets(self.searchController.searchBar.text, quantity: 100)
        
    }
    
    // MARK: - xml parser delegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if (elementName == "food") {
            directoryValid = true
            // get values
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // no
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        print(data)
    }
    
    func parser(parser: NSXMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
        if (directoryValid) {
            print("\(attributeName)")
        }
    }
    
    // MARK: - helper
    
    func searchDiets(searchText: String?, quantity: Int) {
        
        if searchText != nil {
            let parameters : [String:String] = [
                "api_key":API_KEY,
                "q":searchText!,
                "max":"\(quantity)",
                "format":"XML"
            ]
            
            Alamofire.request(.GET, URL.SearchDiet.url(), parameters: parameters)
                .responseString { response in
                    if let responseString = response.result.value {
                        let xml = SWXMLHash.parse(responseString)
                        for element in xml["list"]["item"] {
                            self.diets.append(Diet(name: element["name"].element!.text!, id: element["ndbno"].element!.text!, category: element["group"].element!.text!, measure: "", weight: ""))
                        }
                        self.tableView.reloadData()
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
    
    // TODO: refresh
    
    func refresh(){
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
//        refresh(refreshControl)
    }
}

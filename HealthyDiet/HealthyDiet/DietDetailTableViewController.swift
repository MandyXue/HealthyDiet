//
//  DietDetailTableViewController.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/13.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import UIKit

class DietDetailTableViewController: UITableViewController, NSXMLParserDelegate {
    
    let header = ["Food Information", "Nutrients", "Recipes"]
    var parser: NSXMLParser?
    var directoryValid = false
    var url: NSURL?
    var diet: Diet?
    var attributeKey = ["name","weight","measure"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create parser
        url = NSURL(string: "http://api.nal.usda.gov/ndb/nutrients/?ndbno=01009&format=xml&api_key=DEMO_KEY&nutrients=205&nutrients=204&nutrients=401")
        parser = NSXMLParser(contentsOfURL: url!)
        parser?.delegate = self
        parser?.parse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath) as! RecipeTableViewCell
            cell.recipeImage.image = UIImage(named: "defaultImage")
            cell.recipeName.text = "recipe name testing bla bla bla"
            cell.caloriesDetail.text = "1480"
            cell.dailyValue.text = "74%"
            return cell
        } else if(indexPath.section == 0) {
            print("section:\(indexPath.section), row:\(indexPath.row)")
            let cell = tableView.dequeueReusableCellWithIdentifier("attributeCell", forIndexPath: indexPath) as! DietAttributeTableViewCell
            cell.attributeName.text = attributeKey[indexPath.row]
            cell.attributeDetail.text = diet?.information[attributeKey[indexPath.row]]
            return cell
        } else if(indexPath.section == 1) {
            print("section:\(indexPath.section), row:\(indexPath.row)")
            let cell = tableView.dequeueReusableCellWithIdentifier("attributeCell", forIndexPath: indexPath) as! DietAttributeTableViewCell
            cell.attributeName.text = "attribute name"
            cell.attributeDetail.text = "detail"
            return cell
        }
        
        let cell = UITableViewCell()
        // Configure the cell...
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    // MARK: - tableview delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 2) {
            return 112.0
        } else {
            return 45.0
        }
    }
    
    // MARK: - xml parser delegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if (elementName == "food") {
            directoryValid = true
            // get values
            if let id = attributeDict["ndbno"] {
                if let name = attributeDict["name"] {
                    if let weight = attributeDict["weight"] {
                        if let measure = attributeDict["measure"] {
                            // create diet
                            diet = Diet(name: name, id: id, category: "", measure: measure, weight: weight)
                        }
                    }
                }
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // no
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        var data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        print(data)
    }
    
    func parser(parser: NSXMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
        if (directoryValid) {
            print("\(attributeName)")
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

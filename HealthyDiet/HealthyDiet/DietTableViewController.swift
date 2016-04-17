//
//  DietTableViewController.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/11.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class DietTableViewController: UITableViewController {
    
    var diets = [DietModel]()
    let dataModel = DataController()
    var page = 0
    let size = 30
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.dataModel.getDietsFromCoreData(self.page, size: self.size, resultHandler: { (dietList) -> Void in
            if let resultList = dietList {
                self.diets = resultList
                for diet in self.diets {
                    DietHelper.getImageForDiet(diet.searchText!) { (imageURL) -> Void in
                        diet.image = imageURL
                    }
                }
                self.tableView.reloadData()
                print("reload success")
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return diets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DietTableViewCell", forIndexPath: indexPath) as! DietTableViewCell
        cell.itemCategory.text = diets[indexPath.row].category
        cell.itemName.text = diets[indexPath.row].name
        
        // get image from url
        if let image = diets[indexPath.row].image {
            let downloader = SDWebImageDownloader.sharedDownloader()
            downloader.downloadImageWithURL(NSURL(string: image), options: .ProgressiveDownload, progress: { (receivedSize, expectedSize) -> Void in
                //                            print("progress tracking \(receivedSize) \(expectedSize)")
                }, completed: { (image, data, error, finished) -> Void in
                    if finished {
                        cell.itemImage.image = image
                    }
            })
        }
        
        return cell
    }
    
    // TODO: delete tableview cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DietDetailSegue" {
            if let detailViewController = segue.destinationViewController as? DietDetailTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let diet = diets[indexPath.row]
                    detailViewController.diet = diet
                }
            }
        }
    }

}

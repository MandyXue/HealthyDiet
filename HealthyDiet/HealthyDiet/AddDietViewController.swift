//
//  AddDietViewController.swift
//  HealthyDiet
//
//  Created by MandyXue on 16/4/11.
//  Copyright © 2016年 MandyXue. All rights reserved.
//

import UIKit

class AddDietViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        <#code#>
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // text did change
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

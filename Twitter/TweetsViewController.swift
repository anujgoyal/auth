//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Anuj Goyal on 10/10/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navBar: UINavigationBar!
    var refreshControl:UIRefreshControl!
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    func onLogout() {
        User.currentUser?.logout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        // setup tableview delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self

        // set navbar
        //navBar.frame = CGRectMake(0, 0, 320, 50)
        //navBar.backgroundColor = (UIColor.grayColor())
        //self.view.addSubview(navBar)

        // setup logout button
        self.navBar?.topItem?.title   = "Timeline"
        self.navBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
        
        var b = UIBarButtonItem(title: "Logout",
            style: UIBarButtonItemStyle.Bordered,
            target: self,
            action: Selector("onLogout"))
        
        self.navBar?.topItem?.rightBarButtonItem = b

        //self.navigationItem.rightBarButtonItem = b
        //self.navigationItem.title = "Timeline"
        
        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.blueColor()
        refreshControl.tintColor = UIColor.whiteColor()
        //http://stackoverflow.com/questions/25823063/change-pull-to-refresh-text-color-with-swift
        var attr = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh", attributes: attr)
        refreshControl.addTarget(self, action: "getData", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        getData()
        //NSLog("viewWillAppear: end")
    }
    
    func getData() {
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil,
            completion: {(tweets, error) -> () in
                NSLog("completion returned")
                self.tweets = tweets
                self.tableView.reloadData() // have to do this in the completion method
                self.refreshControl.endRefreshing()
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    // number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //NSLog("numberOfRowsInSection: begin")
        if let t = tweets {
            //NSLog("t.count \(t.count)")
            return t.count   // tweets!.count
        } else {
            //NSLog("no tweets!")
            return 0
        }
    }
    
    // fill in table cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell

        if let t = tweets?[indexPath.row] {
            cell.populate(t)
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

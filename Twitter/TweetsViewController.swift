//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Anuj Goyal on 10/10/14.
//  Copyright (c) 2014 TXT2LRN. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        // setup tableview delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self

        // setup logout button
        var b = UIBarButtonItem(title: "Filters",
            style: UIBarButtonItemStyle.Bordered,
            target: self,
            action: Selector("onLogout"))
        self.navigationItem.rightBarButtonItem = b
        self.navigationItem.title = "Timeline"
        
        getData()
        NSLog("viewWillAppear: end")
    }
    
    func getData() {
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil,
            completion: {(tweets, error) -> () in
                NSLog("completion returned")
                self.tweets = tweets
                
                for t in self.tweets! {
                    NSLog("in for loop")
                    //println("tweet user: \(t.user?.screenName!)")
                    //println("tweet text: \(t.text!)")
                }
                self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NSLog("viewDidLoad: end")
    }

    // number of rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("numberOfRowsInSection: begin")
        
        if let t = tweets {
            NSLog("t.count \(t.count)")
            return t.count   // tweets!.count
        } else {
            NSLog("no tweets!")
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

//
//  MasterViewController.swift
//  NairaLand-amina
//
//  Created by Haminata Camara on 04/01/2016.
//  Copyright © 2016 Haminata Camara. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = Array<Array<String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        getPosts()
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("showing details...")
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TABLE COUNT \(objects.count)")
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        //let object = objects[indexPath.row] as! NSDate
        print("added \(objects[indexPath.row][1])")
        cell.textLabel!.text = "\(objects[indexPath.row][1])"
        
        return cell
    }
    
    func getPosts(){
        let url = NSURL(string: "http://www.nairaland.com/links")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            let page: NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let lines = page.componentsSeparatedByString("<table summary=\"links\">")[1].componentsSeparatedByString("<br>")
            //var regex = "href=\"(?P<link>.*)\">\\s*<b>(?P<title>.*)</b>\\s*</a>\\s*at\\s*<b>(?P<time>[^<]+)</b>(\\s*On\\s*<b>(?P<date>.*)</b>)?"
            let regex = "href=\"(.*)\">\\s*<b>(.*)</b>\\s*</a>\\s*at\\s*<b>([^<]+)</b>(\\s*On\\s*<b>(.*)</b>)?$"
            //var regex = /hello/
            for text in lines{
                
                
                do {
                    let regex = try NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions.CaseInsensitive)
                    
                    let nsString = text as NSString
                    let results = regex.matchesInString(text,
                        options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, nsString.length))
                    
                    var matches : Array<String> = Array<String>()
                    
                    for (_, element) in results.enumerate(){
                        //var res: NSTextCheckingResult = r.element
                        for ii in 1..<4{
                            
                            print("doing range \(ii) \(element.rangeAtIndex(ii))")
                            
                            matches.append(nsString.substringWithRange(element.rangeAtIndex(ii)))
                        }
                    }
                    
                    if !matches.isEmpty{
                        print("adding matches \(matches)")
                        self.objects.append(matches)
                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        
                        
                    }
                } catch let error as NSError{
                    print("Invalid Selection. \(error)")
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}


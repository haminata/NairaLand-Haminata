//
//  DetailViewController.swift
//  NairaLand-amina
//
//  Created by Haminata Camara on 04/01/2016.
//  Copyright © 2016 Haminata Camara. All rights reserved.
//

import UIKit
import WebKit
import iAd

class DetailViewController: UIViewController {

    //@IBOutlet weak var detailWebView: UIWebView!
    private var detailWebView: WKWebView?
    @IBOutlet var adBannerView: ADBannerView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            let detailArray = detail as! Array<String>
            print("loading \(detailArray[0])")
            //let url: NSURL =
            //if let url = NSURL(string: "http://google.com") {
            if let url = NSURL(string: detailArray[0]) {
                print("Creating request \(detailArray[0])")
                let req = NSURLRequest(URL: url)
                detailWebView?.loadRequest(req)
            }
        }
    }

    
    
    override func loadView() {
        detailWebView = WKWebView()
        
        //If you want to implement the delegate
        //webView?.navigationDelegate = self
        
        view = detailWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

}


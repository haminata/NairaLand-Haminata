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

class DetailViewController: UIViewController, ADBannerViewDelegate, WKNavigationDelegate {

    //@IBOutlet weak var detailWebView: UIWebView!
    private var detailWebView: WKWebView!
    private var adBannerView: ADBannerView!
    private var request: NSURLRequest!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            print("configuring view")
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            let detailArray = detail as! Array<String>
            print("loading \(detailArray[0])")
            if let url = NSURL(string: detailArray[0]) {
                print("Creating request \(detailArray[0])")
                request = NSURLRequest(URL: url)
                print("got results...\(detailWebView)")
                if detailWebView != nil {
                    detailWebView?.loadRequest(request)
                }else{
                    print("webview not ready")
                }
                
                view.setNeedsDisplay()
            }
        }
    }

    override func viewDidLoad() {
        print("loading view")
        super.viewDidLoad()
        
        if detailWebView == nil {
            detailWebView = WKWebView()
            detailWebView.navigationDelegate = self
        }else{
            print("webview exists")
        }
        
        
        
        //view = detailWebView
        view.addSubview(detailWebView!)
        configureView()
        
        adBannerView = ADBannerView()
        adBannerView.delegate = self
        adBannerView.hidden = true
        
        self.canDisplayBannerAds = true
        if request != nil {
            print("setting request")
            detailWebView?.loadRequest(request)
        }
        detailWebView.frame = view.frame
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print("showing ad \(view.subviews)")
        adBannerView.hidden = false
        
        view.addSubview(adBannerView!)
        view.setNeedsDisplay()
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

}


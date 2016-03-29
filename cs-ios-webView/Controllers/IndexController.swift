
import UIKit
import WebKit

class IndexController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView?
    
    /* Start the network activity indicator when the web view is loading */
    func webView(webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation){
            print("Loading START")
    }
    
    /* Stop the network activity indicator when the loading finishes */
    func webView(webView: WKWebView,
        didFinishNavigation navigation: WKNavigation){
            print("Loading DONE")
            webView.evaluateJavaScript("console.log('Loading DONE')", completionHandler: nil)
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("error occurs during a committed mainframe navigation")
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("error occurs while starting to load data for the mainframe")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let website = "http://localhost:8000"
        layoutWebBrowsingElements()
        loadURLRequest(website)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadURLRequest(address: String) {
        
        let siteURL = NSURL(string: address)
        let request = NSURLRequest(URL: siteURL!)
        webView?.navigationDelegate = self
        webView?.loadRequest(request)
        
    }
    
    func layoutWebBrowsingElements() {
        
        let wkWebView = WKWebView(frame: view.bounds)
        webView = wkWebView
        
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(wkWebView)
        
        let webTopSpaceToContainer = NSLayoutConstraint(item: self.view, attribute: .TopMargin, relatedBy: .Equal, toItem: webView, attribute: .Top, multiplier: 1, constant: -20)
        let webBottomSpaceToContainer = NSLayoutConstraint(item: self.view, attribute: .BottomMargin, relatedBy: .Equal, toItem: webView, attribute: .Bottom, multiplier: 1, constant: 0)
        let webLeadingSpaceToContainer = NSLayoutConstraint(item: self.view, attribute: .LeadingMargin, relatedBy: .Equal, toItem: webView, attribute: .Leading, multiplier: 1, constant: 20)
        
        let webTrailingSpaceToContainer = NSLayoutConstraint(item: self.view, attribute: .TrailingMargin, relatedBy: .Equal, toItem: webView, attribute: .Trailing, multiplier: 1, constant: -20)
        
        let webViewConstaints = [webTopSpaceToContainer,webBottomSpaceToContainer,webLeadingSpaceToContainer,webTrailingSpaceToContainer]
        
        self.view.addConstraints(webViewConstaints)
        
    }
    
    
}

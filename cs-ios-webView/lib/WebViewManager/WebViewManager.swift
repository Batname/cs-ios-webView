
import UIKit
import WebKit

class WebViewManager {
    
    var webView: WKWebView
    var view: UIView
    
    init (webView: WKWebView, view: UIView) {
        self.webView = webView
        self.view = view
    }

    func loadURLRequest(address: String) {
        let siteURL = NSURL(string: address)
        let request = NSURLRequest(URL: siteURL!)
        webView.loadRequest(request)
    }
    
    func layoutWebBrowsingElements() {
        
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.webView)
        
        let webTopSpaceToContainer = NSLayoutConstraint(item: self.view, attribute: .TopMargin, relatedBy: .Equal, toItem: webView, attribute: .Top, multiplier: 1, constant: -20)
        let webBottomSpaceToContainer = NSLayoutConstraint(item: self.view, attribute: .BottomMargin, relatedBy: .Equal, toItem: webView, attribute: .Bottom, multiplier: 1, constant: 0)
        let webLeadingSpaceToContainer = NSLayoutConstraint(item: self.view, attribute: .LeadingMargin, relatedBy: .Equal, toItem: webView, attribute: .Leading, multiplier: 1, constant: 20)
        
        let webTrailingSpaceToContainer = NSLayoutConstraint(item: self.view, attribute: .TrailingMargin, relatedBy: .Equal, toItem: webView, attribute: .Trailing, multiplier: 1, constant: -20)
        
        let webViewConstaints = [webTopSpaceToContainer,webBottomSpaceToContainer,webLeadingSpaceToContainer,webTrailingSpaceToContainer]
        
        self.view.addConstraints(webViewConstaints)
    }
}
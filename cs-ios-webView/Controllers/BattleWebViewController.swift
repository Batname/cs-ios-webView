
import UIKit
import WebKit

class BattleWebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView
    let website = "http://localhost:8000"
    let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1"
    var isWebViewLoaded: Bool = false
    
    @IBOutlet weak var progressView: UIProgressView!
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        if let url = navigationAction.request.URL where String(url.absoluteURL) == "native://close" {

            let IndexNativeController = (self.storyboard?.instantiateViewControllerWithIdentifier("IndexNativeController"))! as UIViewController
            
            let window = UIApplication.sharedApplication().windows[0] as UIWindow
            UIView.transitionFromView(
                window.rootViewController!.view,
                toView: IndexNativeController.view,
                duration: 0.65,
                options: .TransitionCrossDissolve,
                completion: {
                    finished in window.rootViewController = IndexNativeController
            })
            
            print("Move to some part of app native://close")
            decisionHandler(.Cancel)
        }

        decisionHandler(.Allow)
    }
    
    func webView(webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation){
            print("Loading START")
    }
    
    func webView(webView: WKWebView,
        didFinishNavigation navigation: WKNavigation){
            print("Loading DONE")
            self.progressView.setProgress(0.0, animated: false)
            if (!self.isWebViewLoaded) {
                self.layoutWebBrowsingElements()
                self.isWebViewLoaded = true
            }
            webView.evaluateJavaScript("console.log('Loading DONE')", completionHandler: nil)
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("error occurs during a committed mainframe navigation")
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("error occurs while starting to load data for the mainframe")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.customUserAgent = self.userAgent
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        self.webView.navigationDelegate = self
        self.loadURLRequest(self.website)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress") {
            self.progressView.hidden = self.webView.estimatedProgress == 1
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        }
    }
    
    func loadURLRequest(address: String) {
        let siteURL = NSURL(string: address)
        let request = NSURLRequest(URL: siteURL!)
        self.webView.loadRequest(request)
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

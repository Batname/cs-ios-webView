
import UIKit
import WebKit

class IndexWebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView
    var webViewManager: WebViewManager?
    let website = "http://localhost:8000"
    let userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1"
    var isWebViewLoaded: Bool = false
    var auth = TouchAuthentication(AppName: "CasinoHeroes")
    let resourceFileManager = ResourceFileManager()
    var injectorJsFile: String?
    
    @IBOutlet weak var progressView: UIProgressView!
    
    required init?(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webViewManager = WebViewManager(webView: webView, view: view)
        webView.customUserAgent = userAgent
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.navigationDelegate = self
        webViewManager?.loadURLRequest(website)
        auth.alertCallbacks["showAlertWithTitle"] = showAlertWithTitle
        auth.webView = self.webView
        injectorJsFile = self.resourceFileManager.getAsString("injector", encoding: "js")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress") {
            progressView.hidden = self.webView.estimatedProgress == 1
            progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        }
    }
    
    func showAlertWithTitle (message: String) -> Void {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}


import UIKit
import WebKit

class IndexWebViewController: UIViewController, WKNavigationDelegate {
    
    let dictionaryKey: (String) -> AnyObject? = NSBundle.mainBundle().objectForInfoDictionaryKey
    let webView: WKWebView
    let auth: TouchAuthentication
    let website: String
    let userAgent: String
    
    var webViewService: WebViewService?
    var isWebViewLoaded: Bool = false
    var injectorJsFile: String?
    
    @IBOutlet weak var progressView: UIProgressView!
    
    required init?(coder aDecoder: NSCoder) {
        self.website = dictionaryKey("website") as! String
        self.userAgent = dictionaryKey("userAgent") as! String
        self.auth = TouchAuthentication(AppName: dictionaryKey("AppName") as! String)
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewService = WebViewService(webView: webView, view: view)
        webView.customUserAgent = userAgent
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.navigationDelegate = self
        webViewService?.loadURLRequest(website)

        auth.alertCallbacks["showAlertWithTitle"] = showAlertWithTitle
        auth.webView = self.webView

        injectorJsFile = ResourceFileService.getAsString("injector", encoding: "js")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress") {
            progressView.hidden = self.webView.estimatedProgress == 1
            progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

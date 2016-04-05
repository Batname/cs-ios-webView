import WebKit

extension IndexWebViewController {

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
                self.webViewManager?.layoutWebBrowsingElements()
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
}

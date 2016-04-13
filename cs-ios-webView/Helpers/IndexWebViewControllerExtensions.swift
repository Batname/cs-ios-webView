import WebKit

extension IndexWebViewController {
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.Allow)
    }

    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.URL where String(url.scheme) == "native" {
            
            
            switch url.host {
                case "authorized"? :
                    if let (login, password) = unwrap(url.queryDictionary?["login"]?.first, url.queryDictionary?["password"]?.first)
                    {
                       self.auth.saveAuthData(login: login, password: password)
                    }
                case "reauthenticated"? :
                    print("reauthenticated")
                case "notauthorized"? :
                    self.auth.addAuthLink()
                    print("notauthorized")
                default: break
            }

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

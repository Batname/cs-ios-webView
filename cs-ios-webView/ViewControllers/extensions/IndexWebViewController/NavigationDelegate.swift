import WebKit

extension IndexWebViewController {

    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.URL where String(url.scheme) == "native" {
            decisionHandler(.Cancel)
            
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
                case "touchIdAuth"? :
                    self.auth.checkFingerPrint();
                    print("checkFingerPrint")
                case "logout"? :
                    self.auth.addAuthLink()
                    print("logout")
                default: break
            }

        }
        
        decisionHandler(.Allow)
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        webView.evaluateJavaScript("window.embeddedNative = true;", completionHandler: nil)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation){
        self.progressView.setProgress(0.0, animated: false)
        if (!self.isWebViewLoaded) {
            self.webViewService?.layoutWebBrowsingElements()
            self.isWebViewLoaded = true
        }
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation){
        print("didStartProvisionalNavigation")
    }

    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        print("didFailNavigation")
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print("didFailProvisionalNavigation")
    }
}

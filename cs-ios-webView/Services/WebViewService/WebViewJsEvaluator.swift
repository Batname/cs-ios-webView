
class WebViewJsEvaluator {
    
    static func errorHandler (result: AnyObject?, error: NSError?) {
        if error != nil { print("error during js evaluation", result, error?.description) }
    }
}
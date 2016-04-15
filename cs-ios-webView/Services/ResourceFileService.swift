
struct ResourceFileService {
    func getAsString (fileName: String, encoding: String) -> String? {
        if let filepath = NSBundle.mainBundle().pathForResource(fileName, ofType: encoding) {
            do {
                let contents = try NSString(contentsOfFile: filepath, usedEncoding: nil) as String
                return contents
            } catch let error as NSError {
                print(error.code)
                return nil
            }
        } else {
            return  nil
        }
    }
}

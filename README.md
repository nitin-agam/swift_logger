# Logging in Swift

In this example, you can find how to print all the logs effciently in iOS application. Along with, you will find how to share logs for debuging purpose.

By share logs, you can ask to your app user to share logs as a file so that you can debug any issue.

### Example: How to print logs

You can print logs for different categories like error, info, warning, debug, verbose. 

```
Log.p(#function, type: .info)
Log.p("this is log to test log level: error", type: .error)
Log.p("this is log to test log level: warn", type: .warn)
Log.p("this is log to test log level: info", type: .info)
Log.p("this is log to test log level: debug", type: .debug)
Log.p("this is log to test log level: verbose", type: .verbose)
```

### Example: How to share log file

```
if let logFilePath = Log.fileLogger.currentLogFileInfo?.filePath {
    DispatchQueue.main.async {
    	let fileUrl = URL(fileURLWithPath: logFilePath)
	    let activityViewController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        self.present(activityViewController, animated: true) { }
    }
}
```

### Example: How to log Networking request and response:
While you deal with networking requests and responses in your application, you need to logs all the request and response. In Logger.swift file, you will find two seperate methods to do that. 

```
Log.logStartRequest(request: URLRequest) // For request
Log.logEndRequest(response: URLResponse>, data: Data?, error: Error?) // For response
```
 
 
 
I hope you find this repository useful. Do not forgot to follow me for more updates.
 
### Contact Me:

Feel free to reach out if you have questions or if you want to contribute in any way:

* E-mail: nitinagam17@gmail.com
* Instagram: https://www.instagram.com/ios_geeks16/
* Medium: https://medium.com/@nitinagam17
 

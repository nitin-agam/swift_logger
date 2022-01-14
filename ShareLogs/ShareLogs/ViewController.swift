//
//  ViewController.swift
//  ShareLogs
//
//  Created by Nitin Aggarwal on 14/01/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding some dummy logs to check in sharable log file.
        logDummyValues()
    }
    
    private func logDummyValues() {
        Log.p(#function, type: .info)
        Log.p("this is log to test log level: error", type: .error)
        Log.p("this is log to test log level: warn", type: .warn)
        Log.p("this is log to test log level: info", type: .info)
        Log.p("this is log to test log level: debug", type: .debug)
        Log.p("this is log to test log level: verbose", type: .verbose)
    }
    
    @IBAction func handleShareLogClicked(_ sender: UIButton) {
        if let logFilePath = Log.fileLogger.currentLogFileInfo?.filePath {
            DispatchQueue.main.async {
                self.shareItem(item: URL(fileURLWithPath: logFilePath))
            }
        }
    }
}

extension ViewController {
    
    func shareItem(item: Any) {
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        self.present(activityViewController, animated: true) { }
    }
}

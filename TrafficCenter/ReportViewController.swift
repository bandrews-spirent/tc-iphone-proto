//
//  ReportViewController.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 9/6/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var webview: UIWebView!
    
    var reportId = ""
    var testId = ""
    var trafficCenterIp = ""
    
    let reportUrlFmt = "http://%@/traffic-center/#/tests/%@/reports/%@"

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = String(format: reportUrlFmt, trafficCenterIp, testId, reportId)
        webview.loadRequest(URLRequest(url: URL(string: url)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

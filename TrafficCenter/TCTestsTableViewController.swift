//
//  TCTestsTableViewController.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/27/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

class TCTestsTableViewController: UITableViewController, CellTapProtocol {
    
    // MARK: Properties
    
    var tests = [TCTest]()
    var trafficCenter: TrafficCenter? = nil
    
    let statusTextColor = UIColor(red: CGFloat(10/255.0), green: CGFloat(174/255.0), blue: CGFloat(207/255.0), alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        loadTests()
    }
    
    func loadTests() {        
        trafficCenter?.signIn(onComplete: {data, err -> Void in
            if err == nil {
                self.trafficCenter?.listTests(onComplete: {tests, err -> Void in
                    for test in tests {
                        if let testDict = test as? [String: AnyObject] {
                            var playing = false
                            if testDict["running"] as! Bool == true {
                                playing = true
                            }
                            let t = TCTest(name: testDict["name"] as! String,
                                           desc: testDict["description"] as! String,
                                           id: testDict["id"] as! String,
                                           error: "",
                                           playing: playing)
                            self.tests += [t]
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "TCTestCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TCTestCell
        let test = tests[indexPath.row]
        cell.name.text = test.name
        cell.desc.text = test.desc
        cell.error.text = test.error
        
        if !test.grade.isEmpty {
            cell.status.setImage(reportImage(grade: test.grade), for: UIControlState.normal)
            cell.status.isHidden = false
        } else if !test.status.isEmpty {
            cell.status.setImage(textToImage(text: statusText(test: test),
                                            inImage: #imageLiteral(resourceName: "runStatus"),
                                            font: UIFont.systemFont(ofSize: 5),
                                            color: statusTextColor), for: UIControlState.normal)
            cell.status.isHidden = false
        } else {
            cell.status.isHidden = true
        }
        
        let fractionalProgress = Float(test.progress) / 100.0
        let animated = test.progress != 0
        cell.progress.setProgress(fractionalProgress, animated: animated)
        cell.cellDelegate = self
        
        if test.playing {
            cell.playButton.setImage(#imageLiteral(resourceName: "stop"), for: UIControlState.normal)
        }else{
            cell.playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControlState.normal)
        }

        return cell
    }
    
    func statusText(test: TCTest) -> String {
        switch test.status {
        case "Starting":
            return "Initializing"
        case "ReservingPorts":
            return "Reserving Ports"
        case "ApplyingConfiguration":
            return "Applying"
        case "Stopping":
            return "Stopping"
        case "Canceling":
            return "Canceling"
        case "GeneratingReport", "StoppingBll":
            return "Generating Report"
        case "Running":
            return "\(test.progress)%"
        default:
            return ""
        }
    }
    
    func reportImage(grade: String) -> UIImage {
        var image: UIImage
        var g = grade
        switch g {
        case "A":
            image = solidRectangle(size: #imageLiteral(resourceName: "runStatus").size, color: UIColor.green)
        case "B":
            image = solidRectangle(size: #imageLiteral(resourceName: "runStatus").size, color: UIColor.blue)
        case "C":
            image = solidRectangle(size: #imageLiteral(resourceName: "runStatus").size, color: UIColor.yellow)
        case "D":
            image = solidRectangle(size: #imageLiteral(resourceName: "runStatus").size, color: UIColor.brown)
        case "F":
            image = solidRectangle(size: #imageLiteral(resourceName: "runStatus").size, color: UIColor.red)
        default:
            image = solidRectangle(size: #imageLiteral(resourceName: "runStatus").size, color: UIColor.black)
            g = "I"
        }
        
        return textToImage(text: g, inImage: image, font: UIFont.systemFont(ofSize: 20), color: UIColor.white)
    }
    
    func textToImage(text: String, inImage: UIImage, font: UIFont, color: UIColor) -> UIImage {
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color
            ]
        
        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        
        let words = text.components(separatedBy: " ")
        var heightSpace = CGFloat(0.0)
        let heightSpaceAmount = CGFloat(6.0)
        for word in words {
            let textSize = word.size(attributes: textFontAttributes)
            let rect = CGRect(x: inImage.size.width / 2 - textSize.width / 2,
                              y:(inImage.size.height / 2 - textSize.height / 2) + heightSpace,
                              width: inImage.size.width / 2 + textSize.width / 2,
                              height: inImage.size.height / 2  + textSize.height / 2)
            word.draw(in: rect, withAttributes: textFontAttributes)
            heightSpace += heightSpaceAmount
        }
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func solidRectangle(size: CGSize, color: UIColor) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, true, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        context.setFillColor(color.cgColor)
        context.addRect(rect)
        context.drawPath(using: .fillStroke)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func didTapCell(cell: UITableViewCell, action: Action) {
        if cell is TCTestCell {
            if let idx = tableView.indexPath(for: cell)?.row {
                let test = tests[idx]
                if action == Action.Play {
                    handlePlayAction(test: test)
                }else if action == Action.Report {
                    handleReportAction(test: test)
                }
            }
        }
    }
    
    func handlePlayAction(test: TCTest) {
        test.error = ""
        test.status = ""
        test.grade = ""
        test.lastReportId = ""
        if test.playing {
            trafficCenter?.stopTest(id: test.id, onComplete: { success, err -> Void in
                if err != nil {
                    test.error = err!.localizedDescription
                }else{
                    test.playing = false
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            })
            
        }else {
            trafficCenter?.startTest(id: test.id, onComplete: { success, err -> Void in
                if err != nil {
                    test.error = err!.localizedDescription
                }else{
                    test.playing = true
                    test.progress = 0
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(TCTestsTableViewController.handleRefresh),
                                         userInfo: test, repeats: true)
                })
            })
        }
        
    }
    
    func handleReportAction(test: TCTest) {
        if !test.grade.isEmpty {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "Report") as! ReportViewController
            controller.trafficCenterIp = (trafficCenter?.ipAddr)!
            controller.testId = test.id
            controller.reportId = test.lastReportId
            self.navigationController!.pushViewController(controller, animated: true)
        }
    }
    
    func handleRefresh(timer: Timer) {
        let test = timer.userInfo as! TCTest
        trafficCenter?.getRunningTest(id: test.id, onComplete: { data, err -> Void in
            if err == nil {
                if let status = data["status"] as? String {
                    if status == "Idle" {
                        test.playing = false
                        test.status = ""
                        if let completion_status = data["completion_status"] as? String {
                            if completion_status == "Error" {
                                test.error = "error running test"
                            }
                        }
                        
                        self.handleReport(test: test)
                        timer.invalidate()
                    }else {
                        test.status = status
                    }
                    
                    if let progress = data["progress_step"] as? Int {
                        test.progress = progress
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
                print("refresh data-->", data)
            }
        })
    }
    
    func handleReport(test: TCTest) {
        self.trafficCenter?.getLatestReport(id: test.id, onComplete: { data, err -> Void in
            if err != nil || data.count == 0 {
                test.error = "could not fetch report"
            }else {
                if let grade = data["grade"] as? String {
                    test.grade = grade
                }
                
                if let id = data["id"] as? String {
                    test.lastReportId = id
                }
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        })
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

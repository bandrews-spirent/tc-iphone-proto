//
//  TCInstanceTableViewController.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/25/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

class TCInstanceTableViewController: UITableViewController, CellTapProtocol {
    
    // MARK: Properties
    
    var tcInstances = [TCInstance]()
    var orion: Orion? = nil

    override func viewDidLoad() {
        super.viewDidLoad()        
        loadTrafficCenterInstances()
    }
    
    func loadTrafficCenterInstances() {
        orion?.listTrafficCenterApplicationInstances(onComplete: { data, err -> Void in
            if err != nil {
                self.tcInstances = [TCInstance(ipAddr: "No instances found", desc: "", image: nil, statusImage: nil)]
                return
            }
            
            print("There are \(data.count) instances")
            
            for inst in data {
                if let tcDict = inst as? [String: AnyObject] {
                    var ipAddr = "unknown"
                    var color = "unknown"
                    var version = ""
                    var location = "unknown"
                    if let ip = tcDict["ip_address"] as? String {
                        ipAddr = ip
                    }
                    
                    if let c = tcDict["color"] as? String {
                        color = c
                    }
                    
                    if let ver = tcDict["application"]?["version"] as? String {
                        version = ver
                    }
                    
                    if let l = tcDict["location"]?["name"] as? String {
                        location = l
                    }
                    
                    self.tcInstances += [TCInstance(ipAddr: ipAddr,
                                                    desc: "location: \(location)\nversion: \(version)",
                                                    image: #imageLiteral(resourceName: "TrafficCenterLogo"),
                                                    statusImage: self.getStatusImage(color: color))]
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        })
    }
    
    func getStatusImage(color: String) -> UIImage? {
        switch color {
        case "green":
            return #imageLiteral(resourceName: "statusGood")
        case "yellow":
            return #imageLiteral(resourceName: "statusYellow")
        case "red":
            return #imageLiteral(resourceName: "statusRed")
        default:
            return nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tcInstances.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TCInstanceCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TCInstanceCell
        
        let tcInstance = tcInstances[indexPath.row]

        cell.ipAddress.text = tcInstance.ipAddr
        cell.desc.text = tcInstance.desc
        cell.tcImage.image = tcInstance.image
        cell.statusImage.image = tcInstance.statusImage
        cell.cellDelegate = self
        return cell
    }
    
    func didTapCell(cell: UITableViewCell, action _: Action) {
        if let tcInstCell = cell as? TCInstanceCell {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "TCTests") as! TCTestsTableViewController
            controller.trafficCenter = TrafficCenter(ipAddr: tcInstCell.ipAddress.text!, orionToken: (self.orion?.token)!)
            self.navigationController!.pushViewController(controller, animated: true)
        }
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
/*    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prepare for", segue.identifier)
    }*/
}

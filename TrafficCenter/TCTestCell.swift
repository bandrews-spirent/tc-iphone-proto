//
//  TCTestCell.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/27/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

class TCTestCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var status: UIButton!
    
    var cellDelegate: CellTapProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Actions
    @IBAction func playTouched(_ sender: UIButton) {
        cellDelegate?.didTapCell(cell: self, action: Action.Play)
    }

    @IBAction func statusTouched(_ sender: UIButton) {
        cellDelegate?.didTapCell(cell: self, action: Action.Report)
    }
}

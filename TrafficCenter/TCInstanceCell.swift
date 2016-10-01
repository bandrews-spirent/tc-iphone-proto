//
//  TCInstanceCell.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/25/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

class TCInstanceCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var ipAddress: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var tcImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    
    var cellDelegate: CellTapProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        self.desc.numberOfLines = 0
        self.desc.lineBreakMode = NSLineBreakMode.byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.cellDelegate?.didTapCell(cell: self, action: Action.NotApplicable)
        }
    }
}

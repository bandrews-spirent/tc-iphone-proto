//
//  CellTapProtocol.swift
//  TrafficCenter
//
//  Created by Andrews, Barry on 8/27/16.
//  Copyright © 2016 Spirent Communications. All rights reserved.
//

import UIKit

enum Action {
    case Play, Report, NotApplicable
}

protocol CellTapProtocol {

    func didTapCell(cell: UITableViewCell, action: Action) -> Void
}

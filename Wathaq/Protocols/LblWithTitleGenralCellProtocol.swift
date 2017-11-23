//
//  LblWithTitleGenralCellProtocol.swift
//  EngineeringSCE
//
//  Created by Basant on 6/22/17.
//  Copyright © 2017 sce. All rights reserved.
//
import Foundation

protocol LblWithTitleGenralCellProtocol {
    func numOfItems() -> Int
    func titleForIndexPath(indexPath: IndexPath) -> String
    func iconForIndexPath(indexPath: IndexPath) -> String?
}

//
//  Array+Only.swift
//  Memorize
//
//  Created by Katerina Utlik on 2/22/21.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}

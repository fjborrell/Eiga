//
//  Filter.swift
//  Eiga
//
//  Created by Fernando Borrell on 7/21/24.
//

import Foundation

protocol FilterOption: Identifiable, CaseIterable, Equatable, Hashable {
    var title: String { get }
}

//
//  SectionType.swift
//  DataSourceable
//
//  Created by Niels van Hoorn on 13/10/15.
//  Copyright © 2015 Zeker Waar. All rights reserved.
//

 protocol SectionType: DataContaining {
    var headerTitle: String? { get }
    var footerTitle: String? { get }
}

 extension SectionType {
    var headerTitle: String? { return nil }
    var footerTitle: String? { return nil }
}

 extension SectionType where Self == Data {
    var data: Data? {
        return self
    }
}
extension Array: SectionType {}
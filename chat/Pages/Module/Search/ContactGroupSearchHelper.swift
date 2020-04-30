//
//  ContactGroupSearchHelper.swift
//  chat
//
//  Created by Grand on 2019/12/16.
//  Copyright © 2019 netcloth. All rights reserved.
//

import Foundation

class ContactGroupSearchHelper: NSObject {
    
    static var target: String?
    
    static func onTapSearch() {
        target = nil
        if let vc = R.loadSB(name: "SearchVC", iden: "SearchVC") as? SearchVC {
            
            let resultVc = R.loadSB(name: "ContactGroupSearchVC", iden: "ContactGroupSearchVC") as! ContactSearchResultVC
            
            vc.resultVC = resultVc
            vc.searchTextChange = { (input, call) in
                searchTextChangeOver(input, call: call)
            }
            
            Router.present(vc: vc)
        }
    }
    
    static func searchTextChangeOver(_ input: String?,  call:@escaping ((Any)->Void)) {
        target = input
        if let t = input , t.isEmpty == false {
            CPGroupManagerHelper.searchContacts(t) { (r, msg, contacts) in
                call(contacts)
            }
        }
        else {
            call([])
        }
    }
}

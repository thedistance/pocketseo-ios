//
//  MZParseHTMLDataOperation.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import hpple
//import PocketSEOEntities

extension TFHppleElement {
    
    func allText() -> String {
        
        let strs = children.flatMap({ (obj:AnyObject) -> String? in
            
            if let child = obj as? TFHppleElement {
                
                if child.isTextNode() {
                    return child.content
                } else {
                    return child.allText()
                }
                
            } else {
                return nil
            }
        })
        
        return strs.reduce("", combine: +)
    }
}

class MZParseHTMLDataOperation: FailingOperation {
    
    var success:((data:MZHTMLMetaData) -> ())?
    
    let htmlData:NSData
    
    init(data:NSData) {
        htmlData = data
    }
    
    override func execute() {
        
        guard let htmlDoc = TFHpple(HTMLData: htmlData) else {
            
            let error = NSError(domain: .HTMLError, code: .UnexpectedResponse, userInfo: [NSLocalizedDescriptionKey: "Unable to create hpple HTML Document from data."])
            self.finish([error])
            return
        }
        
        let titleElements = htmlDoc.searchWithXPathQuery("//title")
        let title = (titleElements.first as? TFHppleElement)?.allText()
        
        let canonicalElements = htmlDoc.searchWithXPathQuery("//link[@rel='canonical']")
        let canonical = (canonicalElements.first as? TFHppleElement)?.attributes["href"] as? String
        let canonicalURL:NSURL?
        if let cStr = canonical {
            canonicalURL = NSURL(string: cStr)
        } else {
            canonicalURL = nil
        }
        
        
        let descriptionElements = htmlDoc.searchWithXPathQuery("//meta[@name='description']")
        let description = (descriptionElements.first as? TFHppleElement)?.attributes["content"] as? String
        
        let h1Elements = htmlDoc.searchWithXPathQuery("//h1")
        let h1Tags = h1Elements.flatMap({ ($0 as? TFHppleElement)?.allText() })
        
        let h2Elements = htmlDoc.searchWithXPathQuery("//h2")
        let h2Tags = h2Elements.flatMap({ ($0 as? TFHppleElement)?.allText() })
        
        let htmlMeta = MZHTMLMetaData(title: title,
            canonicalURL: canonicalURL,
            description: description,
            h1Tags: h1Tags,
            h2Tags: h2Tags)
    
        self.success?(data: htmlMeta)
        self.finish()
    }
}


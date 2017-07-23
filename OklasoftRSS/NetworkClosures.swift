//
//  NetworkClosures.swift
//  OklasoftRSS
//
//  Created by Justin Oakes on 7/6/17.
//  Copyright © 2017 Oklasoft LLC. All rights reserved.
//

import Foundation
#if os(OSX)
    import OklasoftNetworking
#elseif os(iOS)
    import OklasoftNetworking_iOS_
#endif


public extension URLSession {
    
    static let identifyFeedsCompletion: networkCompletion = {(data, responce, error) in
        if let foundError:Error = error {
            NotificationCenter.default.post(name: .networkingErrorNotification,
                                            object: nil,
                                            userInfo:errorInfo(error: foundError).toDict())
            return
        }
        guard let headers: URLResponse = responce,
            let validData: Data = data,
            let mimeType: mimeTypes = mimeTypes(rawValue:(headers.mimeType ?? "")),
            let title: String = headers.suggestedFilename,
            let url: URL = headers.url
            else {
                let error: Error = unrecognizableDataError
                NotificationCenter.default.post(name: .feedIdentificationError,
                                                object: nil,
                                                userInfo: [errorInfoKey:error])
                return
        }
        let newFeed: Feed = Feed(title: title,
                                 url: url,
                                 lastUpdated: Date(),
                                 mimeType: mimeType,
                                 favIcon: nil)
        NotificationCenter.default.post(name: .finishedReceavingFeed,
                                        object: nil,
                                        userInfo: [feedInfoKey:newFeed])
    }
    
    static let identifyStoriesCompletion: networkCompletion = {(data, responce, error) in
        if let foundError:Error = error {
            NotificationCenter.default.post(name: .networkingErrorNotification,
                                            object: nil,
                                            userInfo:errorInfo(error: foundError).toDict())
            return
        }
        guard let headers: URLResponse = responce,
            let validData: Data = data,
            let mimeType: mimeTypes = mimeTypes(rawValue:(headers.mimeType ?? "")),
            let url: URL = headers.url
            else {
                return
        }
        switch mimeType {
            case .rss, .rssXML:
                let parser: XMLParser = XMLParser(data: validData)
                parser.parseRSSFeed(fromParent: url)
                break
            case .atom, .atomXML:
                let parser: XMLParser = XMLParser(data: validData)
                parser.parseAtomFeed(fromParent: url)
                break
            //TODO: add other types
        default:
            break
        }
    }
    
}

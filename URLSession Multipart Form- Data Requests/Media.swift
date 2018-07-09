//
//  Media.swift
//  URLSession Multipart Form- Data Requests
//
//  Created by Ahmet Berkay CALISTI on 28/06/2018.
//  Copyright © 2018 Ahmet Berkay CALISTI. All rights reserved.
//

import Foundation
import UIKit

// Media could be photos, videos, audio

struct Media {
    
    let key: String
    let fileName: String
    let data: Data      // we have data that we have to pass to the API
    let mimeType: String    // Usually I would make enum for the different mime types that you can send just go little bit quicker 
    
    // All we need to do to initialize this class everything else we're gonna take care of inside
    init?(withImage image: UIImage, forKey key: String) {
        
        self.key = key
        self.mimeType = "image/jpeg"
        self.fileName = "photo\(arc4random()).jpeg"
        
        guard let data = UIImageJPEGRepresentation(image, 0.7) else { return nil }
        self.data = data
    }
}



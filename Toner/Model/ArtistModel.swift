//
//  ArtistModel.swift
//  Toner
//
//  Created by Users on 22/02/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation
struct ArtistDetailsModel{
    var artistName  : String
    var artistImage : String
    var followStatus: Int
    var social      : ArtistSocial = ArtistSocial()
    var songs       : [SongModel]
}


struct ArtistSocial {
    var website: String = ""
    var nu: String = ""
    var twitter: String = ""
    var instagram: String = ""
    var youtube: String = ""
    var vimeo: String = ""
    var tiktok: String = ""
    var triller: String = ""
}

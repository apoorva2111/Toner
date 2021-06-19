//
//  HomePageDataModel.swift
//  Toner
//
//  Created by Users on 13/02/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation

struct HomePageDataModel{
    var topgenre: [TopGenreModel]
    var newartist: [ArtistModel]
    var topartist: [ArtistModel]
    
    init(){
        topgenre = [TopGenreModel]()
        newartist = [ArtistModel]()
        topartist = [ArtistModel]()
    }
}

struct TopGenreModel{
    var id: String
    var name: String
    var icon: String
    var color: String
    
}

struct ArtistModel{
    var id: String
    var firstname: String
    var lastname: String
    var email: String
    var username: String
    var phone: String
    var image: String
    var type: String
    var is_online: String
   // var songData : SongModel
}

struct BannerModel{
    var bannerURL: String
    var bannerType: String
}

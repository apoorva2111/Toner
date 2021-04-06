//
//  PlaylistViewModel.swift
//  Toner
//
//  Created by Mona on 27/10/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation
struct PlaylistViewModel{
    var playlist_id     : String
    var playlist_name   : String
    var totalsongs      : Int
    var image           : String
    var songs           : [SongModel]
}

//
//  Setting.swift
//  Toner
//
//  Created by User on 05/08/20.
//  Copyright © 2020 Users. All rights reserved.
//

import Foundation
struct Setting {
    var name: String = ""
    var image: String = ""
}

public enum SettingsName{
   //
    static let acountOverview = "ACCOUNT OVERVIEW"
    static let editProfile = "EDIT PROFILE"
    static let subscription = "SUBSCRIPTION"
    static let followers = "FOLLOWING"
    static let myStation = "MY STATION"
    static let changePassword = "CHANGE PASSWORD"
    static let myAlbum = "MY ALBUM"
    static let mySongs = "MY SONGS"
    static let myCommission = "MY COMMISSION"
    static let support = "SUPPORT/HELP"
    static let logOut = "LOGOUT"
    static let editSocial = "EDITSOCIAL"
    static let myDownload = "MY DOWNLOADS"
}

public enum SettingsImage{
    static let editProfile = "edit-profile"
    static let accountoverview = "account-overview"
    static let subscription = "subscription"
    static let followers = "followers"
    static let support = "support"
    static let logOut = "logout"
    static let myalbum = "my-album"
    static let mysongs = "my-songs"
    static let mycommission = "my-commission"
    static let myDownload = "download"
    static let edit_social = "edit-social"
    static let change_password = "change-password"
}

/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Album_Songs {
	public var id : String?
	public var album_id : String?
	public var user_id : String?
	public var package_id : String?
	public var path : String?
	public var name : String?
	public var filetype : String?
	public var filesize : String?
	public var duration : String?
	public var image : String?
	public var tag : String?
	public var description : String?
	public var genre_id : String?
	public var lyrics : String?
	public var release_date : String?
	public var allow_download : String?
	public var price : String?
	public var sort_order : String?
	public var status : String?
	public var date_added : String?
	public var firstname : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let songs_list = Songs.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Songs Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Album_Songs]
    {
        var models:[Album_Songs] = []
        for item in array
        {
            models.append(Album_Songs(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let songs = Songs(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Songs Instance.
*/
	required public init?(dictionary: NSDictionary) {

		id = dictionary["id"] as? String
		album_id = dictionary["album_id"] as? String
		user_id = dictionary["user_id"] as? String
		package_id = dictionary["package_id"] as? String
		path = dictionary["path"] as? String
		name = dictionary["name"] as? String
		filetype = dictionary["filetype"] as? String
		filesize = dictionary["filesize"] as? String
		duration = dictionary["duration"] as? String
		image = dictionary["image"] as? String
		tag = dictionary["tag"] as? String
		description = dictionary["description"] as? String
		genre_id = dictionary["genre_id"] as? String
		lyrics = dictionary["lyrics"] as? String
		release_date = dictionary["release_date"] as? String
		allow_download = dictionary["allow_download"] as? String
		price = dictionary["price"] as? String
		sort_order = dictionary["sort_order"] as? String
		status = dictionary["status"] as? String
		date_added = dictionary["date_added"] as? String
		firstname = dictionary["firstname"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.album_id, forKey: "album_id")
		dictionary.setValue(self.user_id, forKey: "user_id")
		dictionary.setValue(self.package_id, forKey: "package_id")
		dictionary.setValue(self.path, forKey: "path")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.filetype, forKey: "filetype")
		dictionary.setValue(self.filesize, forKey: "filesize")
		dictionary.setValue(self.duration, forKey: "duration")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.tag, forKey: "tag")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.genre_id, forKey: "genre_id")
		dictionary.setValue(self.lyrics, forKey: "lyrics")
		dictionary.setValue(self.release_date, forKey: "release_date")
		dictionary.setValue(self.allow_download, forKey: "allow_download")
		dictionary.setValue(self.price, forKey: "price")
		dictionary.setValue(self.sort_order, forKey: "sort_order")
		dictionary.setValue(self.status, forKey: "status")
		dictionary.setValue(self.date_added, forKey: "date_added")
		dictionary.setValue(self.firstname, forKey: "firstname")

		return dictionary
	}

}

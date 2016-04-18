# HealthyDiet

A mashup-based app based on integrating Web APIs. Integrate information of food and recipes from 4 different providers.

## Introduction

Nowadays there are more and more kinds of tasty food everywhere. Therefore, we often take in a lot of energy unconsciously. However, people also pay more attention to their health and want to control what they eat to take in less junk food. So I develop a simple app to view how much we eat in our daily life, called “Healthy Diet”. With “Healthy Diet” people could see their intake of energy more straightly.

## Mainly Used Third-party Services

1. Public APIs

	1. [National Nutrient Database API](https://ndb.nal.usda.gov/ndb/doc/index)  : An API to get USDA data on food nutrients in order to generate nutrient reports, get lists of products by nutrient or food group, or search for a specific food product. Return **XML** format.

	2. [Edamam](https://developer.edamam.com/) : A free API includes information such as calorie content per serving for the submitted recipe. Return **JSON** format.

	3. [Recipeon](http://recipeon.us/home) : A recipe search engine allows applications to search recipe based on ingredients. Return **JSON** format.

	4. [Supermarket](http://www.supermarketapi.com/Default.aspx) : An API allows developers to access and integrate information of supermarkets into their applications and services. Return **XML** format.

2. Open Source Libraries

	1. [Alamofire](https://github.com/Alamofire/Alamofire) : Swift based HTTP networking library.
	2. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) : Swift based JSON handling library.
	3. [SWXMLHash](https://github.com/drmohundro/SWXMLHash) : Swift based XML handling library.
	4. [PKHUD](https://github.com/pkluz/PKHUD) : Swift based reimplementation of the Apple HUD.
	5. [SDWebImage](https://github.com/rs/SDWebImage) : Asynchronous image downloader with cache support as a UIImageView category.

## Configuration and Deployment Description

#### Development environment:

1. Xcode 7.2 (7C68)
2. iOS Simulator 9.2 (13C75)
3. Cocoapods 1.0.0.beta.4
4. Git 2.5.4

#### Configurations:

1. download from zip / git clone

	```bash
	$ git clone https://github.com/MandyXue/HealthyDiet.git
	```

2. install cocoapod libraries
	
	```bash
	$ pod install
	```

3. open ```HealthyDiet.xcworkspace``` and run

## Design and Implementation

#### Data Structure

* Based on **MVC** structure

	This app is based on MVC structure in iOS developing. This is the first time I write network in iOS, so at first I didn't seperate controller and network model completely. But when I integrate the last API into my app, I made a big change to seperate view controllers and its network interfaces.

	I use Alamofire to fetch data from network and encapsulate the interfaces into models. For example, in ```RecipeModel.swift```, I encapsulated a method to get recipes by ingredients :

	```swift
	// Based url doesn't using parameters. Instead, they use direct url to get data
	// like: http://api.recipeon.us/2.0/recipe/suggest/<developerkey>/<from>/<count>/<ingredient>&<ingredient>
	// so I deal with the url myself
	static func getRecipesByIngredients(ingredients:[String], resultHandler: ([NSDictionary]) -> Void) {
        if ingredients.count > 0 {
            // deal with url myself.....
            var ingredientRequest = ingredients[0]
            for (var i=1; i<ingredients.count; i++) {
                ingredientRequest.appendContentsOf("&"+ingredients[i])
            }
            var url = URL.GetRecipesByIngredients.url()
            url.appendContentsOf(ingredientRequest)
            // get JSON data
            // ......
        }
    }
	```

	Then I call the static method in the view controller to fetch data, for example:

	```swift
	// MARK: - search bar delegate
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            print(searchText)
            HUD.show(.Progress)
            self.recipes?.removeAll()
            // use closures to get data
            RecipeHelper.getRecipesByIngredients(seperateIngredients(searchText)) { (recipeDic) -> Void in
                self.recipes = recipeDic
                self.tableView.reloadData()
                HUD.flash(.Success)
            }
        }
    }
	```

	And I wrapped the API keys and URLs in two ```enum``` to get global data.
	If the key is not available, just get to ```URL.swift``` and change them to your own API keys.

* Using **Core Data** to store data locally

	This app's main functions is to store data locally so I use coredata because of its light weight.

	Firstly, I designed the database and their relationships in ```Model.xcdatamodeld```, the database is like this:
	![pic](http://cl.ly/3t2x3w162O2p/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-04-18%20%E4%B8%8A%E5%8D%8811.35.23.png)

	Then, I generate their classes in order to fetch data and store data, for example:

	```swift
	class DietModel: NSManagedObject {
		// used to add nutrient to diet model
	    func addNutrientObject(nutrient: NutrientModel) {
	        self.mutableSetValueForKey("nutrients").addObject(nutrient)
	    }
	    // to add recipe to diet model
	    func addRecipeObject(recipe: RecipeModel) {
	        self.mutableSetValueForKey("recipes").addObject(recipe)
	    }
	}
	extension DietModel {
	    @NSManaged var category: String?
	    @NSManaged var measure: String?
	    @NSManaged var name: String?
	    @NSManaged var weight: NSNumber?
	    @NSManaged var searchText: String?
	    @NSManaged var id: String?
	    @NSManaged var image: String?
	    // the relationship is in NSSet in core data
	    @NSManaged var recipes: NSSet?
	    @NSManaged var nutrients: NSSet?
	}
	```

	The key point in using core data is to encapsulate the methods to fetch data and store data, for example, the following is to manage diet objects:

	```swift
    func getDietsFromCoreData(page: Int, size: Int, resultHandler: ([DietModel]?) -> Void) {
        let fetchRequest = NSFetchRequest(entityName: "DietModel")
        
        fetchRequest.fetchLimit = size
        fetchRequest.fetchOffset = page
        
        do {
            let fetchResult = try manageContext.executeFetchRequest(fetchRequest)
            let list = fetchResult.map { $0 as! DietModel }
            resultHandler(list)
            print(list)
        } catch {
            resultHandler(nil)
            print("Failure to save context: \(error)")
        }
        
    }
	```

* Using **Alamofire** to fetch data from APIs and **SwiftyJSON / SWXMLHash** to translate **JSON / XML** format

	Alamofire is a elegant library to fetch data through HTTP, but the weak point here is that it cannot read XML by SAX. It can only load the whole response and I need to analysis the data using SWXMLHash, which parses by DOM. I have learnt that the **NSXMLParser** in iOS SDK is parsing by SAX and I've tried that, but there are more constraints when using NSXMLParser so I gave it up.

	The following is an example to fetch data in JSON format through Alamofire:  

	```swift
	...
	Alamofire.request(.GET, url).responseJSON { response in
	    switch response.result {
	    // get JSON result
	    case .Success:
	        if let value = response.result.value {
	            let json = JSON(value)
	            let recipeJSON = json["response"]["docs"].array!
	            // deal with result
	            let recipes = recipeJSON.map ({ (recipe) -> NSDictionary in
	                let name = recipe["title"].string
	                let ingredients = recipe["ingredient"].array!.map {$0.string!}
	                return ["name": name!, "ingredients": ingredients]
	            })
	            resultHandler(recipes)
	        }
	    case .Failure(let error):
	        print(error)
	    }
	}
	...
	```

* Using **SDWebImage** to download pictures asychronously

	Pictures are a great challenge for me in the developing. At first I tried to get pictures sychronously with other data, but it needs too much time. Then I turned to write a closure by myself to handle the situation, but it turned out to be failure and I still don't know why. Fortunenately, I found a powerful library to download the pictures asychronously and it needs less code and performs very well.

	The following is an example to download pictures using SDWebImage:

	```swift
	// get image from url
    let downloader = SDWebImageDownloader.sharedDownloader()
    downloader.downloadImageWithURL(NSURL(string: image), options: .ProgressiveDownload, progress: { (receivedSize, expectedSize) -> Void in
    	// deal with progress, you can print the progress of fetching pictures
    }, completed: { (image, data, error, finished) -> Void in
        if finished {
        	// set the image in a cell
            cell.imageView?.image = image
        }
    })
	``` 

#### User Interfaces

Time is limited and I need to focus more on the backend coding so that I use native iOS elements to design this app. And it looks very well as well.

1. Recipe Tab

	<img src="http://cl.ly/1Q1y440j3f2j/Recipe.png" width=400/>

2. Food Tab
	
	1. Main page

		<img src="http://cl.ly/1b1s0h0z2r16/Food.png" width=400/>

	2. Add page

		<img src="http://cl.ly/002Y2Z0m3o3C/Add.png" width=400/>

	3. Detail page

		<img src="http://cl.ly/2U3W3k011q0Y/Detail.png" width=400/>

## Pros and Cons

This is the first time I handle the front-end and back-end of an iOS app entirely on my own so there's something I need to say.

The first is that I didn't seperate controllers and models completely so that the coding in some controllers are very long and hard. Therefore, they are difficult to read and modify.

The second thing is that I actually didn't handle the network flow very much, speaking of the pictures.

One more is that the UI structure is not very good and balance. It's better if I can exchange the using of two recipe APIs and add an "Add" page to the recipe page.

And there are some details in UI that needs to be dealt with. For example, if the text is too long for the label, it cannot be present completely.

**So in the future I may have some TODOs:**

- [ ] Refactor some controllers and models
- [ ] store the pictures in core data
- [ ] add "Add" page to recipe page
- [ ] add "Detail" page to recipe page
- [ ] exchange the recipe APIs
- [ ] store the recipe in core data
- [ ] deal with some details in UI

====

Copyright &copy; Mandy Xue
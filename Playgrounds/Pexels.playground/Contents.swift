/*:
 # Pexels

 ## Overview

 The Pexels Swift library is a convenient wrapper around the Pexels API that lets you access the full Pexels content library, including photos and videos, using Swift.
*/
/*:
 ## Modules

One module is vended by this package: Pexels.
*/

import Pexels

/*:
 ## API

 The Pexels API requires authentication.
*/
/*:
 ### Authorization

 You need to provide your own api key. You can get one from here: [https://www.pexels.com/api/new/](https://www.pexels.com/api/new/)
*/

let apiKey = "<YOUR PEXELS API KEY>"
let configuration = APIConfiguration(with: apiKey)

/*:
 ### Request Statistics
 Your monthly quota is in `APIProvider.quota` after the Pexels API succeeds.
 The `APIProvider` should be instantiated as `var` because `APIProvider.quota` changes when the API request succeeds.
 ```swift
 var provider = APIProvider(configuration: configuration)
 ```
*/

Task {
    do {
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Photos.search(query: "nature")
        let response = try await provider.request(&request)
        print("Quota remaining: \(provider.quota!.requestRemaining)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 ### Pagination
 The previous page and next page response attributes will only be returned if there is a corresponding page.
*/

Task {
    do {
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Photos.search(query: "nature", page: 2, perPage: 1)
        let response = try await provider.request(&request)
        if let previousPage = response.previousPage {
            print("Previous page: \(previousPage)")
        }
        if let nextPage = response.nextPage {
            print("Next page: \(nextPage)")
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 ### Photos
*/
/*:
 #### Search for Photos
*/
Task {
    do {
        let query = "nature"
        let orientation = APIParameterTypes.Orientation.square
        let size = APIParameterTypes.Size.small
        let color = APIParameterTypes.Color.orange
        let locale = APIParameterTypes.Locale.koKR
        let page = 1
        let perPage = 2
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Photos.search(
            query: query,
            orientation: orientation,
            size: size,
            color: color,
            locale: locale,
            page: page,
            perPage: perPage)
        let response = try await provider.request(&request)
        print("Search for Photos\n\(response.photos.map { "\($0.url)" }.joined(separator: "\n"))")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 #### Curated Photos
*/
Task {
    do {
        let page = 1
        let perPage = 2
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Photos.curated(
            page: page,
            perPage: perPage)
        let response = try await provider.request(&request)
        print("Curated Photos\n\(response.photos.map { "\($0.url)" }.joined(separator: "\n"))")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 #### Get a Photo
*/
Task {
    do {
        let id = 27220729
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Photos.photo(id: id)
        let response = try await provider.request(&request)
        print("Get a Photo #\(id): \(response.url)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 ### Videos
*/
/*:
 #### Search for Videos
*/
Task {
    do {
        let query = "nature"
        let orientation = APIParameterTypes.Orientation.square
        let size = APIParameterTypes.Size.small
        let locale = APIParameterTypes.Locale.koKR
        let page = 1
        let perPage = 2
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Videos.search(
            query: query,
            orientation: orientation,
            size: size,
            locale: locale,
            page: page,
            perPage: perPage)
        let response = try await provider.request(&request)
        print("Search for Videos\n\(response.videos.map { "\($0.url)" }.joined(separator: "\n"))")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 #### Popular Videos
*/
Task {
    do {
        let minWidth = 100
        let minHeight = 100
        let minDuration = 1
        let maxDuration = 10
        let page = 1
        let perPage = 2
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Videos.popular(
            minWidth: minWidth,
            minHeight: minHeight,
            minDuration: minDuration,
            maxDuration: maxDuration,
            page: page,
            perPage: perPage)
        let response = try await provider.request(&request)
        print("Popular Videos\n\(response.videos.map { "\($0.url)" }.joined(separator: "\n"))")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 #### Get a Video
*/
Task {
    do {
        let id = 1526909
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Videos.video(id: id)
        let response = try await provider.request(&request)
        print("Get a Video #\(id): \(response.url)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 ### Collections
*/
/*:
 #### Featured Collections
*/
Task {
    do {
        let page = 1
        let perPage = 2
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Collections.featured(
            page: page,
            perPage: perPage)
        let response = try await provider.request(&request)
        print("Featured Collections\n\(response.collections.map { "\($0.title)" }.joined(separator: "\n"))")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 #### My Collections
*/
Task {
    do {
        let page = 1
        let perPage = 2
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Collections.my(
            page: page,
            perPage: perPage)
        let response = try await provider.request(&request)
        print("My Collections\n\(response.collections.map { "\($0.title)" }.joined(separator: "\n"))")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

/*:
 #### Collection Media
*/
Task {
    do {
        let id = "sbbslu5"
        let type = APIParameterTypes.MediaType.photos
        let sort = APIParameterTypes.Sort.descending
        let page = 1
        let perPage = 2
        var provider = APIProvider(configuration: configuration)
        var request = try APIEndpoint.Collections.media(
            id: id,
            type: type,
            sort: sort,
            page: page,
            perPage: perPage)
        let response = try await provider.request(&request)
        print("Collection Media\n\(response.media.map { "\($0.type)" }.joined(separator: "\n"))")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}

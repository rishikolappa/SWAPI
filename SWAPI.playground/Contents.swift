import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    let title: String
 //   let opening_crawl: String
 //   let release_date: String
}

class SwapiService {
    
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    static let personEndpoint = "people/"
    static let filmsEndpoint = "films/"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // Step 1:
        guard let baseURL = baseURL else {return completion(nil)}
        let personURL = baseURL.appendingPathComponent(personEndpoint)
        let inString = String(id)
        let finalURL = personURL.appendingPathComponent(inString)
        print(finalURL)
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil)}
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                print(person)
                return completion(person)
            } catch {
                print(print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)"))
                return completion(nil)
            }
            
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask (with: url) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            guard let data = data else {return completion(nil) }
            
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                print(film)
                return completion(film)
            } catch {
                print ("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
        }.resume()
        
    }
}//End of class

func fetchFilmForGivenURL(url: URL) {

SwapiService.fetchFilm (url: url) { film in
       }
}

SwapiService.fetchPerson(id: 1) { person in
    if let person = person {
        print(person)
        for url in person.films {
            fetchFilmForGivenURL(url: url)
        }
    }
}



import Foundation


struct QuizItem: Codable{
	let id: Int
	let question: String
	let answer: String
	let author: Author?
	let attachment: Attachment?
	var favourite: Bool
	
	struct Author: Codable {
		let id: Int
		let isAdmin: Bool?
		let username: String?
		let profileName: String?
		let photo: Attachment?
	}
	
	struct Attachment: Codable {
		let filename: String?
		let mime: String?
		let url: URL?
	}
}



class QuizModel: ObservableObject{
	
	@Published var quizzes = [QuizItem]()
	@Published private(set) var autores = [QuizItem.Author]()
	
	let session = URLSession.shared
	let urlBase = "https://core.dit.upm.es"
	let TOKEN = "b950a30b668672ce7cee"
	
	func load() {
		
		let s = "\(urlBase)/api/quizzes/random10wa?token=\(TOKEN)"
		
		guard let url = URL(string: s) else {
			print("Fallo 1 creado URL random10wa")
			return
		}
		
		let t = session.dataTask(with: url) { (data, res, error) in
			if error != nil{
				print("Fallo 2 de error")
				return
			}
			
			if (res as! HTTPURLResponse).statusCode != 200{
				print("Fallo 3 de res")
				return
			}

			let decoder = JSONDecoder()
			
			if let quizzes = try? decoder.decode([QuizItem].self, from: data!){//sueta excepcion por eso try?
				DispatchQueue.main.async {
					self.quizzes = quizzes
				}
			}
		}
		t.resume()
	}
	func toggleFavourite( _ quizItem: QuizItem){
		
		guard let index = quizzes.firstIndex(where: {$0.id == quizItem.id}) else {
			print("Fallo 5 index")
			return
		}
		
		let surl = "\(urlBase)/api/users/tokenOwner/favourites/\(quizItem.id)?token=\(TOKEN)"
		
		guard let url = URL(string: surl) else{
			print(surl)
			print("Fallo 6 creando url")
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = quizItem.favourite ? "DELETE" : "PUT"
		request.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
		
		let t = session.uploadTask(with: request, from: Data()) {(data, res, error) in
			
			if error != nil{
				print("Fallo 7 de error")
				return
			}
			
			if (res as! HTTPURLResponse).statusCode != 200{
				print("Fallo 8 de res")
				return
				
			}
			
			DispatchQueue.main.async {
				self.quizzes[index].favourite.toggle()
			}
		}
		t.resume()
	}
	
	
	///////////////////////////////////////////////////
	
	func getUsers(){ //WIP
		
		let surl = "\(urlBase)/api/users?token=\(TOKEN)"
		
		guard let url = URL(string: surl) else{
			print(surl)
			return print("Fallo GETUSERS creando url")
		}
		
		let t = session.dataTask(with: url) { (data, res, error) in
			if error != nil{
				return print("Fallo 2 de error")
			}
			
			if (res as! HTTPURLResponse).statusCode != 200{
				return print("Fallo 3 de res")
			}

			let decoder = JSONDecoder()
			
			if let autores = try? decoder.decode([QuizItem.Author].self, from: data!){//sueta excepcion por eso try?
				DispatchQueue.main.async {
					self.autores = autores
				}
			}
		}
		t.resume()
		
	}
	
	/////////////////////////////////////////////
	
}


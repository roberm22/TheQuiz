

import Foundation

class ScoreModel: ObservableObject{
	@Published var acertadas: Set<Int>=[]
	
	init(){
		let us = UserDefaults.standard
		if let acertadas = us.object( forKey: "acertadas") as? Array<Int>{
			self.acertadas = Set(acertadas)
		}
		
	}
	
	func check(respuesta: String, quiz: QuizItem){
		let r1 = respuesta.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		let r2 = quiz.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		
		if r1==r2,
		   !acertadas.contains(quiz.id){
			acertadas.insert(quiz.id)
			let us = UserDefaults.standard
			us.set( Array<Int>(acertadas) , forKey: "acertadas")
		}
	}
	
	func acertado(_ quiz: QuizItem)->Bool{
		acertadas.contains(quiz.id)
	}
	
	func limpiar()->Void{
		acertadas.removeAll()
		UserDefaults.standard.set(Array<Int>(acertadas),forKey: "acertadas")
	}
	
	
}

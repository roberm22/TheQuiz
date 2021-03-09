

import SwiftUI

@main
struct Practica3App: App {
	
	let quizModel: QuizModel = {
		let qm = QuizModel()
		qm.load()//se podria poner en el init de QuizModel y te ahorras poner este {}
		qm.getUsers()
		return qm
	}()
	
	let imageStore = ImageStore()
	var scoreModel: ScoreModel = ScoreModel()
	let showScore: Bool = false
	
    var body: some Scene {
        WindowGroup {
			ContentView(showScore: showScore)
				.environmentObject(quizModel)
				.environmentObject(imageStore)
				.environmentObject(scoreModel)
        }
    }
}



import SwiftUI

struct Puntuacion: View {
	
	@EnvironmentObject var scoreModel: ScoreModel
	@EnvironmentObject var quizModel: QuizModel
	@Binding var showScore: Bool
	@State var showAlerta = false
	
	
	var body: some View {

		VStack{
			Text("Tu puntuacion es:")
				.bold()
				.font(.largeTitle)
				.padding()
			GeometryReader{g in
				ZStack {
					Circle().strokeBorder(colorear(scoreModel.acertadas.count), lineWidth: 30)
					Text("\(scoreModel.acertadas.count)")
						.font(.system(size: g.size.height > g.size.width ? g.size.width * 0.4: g.size.height * 0.4))
				}
			}
			
			
			Button("Resetar puntuacion"){
				self.showAlerta = true
			}
				.foregroundColor(.accentColor)
				.padding()
			Button("Volver"){
				if(showScore){showScore = false}
			}
		}
		
		
		.padding()
		.onDisappear(perform: {showScore = false})
		.alert(isPresented: $showAlerta) {
			return Alert(
				title: Text("¿Estas seguro?"),
				message: Text("Estas apunto de resetaer tu puntuacion actual que es de \(scoreModel.acertadas.count) y ponerla a 0"),
				primaryButton: .destructive(Text("Si, resetea"), action: scoreModel.limpiar),
				secondaryButton: .cancel(Text("No"))
			)
		}
		
	}
	
}
extension View {
	
	func colorear(_ puntuacion : Int) -> Color {
		var c: Color=Color.red
		if puntuacion>0{
			c=Color.yellow
		}
		if puntuacion>3 {
			c=Color.green
		}
		return c
		
	}
	
}



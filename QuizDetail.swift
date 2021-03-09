

import SwiftUI

struct QuizDetail: View {
	
	@Binding var quiz: QuizItem
	
	@EnvironmentObject var imageStore: ImageStore
	@EnvironmentObject var scoreModel: ScoreModel
	@Environment(\.verticalSizeClass) var verticalSizeClass
	@EnvironmentObject var quizModel: QuizModel
	@Binding var showScore: Bool
	
	@State var answer: String = ""
	@State var showButtonAns: String = "Enseñar respuesta"
	@State var showModal = false
	@State var showAlerta = false
	@State var flipped = false
	
	
	var body: some View {
		if showScore{
			Puntuacion(showScore: $showScore)
			
		}else{
			if verticalSizeClass != .compact{
				VStack{
					
					Text(quiz.question)
						.font(.largeTitle)
						.bold()
					
					let flipDegrees = flipped ? 180.0 : 0
					ZStack{
						Image(uiImage: imageStore.image(url: quiz.attachment?.url))
							.resizable()
							.aspectRatio(contentMode: .fit)
							.clipped()
							.clipShape(RoundedRectangle(cornerRadius: 20))
							.shadow(radius: 20 )
							.flipRotate(flipDegrees)
							.opacity(flipped ? 0.0 : 1.0)
						Text("\(quiz.answer)")
							.bold()
							.font(.largeTitle)
							.foregroundColor(Color.green)
							.flipRotate(-180 + flipDegrees)
							.opacity(flipped ? 1.0 : 0.0)
					}
					.transition(.slide)
					.animation(.ripple())
					.onTapGesture { self.flipped.toggle() }
					
					HStack{
						Text("Respuesta:")
						TextField("Escriba aqui", text: $answer, onCommit: {self.showAlerta = true})
							.textFieldStyle(RoundedBorderTextFieldStyle())
					}
					
					Button(action: {
						// Sentencias a ejecutar al pulsar el boton
						self.showAlerta = true
					}){
						// Contenido del boton
						Text("Comprobar")
					}
					//
					let google = URL(string: "https://www.google.es")!
					Link(destination: google, label: {
						Text("Necesitas ayuda?")
					})
					//
					
					Spacer()
					HStack {
						Button(action: {
							// Sentencias a ejecutar al pulsar el boton
							showModal = true
						}){
							// Contenido del boton
							VStack{
								Image(systemName: "chevron.up.circle")
									.padding()
								Text("Informacion del autor")
									.font(.subheadline)
							}
						}
					}
					.sheet(isPresented: $showModal) {
						Editor(showModal: $showModal, quiz: quiz)
					}
					
				}
				.alert(isPresented: $showAlerta) {
					if answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)==quiz.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
						scoreModel.check(respuesta: answer,quiz: quiz)
						return Alert(title: Text("Has acertado"),
									 message: Text("Continua respondiendo otras preguntas"),
									 dismissButton: .default(Text("Cerrar")))
						
					}else{
						return Alert(title: Text("Has fallado"),
									 message: Text("Sigue intentandolo"),
									 dismissButton: .default(Text("Cerrar")))
					}
				}
				.toolbar{
					HStack{
						Button(action: {
							self.quizModel.toggleFavourite(quiz)
						}){
							Image(systemName:quiz.favourite ? "heart.fill" : "heart")
								.resizable()
								.frame(width: 20, height: 20)
								.scaledToFit()
								.foregroundColor(.red)
						}

						
						Button("Puntuacion: \(scoreModel.acertadas.count)"){
							showScore = true
						}
					}
				}
				.padding()
			}else{
				VStack{
					HStack{
						let flipDegrees = flipped ? 180.0 : 0
						ZStack{
							Image(uiImage: imageStore.image(url: quiz.attachment?.url))
								.resizable()
								.aspectRatio(contentMode: .fit)
								.clipped()
								.clipShape(RoundedRectangle(cornerRadius: 20))
								.shadow(radius: 20 )
								.flipRotate(flipDegrees)
								.opacity(flipped ? 0.0 : 1.0)
							Text("\(quiz.answer)")
								.bold()
								.font(.largeTitle)
								.foregroundColor(Color.green)
								.flipRotate(-180 + flipDegrees)
								.opacity(flipped ? 1.0 : 0.0)
						}
						.transition(.slide)
						.animation(.ripple())
						.onTapGesture { self.flipped.toggle() }
						
						VStack{
							Text("\(quiz.question)")
								.font(.largeTitle)
								.bold()
							HStack{
								Text("Respuesta:")
								TextField("Escriba aqui", text: $answer, onCommit: {self.showAlerta = true})
									.textFieldStyle(RoundedBorderTextFieldStyle())
							}
							Button(action: {
								self.showAlerta = true
							}){
								Text("Comprobar")
							}
							
							
						}
						.alert(isPresented: $showAlerta) {
							if answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)==quiz.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
								scoreModel.check(respuesta: answer,quiz: quiz)
								return Alert(title: Text("Has acertado"),
											 message: Text("Continua respondiendo otras preguntas"),
											 dismissButton: .default(Text("Cerrar")))
								
							}else{
								return Alert(title: Text("Has fallado"),
											 message: Text("Sigue intentandolo"),
											 dismissButton: .default(Text("Cerrar")))
							}
						}
						.toolbar{
							HStack{
								Button(action: {
									self.quizModel.toggleFavourite(quiz)
								}){
									Image(systemName:quiz.favourite ? "heart.fill" : "heart")
										.resizable()
										.frame(width: 20, height: 20)
										.scaledToFit()
										.foregroundColor(.red)
								}

								
								Button("Puntuacion: \(scoreModel.acertadas.count)"){
									showScore = true
								}
							}
						}
						
					}
					Spacer()
					HStack(alignment: .center, spacing: 10) {
						Button(action: {
							showModal = true
						}){
							Image(systemName: "chevron.up.circle")
						}
					}
					.padding()
					.sheet(isPresented: $showModal) {
						Editor(showModal: $showModal, quiz: quiz)
					}
					
				}
				.padding()
			}
		}
		
		
	}
	
}
extension View {
	
	func flipRotate(_ degrees : Double) -> some View {
		return rotation3DEffect(Angle(degrees: degrees), axis: (x: 1.0, y: 0.0, z: 0.0))
	}
	
}
extension Animation {
	static func ripple() -> Animation {
		Animation.spring(dampingFraction: 0.5)
			.speed(2)
			.delay(0.03)
	}
}


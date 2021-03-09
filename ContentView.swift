

import SwiftUI

struct ContentView: View {
	
	@EnvironmentObject var quizModel: QuizModel
	@EnvironmentObject var scoreModel: ScoreModel
	@EnvironmentObject var imageStore: ImageStore
	@State var showScore: Bool=false
	@State var showAll: Bool = true
	
	var body: some View {
		TabView {
			NavigationView{
				List{
					Toggle(isOn: $showAll){Label("Ver todo",systemImage:"list.bullet")}
					ForEach(quizModel.quizzes.indices,id: \.self){i in
						if showAll || !scoreModel.acertado(quizModel.quizzes[i]){
							VStack{
								NavigationLink(destination: QuizDetail(quiz: $quizModel.quizzes[i], showScore: $showScore)){
									QuizRow(quiz: quizModel.quizzes[i])
								}
							}
						}
						
						
					}
				}
				.navigationTitle("P3 Quiz")
				.navigationBarItems(trailing: Button(action: {quizModel.load()},label:{Image(systemName:"arrow.clockwise")}))
				
				VStack{
					Text("Elige el quiz deslizando hacia la derecha")
					Image("swipe")
						.resizable()
						.scaledToFit()
				}
				
			}
			.tabItem {
				Image(systemName: "gamecontroller.fill")
				Text("Jugar")
			}
			VStack(alignment: .leading){
				Text("Todos los usuarios")
					.font(.largeTitle)
					.bold()
				List{
					ForEach(quizModel.autores,id: \.id){auts in
						HStack{
							Image(uiImage: imageStore.image(url: auts.photo?.url))
								.resizable()
								.frame(width: 50, height: 50)
								.clipped()
								.clipShape(Circle())
								.shadow(radius: 20 )
								.transition(.slide)
							Text(auts.profileName ?? auts.username ?? "Anonimo")
						}
					}
				}
			}
			.padding(.all)
			.tabItem {
				Image(systemName: "person.3.fill")
				Text("Usuarios")
			}
		}
		
		
	}
	
}




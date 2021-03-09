

import SwiftUI

struct Editor: View {
	
	@Binding var showModal: Bool
	var quiz: QuizItem
	@EnvironmentObject var imageStore: ImageStore
	@Environment(\.verticalSizeClass) var verticalSizeClass
	
	
	var body: some View {
		VStack {
			Text("Informacion del autor")
				.font(.largeTitle)
			Spacer()
			
			Text(quiz.author?.profileName ?? quiz.author?.username ?? "Anonimo")
				.bold()
				.font(.title)
			Image(uiImage: imageStore.image(url: quiz.author?.photo?.url))
				.resizable()
				.scaledToFit()
				.clipped()
				.clipShape(Circle())
				.shadow(radius: 20 )
				.transition(.slide)
			
			
			
			Spacer()
			Spacer()
			Button(action: {
				self.showModal = false
			}) {
				VStack{
					Image(systemName: "chevron.down.circle")
						.padding()
					if verticalSizeClass != .compact{
						Text("Volver")
							.font(.subheadline)
					}
				}
			}
		}
		.padding()
		
	}
	
}


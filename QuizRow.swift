

import SwiftUI

struct QuizRow: View {
	
	var quiz: QuizItem
	
	@EnvironmentObject var imageStore: ImageStore
	
	var body: some View {
		HStack{
			ZStack(alignment: .bottomTrailing){
				Image(uiImage: imageStore.image(url: quiz.attachment?.url))
					.resizable()
					.frame(width: 50, height: 50)
					.clipped()
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.shadow(radius: 20 )
					.overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
				if quiz.favourite{
					Image(systemName: "heart.fill")
						.foregroundColor(.red)
						.offset(x: 7, y: 5)
				}
			}
			Text(quiz.question)
			Spacer()
			
			Image(uiImage: imageStore.image(url: quiz.author?.photo?.url))
				.resizable()
				.frame(width: 30, height: 30)
				.clipped()
				.clipShape(Circle())
				.shadow(radius: 20 )
				.transition(.slide)
		}
	}
}


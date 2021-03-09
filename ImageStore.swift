

import UIKit
import Combine

class ImageStore: ObservableObject {
	
	// Cache para las imagenes.
	// La clave es un String con la url.
	@Published var imagesCache = [URL:UIImage]()
	
	let defaultImage = UIImage(named: "none")!
	let descargando = UIImage(named: "cargando")!
	let error = UIImage(named: "error")!
	
	var cancellable: AnyCancellable?
	
	init(){
		cancellable = NotificationCenter.default
			.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
			.sink(){ _ in
				print("Recibido aviso de memoria baja")
				self.imagesCache.removeAll()
			}
	}
	
	// Si la imagen pedida esta en la cache, entonces la devuelve.
	// Si la imagen no esta en la cache entonces la descarga, y
	// actualizara la cache cuando la reciba.
	func image(url: URL?) -> UIImage {
		
		guard let url = url else {
			return defaultImage
		}
		
		if let img = imagesCache[url] {
			return img
		}
		
		self.imagesCache[url] = descargando //aqui iria la imagen de descargando
		
		DispatchQueue.global().async { [self] in
			if let data = try? Data(contentsOf: url),
			   let img = UIImage(data: data) {
				
				print(url) //solo para depurar
				
				DispatchQueue.main.async {
					self.imagesCache[url] = img
				}
			}else{
				DispatchQueue.main.async {
					self.imagesCache[url] = error // imagen de error
				}
			}
		}
		
		return descargando
	}
}


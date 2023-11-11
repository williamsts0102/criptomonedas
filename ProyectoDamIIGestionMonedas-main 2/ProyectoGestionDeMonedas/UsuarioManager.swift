
import Foundation

class UsuarioManager {
    static let shared = UsuarioManager()
    
    var usuarioActual: UsuarioModel?
    
    private init() {}
}

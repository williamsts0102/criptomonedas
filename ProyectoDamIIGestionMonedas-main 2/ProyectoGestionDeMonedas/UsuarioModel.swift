
import UIKit

class UsuarioModel: NSObject {
    var idusuario: Int16?
    var nombres: String
    var apellidos: String
    var nomusu: String
    var telefono: Int32?
    var email: String
    var password: String
    
    init(idusuario: Int16?,nombres: String, apellidos: String, nomusu: String, telefono: Int32?, email: String, password: String){
        self.idusuario = idusuario
        self.nombres = nombres
        self.apellidos = apellidos
        self.nomusu = nomusu
        self.telefono = telefono
        self.email = email
        self.password = password
    }
    
    init(nombres: String, apellidos: String, nomusu: String, telefono: Int32?, email: String, password: String){
        self.nombres = nombres
        self.apellidos = apellidos
        self.nomusu = nomusu
        self.telefono = telefono
        self.email = email
        self.password = password
    }
}

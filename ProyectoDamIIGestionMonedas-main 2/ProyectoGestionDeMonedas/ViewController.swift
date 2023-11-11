import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnIngresar(_ sender: UIButton) {
        guard let usuario = txtUsuario.text, let password = txtPassword.text else {
            return
        }
        
        if validarInicioSesion(usuario: usuario, password: password) {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let pantalla = storyBoard.instantiateViewController(withIdentifier: "principal") as! PrincipalViewController
            pantalla.nombreUsuario = usuario
            self.present(pantalla, animated: true, completion: nil)
        } else {
            mostrarMensajeError()
        }
    }

    @IBAction func btnRegistrar(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let pantalla = storyBoard.instantiateViewController(withIdentifier: "nuevoUsuario") as! NuevoUsuarioViewController
        self.present(pantalla, animated: true, completion: nil)
    }
    
    func conectar()-> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contexto = delegate.persistentContainer.viewContext
        return contexto
    }
    
    func validarInicioSesion(usuario: String, password: String) -> Bool {
        let cn = conectar()
        let fetchRequest: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "nomusu == %@ AND password == %@", usuario, password)
        
        do {
            let resultados = try cn.fetch(fetchRequest)
            
            if resultados.count > 0 {
                guard let usuarioEntity = resultados.first else {
                    return false
                }
                
                let idusuario = usuarioEntity.idusuario
                let nombres = usuarioEntity.nombres ?? ""
                let apellidos = usuarioEntity.apellidos ?? ""
                let nomusu = usuarioEntity.nomusu ?? ""
                let telefono = usuarioEntity.telefono
                let email = usuarioEntity.email ?? ""
                let password = usuarioEntity.password ?? ""
                
                let usuarioData = UsuarioModel(idusuario: idusuario,
                                               nombres: nombres,
                                               apellidos: apellidos,
                                               nomusu: nomusu,
                                               telefono: telefono,
                                               email: email,
                                               password: password)
                UsuarioManager.shared.usuarioActual = usuarioData
                //Podemos acceder al usuario almacenado : UsuarioManager.shared.usuarioActual
                return true
            } else {
                return false
            }
        } catch let error as NSError {
            print("Error: ", error.localizedDescription)
            return false
        }
    }
    
    func mostrarMensajeError() {
        let alerta = UIAlertController(title: "Error", message: "Inicio de sesión inválido", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        present(alerta, animated: true, completion: nil)
    }
    
}


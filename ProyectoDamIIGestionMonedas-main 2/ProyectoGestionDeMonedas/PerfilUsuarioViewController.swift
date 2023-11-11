
import UIKit
import CoreData

class PerfilUsuarioViewController: UIViewController {

    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtNomusu: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let usuarioM = UsuarioManager.shared.usuarioActual{
            txtNombres.text = usuarioM.nombres
            txtApellidos.text = usuarioM.apellidos
            txtNomusu.text = usuarioM.nomusu
            txtTelefono.text = String(usuarioM.telefono!)
            txtEmail.text = usuarioM.email
            txtPassword.text = usuarioM.password
            
        }
        
    }
    
    @IBAction func btnGuardar(_ sender: UIButton) {
        guard let usuarioM = UsuarioManager.shared.usuarioActual else {
            return
        }
        
        usuarioM.nombres = txtNombres.text ?? ""
        usuarioM.apellidos = txtApellidos.text ?? ""
        usuarioM.nomusu = txtNomusu.text ?? ""
        usuarioM.telefono = Int32(txtTelefono.text ?? "") ?? 0
        usuarioM.email = txtEmail.text ?? ""
        usuarioM.password = txtPassword.text ?? ""
        
        // Update the user data in Core Data
        let contexto = conectar()
        let fetchRequest: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idusuario == %ld", Int16(usuarioM.idusuario!))
        
        do {
            let resultados = try contexto.fetch(fetchRequest)
            
            if let usuarioEntity = resultados.first {
                usuarioEntity.nombres = usuarioM.nombres
                usuarioEntity.apellidos = usuarioM.apellidos
                usuarioEntity.nomusu = usuarioM.nomusu
                usuarioEntity.telefono = Int32(usuarioM.telefono!)
                usuarioEntity.email = usuarioM.email
                usuarioEntity.password = usuarioM.password
                
                try contexto.save()
                mensaje()
            }
        } catch let error as NSError {
            print("Error: ", error.localizedDescription)
        }
    }

    @IBAction func btnVolverAlPrincipal(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func conectar()-> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contexto = delegate.persistentContainer.viewContext
        return contexto
    }
    
    func mensaje(){
        let alerta = UIAlertController(title: "Sistema", message: "Perfil Actualizado", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:nil))
        present(alerta, animated: true, completion:nil)
    }
    
}

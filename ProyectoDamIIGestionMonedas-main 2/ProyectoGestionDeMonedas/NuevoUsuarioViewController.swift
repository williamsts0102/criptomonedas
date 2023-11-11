import UIKit
import CoreData

class NuevoUsuarioViewController: UIViewController {
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtNomusu: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnRegistrarNuevoUsuario(_ sender: UIButton) {
        let beanUsuario = UsuarioModel(
            nombres: txtNombres.text!, apellidos: txtApellidos.text!, nomusu: txtNomusu.text!, telefono: Int32(txtTelefono.text!), email: txtEmail.text!, password: txtPassword.text!
        )
        grabar(bean: beanUsuario)
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        if let loginExit = storyboard?.instantiateViewController(withIdentifier: "login"){
            UIApplication.shared.windows.first?.rootViewController = loginExit
        }
    }
    
    func conectar()-> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contexto = delegate.persistentContainer.viewContext
        return contexto
    }
    
    func grabar(bean:UsuarioModel){
        let cn = conectar()
        let tabla = NSEntityDescription.insertNewObject(forEntityName: "Usuario", into: cn) as! Usuario
        let nuevoID = obtenerNuevoID()
        tabla.idusuario = nuevoID
        tabla.nombres = bean.nombres
        tabla.apellidos = bean.apellidos
        tabla.nomusu = bean.nomusu
        tabla.telefono = bean.telefono!
        tabla.email = bean.email
        tabla.password = bean.password
        do{
            try cn.save()
            mensaje()
        } catch let error as NSError{
            print("Error es ",error.localizedDescription)
        }
    }
    
    func mensaje(){
        let alerta = UIAlertController(title: "Sistema", message: "Usuario Registrado", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:nil))
        present(alerta, animated: true, completion:nil)
    }
    
    func obtenerNuevoID() -> Int16 {
    let cn = conectar()
    let fetchRequest: NSFetchRequest<Usuario> = Usuario.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "idusuario", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.fetchLimit = 1
    
    do {
        let resultados = try cn.fetch(fetchRequest)
        if let ultimoUsuario = resultados.first {
            return ultimoUsuario.idusuario + 1
        } else {
            return 1
        }
    } catch let error as NSError {
        print("Error: ", error.localizedDescription)
        return -1
    }
    }
    
}

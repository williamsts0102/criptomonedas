
import UIKit

class PrincipalViewController: UIViewController {

    var nombreUsuario: String?
    @IBOutlet weak var lblBienvenida: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnSalir(_ sender: UIButton) {
        UsuarioManager.shared.usuarioActual = nil
        if let loginExit = storyboard?.instantiateViewController(withIdentifier: "login"){
            UIApplication.shared.windows.first?.rootViewController = loginExit
        }
    }
    
    @IBAction func btnPerfilUsuario(_ sender: UIButton) {
        if let perfilVC = storyboard?.instantiateViewController(withIdentifier: "perfil") {
            present(perfilVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnMonedas(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let pantalla = storyBoard.instantiateViewController(withIdentifier: "listaMoneda") as! MonedaViewController
        self.present(pantalla, animated: true, completion: nil)
    }
    @IBAction func btnCoversionMonedas(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let pantalla = storyBoard.instantiateViewController(withIdentifier: "Descripcion") as! DescripcionViewController
        self.present(pantalla, animated: true, completion: nil)
    }
}

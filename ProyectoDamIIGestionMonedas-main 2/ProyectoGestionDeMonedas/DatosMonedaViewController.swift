
import UIKit
import CoreData

class DatosMonedaViewController: UIViewController {

    @IBOutlet weak var tvMoneda: UITextField!
    @IBOutlet weak var tvPais: UITextField!
    @IBOutlet weak var tvSimbolo: UITextField!
    @IBOutlet weak var tvCotizacion: UITextField!
    
    var moneda:MonedaEntity?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvMoneda.text = moneda!.nomMoneda
        tvPais.text = moneda!.paisMoneda
        tvSimbolo.text = moneda!.simboMoneda
        tvCotizacion.text = String(moneda!.cotizaMoneda)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnVolver(_ sender: Any) {
        volver()
    }
    @IBAction func btnActualizar(_ sender: UIButton) {
        
        moneda!.nomMoneda = tvMoneda.text
        moneda!.paisMoneda = tvPais.text
        moneda!.simboMoneda = tvSimbolo.text
        moneda!.cotizaMoneda = Double(tvCotizacion.text!)!
        let cn = conectar()
        do{
            try cn.save()
            mensaje()
        } catch let error as NSError{
            print("Error es ",error.localizedDescription)
        }
    }
    
    @IBAction func btnEliminar(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Sistema", message: "Seguro de eliminar esta moneda?", preferredStyle: .alert)
        let boton = UIAlertAction(title: "Si", style: .default, handler: { action in
            self.delete()
        })
        alerta.addAction(boton)
        alerta.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))
        present(alerta, animated: true, completion:nil)
    }
    
    func conectar()-> NSManagedObjectContext{
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contexto = delegate.persistentContainer.viewContext
        
        return contexto
    }
    
    func delete(){
        let cn = conectar()
        cn.delete(moneda!)
        do{
            try cn.save()
            volver()
        } catch let error as NSError{
            print("Error es ",error.localizedDescription)
        }
    }
    
    func volver(){
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
       
        let pantalla = storyBoard.instantiateViewController(withIdentifier: "listaMoneda") as! MonedaViewController
        
        self.present(pantalla, animated: true, completion: nil)
    }
    
    func mensaje(){
           let alerta = UIAlertController(title: "Sistema", message: "Moneda actualizada correctamente", preferredStyle: .alert)
           alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler:nil))
           present(alerta, animated: true, completion:nil)
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

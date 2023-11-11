
import UIKit
import CoreData

class MonedaViewController: UIViewController
,UITableViewDataSource,UITableViewDelegate
{
    

    @IBOutlet weak var txtFiltro: UITextField!
    
    @IBOutlet weak var tbMonedas: UITableView!
    
    var monedaList: [MonedaEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        listado()
        tbMonedas.dataSource = self
        tbMonedas.delegate = self
    }
    

    @IBAction func btnVolver(_ sender: UIButton) {
        
        //contendor de pantallas
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //pantalla
        let pantalla = storyBoard.instantiateViewController(withIdentifier: "principal") as! PrincipalViewController
        //direccionar a la pantalla
        self.present(pantalla, animated: true, completion: nil)
    }
    @IBAction func btnNuevo(_ sender: UIButton) {
        
        //contendor de pantallas
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //pantalla
        let pantalla = storyBoard.instantiateViewController(withIdentifier: "nuevaMoneda") as! NuevaMonedaViewController
        //direccionar a la pantalla
        self.present(pantalla, animated: true, completion: nil)
    }
    @IBAction func btnFiltrar(_ sender: UIButton) {
        
        listado()
        tbMonedas.reloadData()
    }
    
    func conectar()-> NSManagedObjectContext{
        //acceder a la clase AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contexto = delegate.persistentContainer.viewContext
        
        return contexto
    }
    
    func listado() {
        // 1. Acceder a la bd
        let cn = conectar()
        
        // 2. Acceder a todos los registros de la tabla ClienteEntity
        let request: NSFetchRequest<MonedaEntity> = MonedaEntity.fetchRequest()
        
        if let filtro = txtFiltro.text, !filtro.isEmpty {
            // 2.1 Aplicar filtro si el campo no está vacío
            let predicate = NSPredicate(format: "nomMoneda CONTAINS[c] %@ OR paisMoneda CONTAINS[c] %@", filtro, filtro)
            request.predicate = predicate
        }
        
        // 3. Enviar el contenido de 'request' al arreglo clienteList
        do {
            monedaList = try cn.fetch(request)
        } catch let error as NSError {
            print("Error: ", error.localizedDescription)
        }
        
        print("Cantidad de registros: ", monedaList.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monedaList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fila = tbMonedas.dequeueReusableCell(withIdentifier: "Cell") as!
        MonedaTableViewCell
        fila.tbMoneda.text = "Moneda : " + monedaList[indexPath.row].nomMoneda! + " " + monedaList[indexPath.row].simboMoneda!
        fila.tbPais.text = "País : "+monedaList[indexPath.row].paisMoneda!
        fila.tbCotizacion.text = "Cotización : "+String(monedaList[indexPath.row].cotizaMoneda) + "USD"

        return fila
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let relacion = segue.destination as! DatosMonedaViewController
        let pos = tbMonedas.indexPathForSelectedRow?.row
        relacion.moneda = monedaList[pos!]

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

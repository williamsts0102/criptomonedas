//
//  NuevaMonedaViewController.swift
//  ProyectoGestionDeMonedas
//
//  Created by Alexander Claude Garcia Palacios on 2/06/23.
//  Copyright © 2023 cibertec. All rights reserved.
//

import UIKit
import CoreData

class NuevaMonedaViewController: UIViewController {

    @IBOutlet weak var txtMoneda: UITextField!
    @IBOutlet weak var txtPais: UITextField!
    @IBOutlet weak var txtSimbolo: UITextField!
    @IBOutlet weak var txtCotizacion: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRegistrar(_ sender: UIButton) {
        
        let beanMoneda = MonedaModel(
            nomMoneda: txtMoneda.text!, paisMoneda: txtPais.text!, simboMoneda: txtSimbolo.text!, cotizaMoneda:     Double(txtCotizacion.text!))
        grabar(bean: beanMoneda)
        
    
    }
    
    @IBAction func btnVolver(_ sender: UIButton) {
        
        //contendor de pantallas
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //pantalla
        let pantalla = storyBoard.instantiateViewController(withIdentifier: "listaMoneda") as! MonedaViewController
        //direccionar a la pantalla
        self.present(pantalla, animated: true, completion: nil)
    }
    
    func conectar()-> NSManagedObjectContext{
        //acceder a la clase AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let contexto = delegate.persistentContainer.viewContext
        
        return contexto
    }
    
    func grabar(bean:MonedaModel){
        //1. acceder a la conexion de la bd
        let cn = conectar()
        //2. acceder a la tabla ClienteEntity
        let tabla = NSEntityDescription.insertNewObject(forEntityName: "MonedaEntity", into: cn) as! MonedaEntity
        let nuevoID = obtenerNuevoID()
        tabla.idMoneda = nuevoID
        tabla.nomMoneda = bean.nomMoneda
        tabla.paisMoneda = bean.paisMoneda
        tabla.simboMoneda = bean.simboMoneda
        tabla.cotizaMoneda = bean.cotizaMoneda!
        //4. grabar
        do{
            try cn.save()
            mensaje()
        } catch let error as NSError{
            print("Error es ",error.localizedDescription)
        }
    }
    
    func obtenerNuevoID() -> Int16 {
    let cn = conectar()
    let fetchRequest: NSFetchRequest<MonedaEntity> = MonedaEntity.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "idMoneda", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]
    fetchRequest.fetchLimit = 1
    
    do {
        let resultados = try cn.fetch(fetchRequest)
        if let ultimoMoneda = resultados.first {
            return ultimoMoneda.idMoneda + 1
        } else {
            return 1
        }
    } catch let error as NSError {
        print("Error: ", error.localizedDescription)
        return -1
    }
    }
    
    func mensaje(){
        let alerta = UIAlertController(title: "Sistema", message: "Moneda registrada exitosamente", preferredStyle: .alert)
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

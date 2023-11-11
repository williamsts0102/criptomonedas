//
//  DescripcionViewController.swift
//  ProyectoGestionDeMonedas
//
//  Created by Alexander Claude Garcia Palacios on 28/06/23.
//  Copyright © 2023 cibertec. All rights reserved.
//

import UIKit

class DescripcionViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var simbolos: [Simbolo] = []
    var filtrarSimbolo: [Simbolo] = []

    @IBOutlet weak var txtFiltro: UITextField!
    @IBOutlet weak var tvDescripcion: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvDescripcion.dataSource = self
        tvDescripcion.delegate = self
        
        buscar(moneda: "moneda")
    }
    
    func buscar(moneda: String) {
        let urlBase = "https://api.exchangerate.host/symbols"
        let urlConsulta = URL(string: urlBase)
        let request = URLRequest(url: urlConsulta!)
        let tarea = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                if let data = data, let SimboloList = try? JSONDecoder().decode(SimboloList.self, from: data) {
                    
                    let simbolo = SimboloList.symbols.values.map { $0 }
                    
                    let ordenarSimbolo = simbolo.sorted { $0.code < $1.code }

                    DispatchQueue.main.async {
                        
                        self.simbolos = ordenarSimbolo
                        self.filtrarSimbolo = ordenarSimbolo
                        self.tvDescripcion.reloadData()
                    }
                }
            }
        }
        tarea.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtrarSimbolo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvDescripcion.dequeueReusableCell(withIdentifier: "desc") as! DescripcionTableViewCell
        let simbolos = filtrarSimbolo[indexPath.row]
        cell.lblCode.text = simbolos.code
        cell.lblDescripcion.text = simbolos.description
        cell.detailTextLabel?.text = simbolos.code
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func filtrarSimbolos() {
        let searchText = txtFiltro.text?.lowercased() ?? ""

        if searchText.isEmpty {
            filtrarSimbolo = simbolos
        } else {
            filtrarSimbolo = simbolos.filter { $0.code.localizedCaseInsensitiveContains(searchText) || $0.description.localizedCaseInsensitiveContains(searchText) }
        }
    }


    @IBAction func btnBuscar(_ sender: UIButton) {
        filtrarSimbolos()
        tvDescripcion.reloadData()
    }
    @IBAction func btnVolver(_ sender: UIButton) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
       
        let pantalla = storyBoard.instantiateViewController(withIdentifier: "principal") as! PrincipalViewController
        
        self.present(pantalla, animated: true, completion: nil)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let simbolos = filtrarSimbolo[indexPath.row]
        let code = simbolos.code
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pasarCodeController = storyboard.instantiateViewController(withIdentifier: "Conversion") as! ConversionViewController
        
        pasarCodeController.code = code
        
        present(pasarCodeController, animated: true, completion: nil)
    }
    

}

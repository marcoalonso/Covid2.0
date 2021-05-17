//
//  ViewController.swift
//  StatusCovidMarco
//
//  Created by marco rodriguez on 16/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    let urlBase = "https://corona.lmao.ninja/v3/covid-19/countries/"

    @IBOutlet weak var paisBuscarTF: UITextField!
    @IBOutlet weak var imagenBanderaPais: UIImageView!
    
    @IBOutlet weak var recuperados: UILabel!
    @IBOutlet weak var muertes: UILabel!
    @IBOutlet weak var totales: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func buscar(nombrePais: String){
        let urlString = "\(urlBase)\(nombrePais)"
        print(urlString)
        if let url = URL(string: urlString) {
            //2.- Crear una URLSession
            let session = URLSession(configuration: .default)
            // 3.- Asignarle una tarea a la URLSession
            let tarea = session.dataTask(with: url) { (datos, respuesta, error) in
                if error != nil {
                    print("Error : \(error)")
                    return
                }
                
                if let datosSeguros = datos {
                    let datoString = String(data: datosSeguros, encoding: .utf8)
                    print(datoString!)
                    }
                }
            
            
            //4.-4.- Iniciar la tarea
            tarea.resume()
        }
    }

    @IBAction func buscarEstadisitcas(_ sender: UIBarButtonItem) {
        
        buscar(nombrePais: paisBuscarTF.text!)
        
    }
    
}


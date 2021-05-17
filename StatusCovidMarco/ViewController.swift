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
        paisBuscarTF.delegate = self
    }
    

//MARK:- Buscar
    func buscar(nombrePais: String){
        let urlString = "\(urlBase)\(nombrePais)"
        print(urlString)
        if let url = URL(string: urlString) {
            //2.- Crear una URLSession
            let session = URLSession(configuration: .default)
            // 3.- Asignarle una tarea a la URLSession
            let tarea = session.dataTask(with: url) { (datos, respuesta, error) in
                if error != nil {
                    print("Error : \(error?.localizedDescription)")
                    DispatchQueue.main.async {
                        let alerta = UIAlertController(title: "Error", message: "Ingresa el nombre de un pais para obtener estadísticas", preferredStyle: .alert)
                        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                        self.present(alerta, animated: true)
                    }
                    return
                } // error != nil
                
                if let datosSeguros = datos {
                    if let objCovid = self.parsearJSON(datosCovid: datosSeguros) {
                        //Actualizar UI
                        print(objCovid)
                        DispatchQueue.main.async {
                            self.totales.text = "Suma de casos : \(String(format: "%.0f" ,objCovid.total))"
                            self.muertes.text = "Total de muertes: \(String(format: "%.0f" ,objCovid.muertes))"
                            self.recuperados.text = "Recuperados: \(String(format: "%.0f" ,objCovid.recuperados))"
                            self.cargarImagenBandera(url: objCovid.imagen)
                            
                            self.paisBuscarTF.text = ""
                        }
                    } //if let objCovid
                    
                } //if let datos seguros
                //4.-4.- Iniciar la tarea
                
            }
            tarea.resume()
        }
    } // func buscar()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- Cargar imagen de API
    func cargarImagenBandera(url: String) {
        guard let imagenURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imagenURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imagenBanderaPais.image = image
            }
        }
    }
    
    //MARK:- Parsear JSON
    func parsearJSON(datosCovid: Data) -> CovidModelo? {
        let decodificador = JSONDecoder()
        do {
            let datosDecodificados = try decodificador.decode(CovidDatos.self, from: datosCovid)
            let pais = datosDecodificados.country
            let casosTotales = datosDecodificados.cases
            let muertes = datosDecodificados.deaths
            let recuperados = datosDecodificados.recovered
            let imagenURL = datosDecodificados.countryInfo.flag
            
            let objCovid = CovidModelo(nombrePais: pais, imagen: imagenURL, total: casosTotales, muertes: muertes, recuperados: recuperados)
            
            return objCovid
        } catch {
            print("Error :\(error.localizedDescription)")
            return nil
        }
        
    }
    

    @IBAction func buscarEstadisitcas(_ sender: UIBarButtonItem) {
        paisBuscarTF.resignFirstResponder()
        buscar(nombrePais: paisBuscarTF.text!)
        
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Buscar")
        paisBuscarTF.resignFirstResponder()
        buscar(nombrePais: paisBuscarTF.text!)
        return true
    }
}

//
//  ViewController.swift
//  Cinema
//
//  Created by Evosystems on 26/02/18.
//  Copyright © 2018 Evosystems. All rights reserved.
//

import UIKit
import os.log

class FilmeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var cameFromSegue: String?
    
    var movie: Filme?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let movie = movie {
            name.text = movie.nome
            image.image = movie.imagem
            
            cameFromSegue = "editMovie"
        } else {
            cameFromSegue = "addMovie"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        guard let movieName = name.text else {
            return
        }
        
        let movieImage = image.image
        
        movie = Filme(nome: movieName, imagem: movieImage)
    }
    
    
    
    @IBAction func selectImage(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        name.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        image.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}


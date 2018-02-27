//
//  FilmeTableViewController.swift
//  Cinema
//
//  Created by Evosystems on 26/02/18.
//  Copyright © 2018 Evosystems. All rights reserved.
//


import UIKit
import os.log

class FilmeTableViewController: UITableViewController {

    //MARK: Properties
    var movies = [Filme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let savedMovies = loadMovies() {
            movies += savedMovies
        } else {
            loadSampleMovies()
        }
        sortMovies()
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellFilme"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilmeTableViewCell else {
            fatalError("Cell não é instancia de FilmeTableViewCell")
        }
        
        let movie = movies[indexPath.row]
        
        cell.nome.text = movie.nome
        cell.filmeImageView.image = movie.imagem
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? ""){
        case "addMovie":
            os_log("Adding new movie.", log: OSLog.default, type: .debug)
            
        case "editMovie":
            os_log("Editing movie.", log: OSLog.default, type: .debug)
            guard let editMovieViewController = segue.destination as? FilmeViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let sender = sender as? UIButton else {
                fatalError("Unexpected Sender")
            }
            
            let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tableView)
            guard let indexPath = self.tableView.indexPathForRow(at: buttonPosition) else {
                fatalError("Cell is not in the table")
            }
            
//            guard let selectedMovieCell = sender as? FilmeTableViewCell else {
//                fatalError("Unexpected sender:")
//            }
//
//            guard let indexPath = tableView.indexPath(for: selectedMovieCell) else {
//                fatalError("The selected cell is not being displayed in the table")
//            }
            
            let selectedMovie = movies[indexPath.row]
            //passa filme para controller
            editMovieViewController.movie = selectedMovie
            editMovieViewController.indexPath = indexPath
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? FilmeViewController, let movie = sourceViewController.movie { //new movie comes from prepare - FilmeViewController
            
//            if let selectedIndexPath = tableView.indexPathForSelectedRow { //check if row is selected
            if let selectedIndexPath = sourceViewController.indexPath {
                movies[selectedIndexPath.row] = movie
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
            // Add a new meal.
            let newIndexPath = IndexPath(row: movies.count, section: 0)
            
            movies.append(movie)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            sortMovies()
            saveMovies()
        }
    }
    
    private func sortMovies(){
        movies = movies.sorted(by:  { $0.nome.uppercased() < $1.nome.uppercased() } )
    }
    
    //MARK: Private Methods
    
    private func loadSampleMovies() {
        let photoLadyBird = UIImage(named: "ladybird")
        let photoShapeOfWater = UIImage(named: "shapeofwater")
        
        guard let movieLadyBird = Filme(nome: "LadyBird", imagem: photoLadyBird) else {
            fatalError("Unable to instantiate LadyBird Movie")
        }
        guard let movieShapeOfWater = Filme(nome: "Shape of Water", imagem: photoShapeOfWater) else {
            fatalError("Unable to instantiate LadyBird Movie")
        }
        
        movies += [movieLadyBird, movieShapeOfWater]
    }
    
    private func saveMovies() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(movies, toFile: Filme.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Movies successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save movies...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMovies() -> [Filme]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Filme.ArchiveURL.path) as? [Filme]
    }
}

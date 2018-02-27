//
//  Filme.swift
//  Cinema
//
//  Created by Evosystems on 26/02/18.
//  Copyright © 2018 Evosystems. All rights reserved.
//

import UIKit
import os.log

class Filme : NSObject, NSCoding {
    
    
    private var id: Int!
    var nome: String!
    var imagem: UIImage?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("movies")
    
    //MARK: Types
    
    struct PropertyKey {
        static let nome = "nome"
        static let imagem = "imagem"
        static let id = "id"
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init?(nome: String, imagem: UIImage?) {
        guard !nome.isEmpty else {
            return nil
        }
        
        self.id = Filme.getUniqueIdentifier()
        self.nome = nome
        self.imagem = imagem
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nome, forKey: PropertyKey.nome)
        aCoder.encode(imagem, forKey: PropertyKey.imagem)
        aCoder.encode(id, forKey: PropertyKey.id)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.nome) as? String, let id = aDecoder.decodeObject(forKey: PropertyKey.id) as? Int else {
            os_log("Unable to decode the name for a Filme object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.imagem) as? UIImage
        
        self.init(nome: name, imagem: photo)
    }
}

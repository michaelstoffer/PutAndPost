//
//  ToDoController.swift
//  PutAndPost
//
//  Created by Michael Stoffer on 5/25/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

enum PushMethod: String {
    case post = "POST"
    case put = "PUT"
}

class TodoController {
    
    // MARK: Properties
    private (set) var todos: [Todo] = []
    private let baseURL = URL(string: "https://putandpost.firebaseio.com/")!
    
    func createTodo(with title: String) -> Todo {
        let todo = Todo(title: title)
        return todo
    }
    
    func push(todo: Todo, using method: PushMethod, completion: @escaping (Error?) -> Void) {
        var url = baseURL

        if method == .put {
            url.appendPathComponent(todo.identifier)
        }

        url.appendPathExtension("json")

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(todo)
        } catch {
            NSLog("Unable to encode data into object of type [Todo]: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchTodos(completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else { NSLog("No data returned from data task"); completion(NSError()); return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let decodedDictionary = try jsonDecoder.decode([String: Todo].self, from: data)
                let todos = Array(decodedDictionary.values)
                self.todos = todos
                completion(nil)
            } catch {
                NSLog("Unable to decode data into object of type [Todo]: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}

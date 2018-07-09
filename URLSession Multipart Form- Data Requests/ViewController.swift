//
//  ViewController.swift
//  URLSession Multipart Form- Data Requests
//
//  Created by Ahmet Berkay CALISTI on 28/06/2018.
//  Copyright © 2018 Ahmet Berkay CALISTI. All rights reserved.
//

import UIKit

// Before start, i want to say that multi-part form data is not a pretty thing in Swift. if you can or if you know how i would recommend using Alamofire. only reason I would say that you should use URLSession if you want full control over your networking request like if you plan on doing something very special with your networking then this but other than this I would highly recommend using Alamofire becasuse that would be just easier as supposed to 



typealias Parameters = [String: String] // I'm writing here typealias. Looks little bit cleaner

class ViewController: UIViewController {

    @IBAction func generateBoundaryButton(_ sender: Any) {
        print(generateBoundary())

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func getRequest(_ sender: Any) {
        
        // First thing we got to do is we have start off with urlsession and do we get to have url and turn into a request
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        var request = URLRequest(url: url)
        
        let boundary = generateBoundary()
        
        // Boundaries are there like parameters for the API. So that are for the server to let the server know that the entire request is consisted.
        // This is essentially telling the API what we're going to be doing what the content is consist of what kind of request we're trying to make so what we're going to type in here is going to be multipart/form-data
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // for normal get request we don't have to pass a body but you could and this would be normally where you're going to do it 
        
        let dataBody = createDataBody(withParameters: nil, media: nil, boundary: boundary)
        request.httpBody = dataBody
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print("Response: ***********")

                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()  // end of session.dataTask    // Make sure you do resume or else nothing happens
    
    }   // end of IBAction getRequest
    
    
    @IBAction func postRequest(_ sender: Any) {
        
        let parameters = ["name":"MyTestFile1233212",
                          "description":"My tutorial test file for Multi part form data uploads"]
        
        guard let mediaImage = Media(withImage: #imageLiteral(resourceName: "testimage"), forKey: "image") else { return }
        
        guard let url = URL(string: "https://api.imgur.com/3/image") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        // Boundaries are there like parameters for the API. So that are for the server to let the server know that the entire request is consisted.
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Authorization: Client-ID YOUR_CLIENT_ID for best practice, use your api-key
        request.addValue("Client-ID aff2a228afacaff", forHTTPHeaderField: "Authorization")
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print("Response: ***********")
                print(response)
            }
            
            if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            }.resume()      // Make sure you do resume or else nothing happens
    }
    
    // We gonna make a function that's going to create a random boundary for us every time
    func generateBoundary() -> String {
        
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    // We wanna make the data that we can send to the server. So we gonna create a function that's going to create the body for us. This will be optional because we're not always gonna be passing parameters
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        // When you're sending a request you have in a multi-part form request what you have to do is you have to send the parameters and you have to set different headers and different parameters and they have to all be followed by line breaks-- "\n" is usually a new line, for linux it's a "\r". we dont know which one what kind of server is working with other stuff and windows actually requires both so pass both would be universal
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        
        
        return body
    }
}


// We cant append a string into data so we're gonna do is creating an extension and be extending our data
extension Data {
    // Since this is modifying that actual data that it's referencing and mutating it we actually have to specify that this is a mutating function
   mutating func append(_ string: String) {
        
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

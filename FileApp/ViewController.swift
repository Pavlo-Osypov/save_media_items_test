//
//  ViewController.swift
//  FileApp
//
//  Created by Pavel Osypov on 29.04.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func doSomething(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            downloadVideo()
        case 2:
            downloadImage()
        default:
            break
        }
    }
    
    func downloadVideo() {
        downloadFunc(url: "https://sample-videos.com/video123/mp4/480/big_buck_bunny_480p_1mb.mp4", completion: { data, error in
            if data != nil {
                self.saveToGallery(data!, asVideo: true)
            }
        })
    }
    
    func downloadImage(){
        downloadFunc(url: "https://sample-videos.com/img/Sample-jpg-image-50kb.jpg", completion: {data, error in
            print(String(describing: data))
            if data != nil {
                self.saveToGallery(data!, asVideo: false)
            }
        })
    }
    
    func saveToGallery(_ data: Data, asVideo: Bool){
        
        if asVideo {
            
            // MARK: Define URL path`s to the file. You can change directory (see arguments for parameter "for:")
            let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = docsUrl.appendingPathComponent("myHomePronVideo.mp4") // Better change appended components ;-)
            
            do {
                // MARK: You can learn about options of writing data more, if you need.
                try data.write(to: destinationUrl, options: .atomic)
              
                // MARK: Better to check if you can save video, and if not - show Alert. Also you have to remember to use .relativePath of url.
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(destinationUrl.relativePath) {
                    UISaveVideoAtPathToSavedPhotosAlbum(destinationUrl.relativePath, nil, nil, nil)
                    
                    // Second and third params are selector to methods, which can be called after or with UISaveVideoAtPathToSavedPhotosAlbum method.
                  
                    // To try it, just uncomment this call, and comment previous call
//                    UISaveVideoAtPathToSavedPhotosAlbum(destinationUrl.relativePath,
//                                                        self, // target for selector below
//                                                        #selector(video(videoPath:didFinishSavingWithError:contextInfo:)), // method which call after video was written
//                                                        nil)
                    
                   // BUT REMEMBER: If you use methods within selector, you should add @objc before keyword 'func' (see stub1/handlevideo implementation)
                    
            
                    // Third selector has to have following signature
                    // MARK: SIGNATURE
//                        - (void)               video: (NSString *) videoPath
//                            didFinishSavingWithError: (NSError *) error
//                                         contextInfo: (void *) contextInfo;
                }
                
            } catch (let error) {
                debugPrint(error)
            }


        } else {
            let image = UIImage(data: data)!
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
    }
    
    @objc func stub1(){
        debugPrint("STUB METHOD")
    }
    
    @objc func video(videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer){
        // Do something with all this shit
        debugPrint(videoPath, error, contextInfo)
    }
    
}

func downloadFunc(url: String, completion: (@escaping (Data?, Error?) -> ()) = {_,_ in}) {
        
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: URL(string: url)!) { (downloadedData, response, error) in
        
        if let err = error {
            completion(nil, err)
        }
        
        if let tempData = downloadedData {
            completion(tempData, nil)
        }
        
        debugPrint((response as! HTTPURLResponse).statusCode)
        
        // Major changes

        // This will be first change
        
//        debugPrint((response as! HTTPURLResponse).statusCode)
        
        // This will be a second changes
        
        // Third changes and test
    }.resume()
    
    
    
}

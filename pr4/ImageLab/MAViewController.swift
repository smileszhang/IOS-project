//
//  ViewController.swift
//  ImageLab
//
//  Created by Eric Larson
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import AVFoundation

class MAViewController: UIViewController   {

    //MARK: Class Properties
    var filters : [CIFilter]! = nil
    var videoManager:VideoAnalgesic! = nil
    let pinchFilterIndex = 2
    var detector:CIDetector! = nil
    
    @IBOutlet weak var faceGestureLabel: UILabel!
    
    //MARK: ViewController Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = nil
        self.setupFilters()
        
        self.videoManager = VideoAnalgesic.sharedInstance
        self.videoManager.setCameraPosition(position: AVCaptureDevice.Position.front)
        
        // create dictionary for face detection
        // HINT: you need to manipulate these proerties for better face detection efficiency
        let optsDetector = [CIDetectorAccuracy:CIDetectorAccuracyHigh, CIDetectorTracking:true, CIDetectorEyeBlink:true, CIDetectorSmile:true] as [String : Any]
        
        // setup a face detector in swift
        self.detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: self.videoManager.getCIContext(), // perform on the GPU is possible
            options: (optsDetector as [String : AnyObject]))
        
        self.videoManager.setProcessingBlock(newProcessBlock: self.processImage)
       
        
        if !videoManager.isRunning{
            videoManager.start()
        }
    
    }
    
  

      //MARK: Setup filtering
    func setupFilters(){
        filters = []
        let filterHole = CIFilter(name:"CIHoleDistortion")!
        filterHole.setValue(10, forKey: "inputRadius")
        filters.append(filterHole)
        
       /* let filterDistortion = CIFilter(name:"CIPinchDistortion")!
        filterDistortion.setValue(0, forKey: "inputScale")
        filterDistortion.setValue(10, forKey: "inputRadius")
        filters.append(filterDistortion)
         */
        
        let filterPinch = CIFilter(name:"CITorusLensDistortion")!
        filterPinch.setValue(50, forKey: "inputWidth")
        filterPinch.setValue(80, forKey: "inputRadius")
        filterPinch.setValue(0.8, forKey: "inputRefraction")
        filters.append(filterPinch)
        
    }
    //MARK: Apply filters and apply feature detectors
    func applyFiltersToFaces(inputImage:CIImage,features:[CIFaceFeature])->CIImage{
        var retImage = inputImage
        var filterCenter = CGPoint()
        var filterCenter1 = CGPoint()
        var filterCenter2 = CGPoint()
        var filterCenter3 = CGPoint()
        
        
        for f in features {
           DispatchQueue.main.async{
                if(f.leftEyeClosed){
                    self.faceGestureLabel.text = "Left eye closed"
                }
                else if(f.rightEyeClosed){
                    self.faceGestureLabel.text = "Right eye closed"
                }
                else if(f.hasSmile){
                    self.faceGestureLabel.text = "You are smiling"
                }
                else {
                    self.faceGestureLabel.text = "Nothing happened"
                } 
            }
 
  
            //set where to apply filter
            filterCenter1.x = f.leftEyePosition.x
            filterCenter1.y = f.leftEyePosition.y
            filterCenter2.x = f.rightEyePosition.x
            filterCenter2.y = f.rightEyePosition.y
            filterCenter3.x = f.mouthPosition.x
            filterCenter3.y = f.mouthPosition.y
            filterCenter.x = f.bounds.midX
            filterCenter.y = f.bounds.midY
            filters[0].setValue(retImage, forKey: kCIInputImageKey)
            filters[0].setValue(CIVector(cgPoint: filterCenter1), forKey: "inputCenter")
             retImage = filters[0].outputImage!
            filters[0].setValue(retImage, forKey: kCIInputImageKey)
            filters[0].setValue(CIVector(cgPoint: filterCenter2), forKey: "inputCenter")
             retImage = filters[0].outputImage!
            filters[0].setValue(retImage, forKey: kCIInputImageKey)
            filters[0].setValue(CIVector(cgPoint: filterCenter3), forKey: "inputCenter")
             retImage = filters[0].outputImage!
            filters[1].setValue(retImage, forKey: kCIInputImageKey)
            filters[1].setValue(CIVector(cgPoint: filterCenter), forKey: "inputCenter")
            retImage = filters[1].outputImage!

            
            //do for each filter (assumes all filters have property, "inputCenter")
           /* for filt in filters{
                filt.setValue(retImage, forKey: kCIInputImageKey)
                filt.setValue(CIVector(cgPoint: filterCenter1), forKey: "inputCenter")

                // could also manipualte the radius of the filter based on face size!
                retImage = filt.outputImage!
            }
            for filt in filters{
                filt.setValue(retImage, forKey: kCIInputImageKey)
                filt.setValue(CIVector(cgPoint: filterCenter2), forKey: "inputCenter")
                
                // could also manipualte the radius of the filter based on face size!
                retImage = filt.outputImage!
            }
            for filt in filters{
                filt.setValue(retImage, forKey: kCIInputImageKey)
                filt.setValue(CIVector(cgPoint: filterCenter3), forKey: "inputCenter")
                
                // could also manipualte the radius of the filter based on face size!
                retImage = filt.outputImage!
            } */

        }

        return retImage
    }
    
    func getFaces(img:CIImage) -> [CIFaceFeature]{
        // this ungodly mess makes sure the image is the correct orientation
        let optsFace = [CIDetectorImageOrientation:self.videoManager.ciOrientation, CIDetectorEyeBlink:true, CIDetectorSmile:true] as [String : Any]
        // get Face Features
        return self.detector.features(in: img, options: optsFace) as! [CIFaceFeature]
        
    }
    
    //MARK: Process image output
    func processImage(inputImage:CIImage) -> CIImage{
        
        // detect faces
        let f = getFaces(img: inputImage)
        
        // if no faces, just return original image
        if f.count == 0 { return inputImage }
        
        //otherwise apply the filters to the faces
        return applyFiltersToFaces(inputImage: inputImage, features: f)
       
    }
    

   
}


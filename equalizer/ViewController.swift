//
//  ViewController.swift
//  equalizer
//
//  Created by Sergio Sebastián Arriagada on 25/4/17.
//  Copyright © 2017 Hashdog. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    @IBOutlet weak var highPass: UIView!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowPass: UIView!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var gainView: UIView!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var midPass: UIView!
    @IBOutlet weak var midLabel: UILabel!
    
    let mic = AKMicrophone()
    var filter: AKLowPassFilter?
    var volume: Double = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up
        AKSettings.defaultToSpeaker = true
        
        //mic and filter
        mic.volume = volume
        
        let lowFilter = AKLowPassFilter(mic, cutoffFrequency: 100)
        let midFilter = AKEqualizerFilter(lowFilter, centerFrequency: 50, bandwidth: 120)
        let highFilter = AKHighPassFilter(midFilter, cutoffFrequency: 10)

        //high filter
        highLabel.text = String(format: "%.1f", highFilter.cutoffFrequency)
        highPass.addSubview(AKPropertySlider(
            property: "HighPass",
            value: highFilter.cutoffFrequency, minimum: 0, maximum: 100,
            color: AKColor.blue
        ) { sliderValue in
            highFilter.cutoffFrequency = sliderValue
            self.highLabel.text = String(format: "%.1f", sliderValue)
        })
        
        //low filter
        lowLabel.text = String(format: "%.1f", lowFilter.cutoffFrequency)
        lowPass.addSubview(AKPropertySlider(
            property: "LowPass",
            value: lowFilter.cutoffFrequency, minimum: 0, maximum: 800,
            color: AKColor.green
        ) { sliderValue in
            lowFilter.cutoffFrequency = sliderValue
            self.lowLabel.text = String(format: "%.1f", sliderValue)
        })
        
        // mid filter
        midLabel.text = String(format: "%.1f", midFilter.centerFrequency)
        midPass.addSubview(AKPropertySlider(
            property: "MidPass",
            value: midFilter.centerFrequency, minimum: 0, maximum: 500,
            color: AKColor.gray
        ) { sliderValue in
            midFilter.centerFrequency = sliderValue
            self.midLabel.text = String(format: "%.1f", sliderValue)
        })
        
        // gain
        gainLabel.text = String(format: "%.1f", mic.volume)
        gainView.addSubview(AKPropertySlider(
            property: "Gain",
            value: mic.volume, minimum: 10, maximum: 300,
            color: AKColor.red
        ) { sliderValue in
            self.mic.volume = sliderValue
            self.gainLabel.text = String(format: "%.1f", sliderValue)
        })
        
        // setting filters
        AudioKit.output = highFilter
        
        //starting
        mic.start()
        
        //filter?.start()
        AudioKit.start()
    }
}


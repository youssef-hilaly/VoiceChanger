//
//  RecordSoundViewController.swift
//  VoiceChanger
//
//  Created by Youssef Hilaly on 20/12/1400 AP.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordLable: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
	
    func UIConfg(_ enable : Bool){
        stopRecordingButton.isEnabled = enable
        recordButton.isEnabled = !enable
        if enable{
            recordLable.text = "Recording"
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
        }
        else{
            recordLable.text = "Tab To Record"
            
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
        }
        
    }

    @IBAction func recordAudio(_ sender: Any) { UIConfg(true) }
    
    @IBAction func stopRecord(_ sender: Any) { UIConfg(false) }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)	
        }else{
            print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let PlaySoundCV = segue.destination as! PlaySoundsViewController
            let RecordedAudioURL = sender as! URL
            PlaySoundCV.recordedAudioURL = RecordedAudioURL
        }
    }
}


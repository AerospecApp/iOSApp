//
//  ContentView.swift
//  Todo
//
//  Created by Tran Tran on 2/21/21.
//

import SwiftUI
import Amplify
import AmplifyPlugins
import Combine

struct ContentView: View {
    @State var todoSubscription: AnyCancellable?
    @ObservedObject var bleManager = BLEManager()
    
    @State private var txt = ""
    @State private var txtSend: String = ""
    @State private var connectedTo: String = "Not Connected to ESP32."
    @State private var dis = true
    @State var color = Color.white
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack (spacing: 10) {
                Text("Bluetooth Devices")
                    //.font(.largeTitle)
                    .font(.custom("AmericanTypewriter", size: 28))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.blue)
                List(bleManager.peripherals) { peripheral in
                    HStack {
                        Text(String(peripheral.name))
                            .font(.custom("AmericanTypewriter", size: 12))
                            .foregroundColor(Color.white)
                            .onTapGesture {
                                let ret = bleManager.connectTo(peripheralID: peripheral.id)
                                if ret == "ESP32" {
                                    color = Color.green
                                    connectedTo = "Connected to ESP32! Say hi:"
                                    dis = false
                                }
                        }
                        Spacer()
                        Text(String(peripheral.rssi))
                            .font(.custom("AmericanTypewriter", size: 12))
                            .foregroundColor(.white)
                    }
                }.frame(height: 250)
                .listRowBackground(Color.black)
                VStack(alignment: .leading){
                    Text(connectedTo)
                        .foregroundColor(color)
                        .frame(alignment: .leading)
                        .font(.custom("AmericanTypewriter", size: 15))
                    TextField("Send Text to ESP32", text:$txtSend)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.custom("AmericanTypewriter", size: 15))
                        .disabled(dis)
                    Text("Send")
                        .onTapGesture {
                            if !dis {
                                bleManager.sendText(text: txtSend)
                                print("Sending")
                                hideKeyboard()
                            }
                        }.frame(alignment: .leading)
                        .font(.custom("AmericanTypewriter", size: 15))
                }.padding()
                                
                VStack(alignment: .leading) {
                    Text("DynamoDB's Log:")
                        .foregroundColor(.yellow)
                        .font(.custom("AmericanTypewriter", size: 10))
                    MultilineTextView(text: $txt)
                }.padding()
                
                Spacer()
     
                HStack {
                    VStack (alignment: .leading, spacing: 10) {
                        Button(action: {
                            self.bleManager.startScanning()
                        }) {
                            Text("Start Scanning")
                                .font(.custom("AmericanTypewriter", size: 15))
                        }
                        Button(action: {
                            self.bleManager.stopScanning()
                        }) {
                            Text("Stop Scanning")
                                .font(.custom("AmericanTypewriter", size: 15))
                        }
                    }.padding()
                    
                    Spacer()
                    
                    VStack (alignment: .trailing, spacing: 10) {
                        Text("STATUS")
                            //.font(.headline)
                            .font(.custom("AmericanTypewriter", size: 15))
                            .frame(alignment: .trailing)
                        // Status goes here
                        if bleManager.isSwitchedOn {
                            Text("Bluetooth is switched on")
                                .foregroundColor(.green)
                                .font(.custom("AmericanTypewriter", size: 15))
                        }
                        else {
                            Text("Bluetooth is NOT switched on")
                                .foregroundColor(.red)
                                .frame(alignment: .trailing)
                                .font(.custom("AmericanTypewriter", size: 15))
                        }
                    }.padding()
                    /*VStack (spacing: 10) {
                        Button(action: {
                            print("Start Advertising")
                        }) {
                            Text("Start Advertising")
                        }
                        Button(action: {
                            print("Stop Advertising")
                        }) {
                            Text("Stop Advertising")
                        }
                    }.padding()*/
                }
            }.onAppear {
                performOnAppear()
            }
        }
        
    }
    func subscribeTodos() {
       self.todoSubscription
           = Amplify.DataStore.publisher(for: Todo.self)
               .sink(receiveCompletion: { completion in
                   print("Subscription has been completed: \(completion)")
               }, receiveValue: { mutationEvent in
                   print("Subscription got this value: \(mutationEvent)")
                   do {
                     let todo = try mutationEvent.decodeModel(as: Todo.self)
                     switch mutationEvent.mutationType {
                     case "create":
                       print("Created: \(todo)")
                        txt = "Created:\n - Name: \(todo.name).\n - Priority: \(String(describing: todo.priority))\n - Description: \(String(describing: todo.description))"
                     case "update":
                       print("Updated: \(todo)")
                        txt = "Updated:\n - Name: \(todo.name).\n - Priority: \(String(describing: todo.priority))\n - Description: \(String(describing: todo.description))"
                     case "delete":
                       print("Deleted: \(todo)")
                        txt = "Deleted:\n - Name: \(todo.name).\n - Priority: \(String(describing: todo.priority))\n - Description: \(String(describing: todo.description))"
                     default:
                       break
                     }
                   } catch {
                     print("Model could not be decoded: \(error)")
                   }
               })
    }
    func performOnAppear() {
        subscribeTodos()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = false
        view.isUserInteractionEnabled = true
        view.adjustsFontForContentSizeCategory = true
        view.textColor = UIColor.gray
        view.font = UIFont(name: "AmericanTypewriter", size: 9)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

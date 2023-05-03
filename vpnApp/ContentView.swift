//
//  ContentView2.swift
//  vpnApp
//
//  Created by Adam Zabloudil on 4/29/23.
//

import SwiftUI
import NetworkExtension
import AVVPNService

struct ContentView: View {
    @State private var isConnected = false
    @State private var currentServer: ServerInfo? = nil
    @State private var selectedOption = ServerOption.nj

    let NjServer = ServerInfo(IP: "157.230.217.77", city: "New Jersey, United States", credentials: AVVPNCredentials.IPSec(server: "157.230.217.77", username: "vpnuser", password: "biP3MiZmsHnEeSq4", shared: "DTgke3KVeknE9Arb8ms9"))
    let SinServer = ServerInfo(IP: "159.223.34.143", city: "Singapore, Singapore", credentials: AVVPNCredentials.IPSec(server: "159.223.34.143", username: "vpnuser", password: "mscq3DwsM6gPVMjy", shared: "gMzqqc7GVeAhKbpFjdTu"))
    let LonServer = ServerInfo(IP: "165.22.116.166", city: "London, United Kingdom", credentials: AVVPNCredentials.IPSec(server: "165.22.116.166", username: "vpnuser", password: "xarV8qKdws5Yw93G", shared: "y2t2pDHC3wejbJydZ4B8"))
    let AmsServer = ServerInfo(IP: "64.227.67.163", city: "Amsterdam, Netherlands", credentials: AVVPNCredentials.IPSec(server: "64.227.67.163", username: "vpnuser", password: "zxp8yyqMAEx5zKEK", shared: "zgiwLvT7KEe8TpCdVsRS"))
    let BlrServer = ServerInfo(IP: "165.232.182.9", city: "Bangalore, India", credentials: AVVPNCredentials.IPSec(server: "165.232.182.9", username: "vpnuser", password: "CihzgkvMM3PhfUAB", shared: "4ncxDUnVRwb55zw3HBha"))
    
    let serverOptions: [ServerOption: ServerInfo] = [
        .nj: ServerInfo(IP: "157.230.217.77", city: "New Jersey, United States", credentials: AVVPNCredentials.IPSec(server: "157.230.217.77", username: "vpnuser", password: "biP3MiZmsHnEeSq4", shared: "DTgke3KVeknE9Arb8ms9")),
        .sin: ServerInfo(IP: "159.223.34.143", city: "Singapore, Singapore", credentials: AVVPNCredentials.IPSec(server: "159.223.34.143", username: "vpnuser", password: "mscq3DwsM6gPVMjy", shared: "gMzqqc7GVeAhKbpFjdTu")),
        .lon: ServerInfo(IP: "165.22.116.166", city: "London, United Kingdom", credentials: AVVPNCredentials.IPSec(server: "165.22.116.166", username: "vpnuser", password: "xarV8qKdws5Yw93G", shared: "y2t2pDHC3wejbJydZ4B8")),
        .ams: ServerInfo(IP: "64.227.67.163", city: "Amsterdam, Netherland", credentials: AVVPNCredentials.IPSec(server: "64.227.67.163", username: "vpnuser", password: "zxp8yyqMAEx5zKEK", shared: "zgiwLvT7KEe8TpCdVsRS")),
        .blr: ServerInfo(IP: "165.232.182.9", city: "Bangalore, India", credentials: AVVPNCredentials.IPSec(server: "165.232.182.9", username: "vpnuser", password: "CihzgkvMM3PhfUAB", shared: "4ncxDUnVRwb55zw3HBha"))
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height:40)
                Button(action: {
                    if isConnected {
                        AVVPNService.shared.disconnect()
                    } else {
                        if let server = currentServer {
                            print("SERVER SUCCESS")
                            switchToServer(server)
                        } else {
                            print("SERVER ERROR")
                            switchToServer(NjServer)
                        }
                    }
                    isConnected.toggle()
                }) {
                    if isConnected == false {
                        ZStack {
                            Circle()
                                .foregroundColor(.purple)
                                .shadow(radius: 4, x: 3, y: 3)
                            Image(systemName: "lock.open")
                                .resizable()
                                .frame(width: 70, height: 75)
                                .foregroundColor(.white)
                                
                        }
                    } else {
                        ZStack {
                            Circle()
                                .foregroundColor(.white)
                                .shadow(radius: 5, x: 4, y: 4)
                            Image(systemName: "lock")
                                .resizable()
                                .frame(width: 50, height: 75)
                                .foregroundColor(.purple)
                                
                        }
                    }
                }
                .padding([.leading, .trailing, .bottom])
                
                VStack {
                    Text(isConnected ? "Connected" : "Disconnected")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)
                        .padding()
                    
                    Picker("Select a server", selection: $selectedOption) {
                        ForEach(ServerOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }.pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedOption) { newValue in
                        if isConnected {
                            AVVPNService.shared.disconnect()
                            isConnected = !isConnected
                        }
                        currentServer = serverOptions[newValue]
                    }
                    .accentColor(.purple)
                    .padding([.bottom])
                    
                    if isConnected == true {
                        Text(currentServer!.IP)
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .bold()
                        Text(currentServer!.city)
                            .multilineTextAlignment(.center)
                            .font(.title3)
                            .bold()
                        Link("Check IP Online", destination: URL(string: "https://www.whatismyip.com")!)
                            .padding([.top])
                            .tint(.purple)
                    }
                }
                .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("SwiftVPN")
        }
    }
    
    func switchToServer(_ server: ServerInfo) {
        if isConnected {
            AVVPNService.shared.disconnect()
        }
        currentServer = server
        AVVPNService.shared.connect(credentials: server.credentials) { error in
            if let error = error {
                print("AVPN ERROR")
                print(error)
            } else {
                print("NP AVPN ERROR")
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ServerInfo {
    let IP: String
    let city: String
    let credentials: AVVPNCredentials
}

enum ServerOption: String, CaseIterable {
    case nj = "New Jersey"
    case sin = "Singapore"
    case lon = "London"
    case ams = "Amsterdam"
    case blr = "Bangalore"
}

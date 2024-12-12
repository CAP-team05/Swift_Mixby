//
//  AnalogClockView.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//


import SwiftUI

struct AnalogClockView: View {
    @State var isDark = false
    var body: some View {
            
            Home(isDark: $isDark)
                .navigationBarHidden(true)
                .preferredColorScheme(isDark ? .dark : .light)
    }
}

struct AnalogClockView_Previews: PreviewProvider {
    static var previews: some View {
        AnalogClockView()
    }
}

struct Home : View {
    
    @Binding var isDark : Bool
    var width = UIScreen.main.bounds.width-100
    @State var curreant_Time = Time(min: 0, sec: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()
    
    var body: some View{
        
        VStack{
            
//            HStack{
//                
//                Text("Analog Clock")
//                    .font(.title)
//                    .fontWeight(.heavy)
//                
//                Spacer(minLength: 0)
//                
//                Button(action: {isDark.toggle()}) {
//                    
//                    Image(systemName: isDark ? "sun.min.fill" : "moon.fill")
//                        .font(.system(size: 22))
//                        .foregroundColor(isDark ? .black : .white)
//                        .padding()
//                        .background(Color.primary)
//                        .clipShape(Circle())
//                }
//            }
//            .padding()
//            
//            Spacer(minLength: 0)
            
            ZStack{
                
                
                Image("moon")
                    .resizable()
                    .frame(width: width/2.5, height: width/2.5)
                    .opacity(0.8)
                
                
                Circle()
                    .fill(Color.black.opacity(0.2))
                    .frame(width: width/2.5, height: width/2.5)
                
                // Seconds And Min dots....
                
//                ForEach(0..<60,id: \.self){i in
//                    
//                    Rectangle()
//                        .fill(Color.white)
//                        // 60/12 = 5
//                        .frame(width: 2, height: (i % 5) == 0 ? 15 : 5)
//                        .offset(y: (width - 110) / 2)
//                        .rotationEffect(.init(degrees: Double(i) * 6))
//                        .shadow(color: Color.mixbyShadow, radius: 4, y: 4)
//                }
                
                // Sec...
                
                Rectangle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 2, height: (width - 230) / 2)
                    .offset(y: -(width - 220) / 4)
                    .rotationEffect(.init(degrees: Double(curreant_Time.sec) * 6))
                    .shadow(color: Color.mixbyShadow, radius: 4, y: 4)
                
                // Min
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 4, height: (width - 220) / 2)
                    .offset(y: -(width - 200) / 4)
                    .rotationEffect(.init(degrees: Double(curreant_Time.min) * 6))
                    .shadow(color: Color.mixbyShadow, radius: 4, y: 4)
                
                // Hour
                
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 4.5, height: (width - 240) / 2)
                    .offset(y: -(width - 240) / 4)
                    .rotationEffect(.init(degrees: (Double(curreant_Time.hour) + (Double(curreant_Time.min) / 60)) * 30))
                
                // Center Circle...
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 15, height: 15)
            }
            //.background(Color.black)
            .frame(width: width - 80, height: width - 80)
            
            // getting Locale Region Name...
            
//            Text(Locale.current.localizedString(forRegionCode: Locale.current.regionCode!) ?? "")
//                .font(.largeTitle)
//                .fontWeight(.heavy)
//                .padding(.top,35)
            
//            Text(getTime())
//                .font(.system(size: 45))
//                .fontWeight(.heavy)
//                .padding(.top,10)
            
            Spacer(minLength: 0)
        }
        .onAppear(perform: {
            
            let calender = Calendar.current
            
            let min = calender.component(.minute, from: Date())
            let sec = calender.component(.second, from: Date())
            let hour = calender.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)){
                
                self.curreant_Time = Time(min: min, sec: sec, hour: hour)
            }
        })
        .onReceive(receiver) { (_) in
            
            let calender = Calendar.current
            
            let min = calender.component(.minute, from: Date())
            let sec = calender.component(.second, from: Date())
            let hour = calender.component(.hour, from: Date())
            
            withAnimation(Animation.linear(duration: 0.01)){
                
                self.curreant_Time = Time(min: min, sec: sec, hour: hour)
            }
        }
    }
    
    func getTime()->String{
        
        let format = DateFormatter()
        format.timeZone = TimeZone.current
        format.dateFormat = "hh:mm a"
        
        return format.string(from: Date())
    }
}

// Calculating time...

struct Time {
    var min : Int
    var sec : Int
    var hour : Int
}

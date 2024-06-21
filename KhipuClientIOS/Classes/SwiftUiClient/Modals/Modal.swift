import SwiftUI

@available(iOS 15.0, *)
struct ModalView: View {
    var title: String?
    var message: String?
    var primaryButtonLabel: String
    var primaryButtonAction: () -> Void
    var primaryButtonColor: Color?
    var secondaryButtonLabel: String?
    var secondaryButtonAction: (() -> Void)?
    var secondaryButtonColor: Color?
    var icon: Image?
    var iconColor: Color?
    var imageSrc: String?
    var countDown: Int?
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack (spacing: 20) {

            if let icon = icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(iconColor)
                    .padding(.top)
            }
            if let title = title{
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            if let imageSrc = imageSrc {
                Spacer()
                SVGImage(
                    url: imageSrc.starts(with: "http") ? imageSrc : nil,
                    svg: imageSrc.starts(with: "http") ? nil : imageSrc,
                    width: 100,
                    height: 103,
                    percentage: 40
                )
                .padding()
                Spacer()
            }
            if let timer = countDown {
                TimerView(time: timer).padding(.top)
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    self.primaryButtonAction()
                }, label: {
                    Text(primaryButtonLabel)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(primaryButtonColor ?? Color.blue)
                        .cornerRadius(12)
                })
                if let secondaryButtonLabel = secondaryButtonLabel {
                    Button(action: {
                        self.secondaryButtonAction?()
                    }, label: {
                        Text(secondaryButtonLabel)
                            .font(.headline)
                            .foregroundColor(Color.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(secondaryButtonColor ?? Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    })
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
        .fixedSize(horizontal: false, vertical: true)
    }

}

@available(iOS 13.0, *)
struct CountdownTimerView: View {
    @State private var timeRemaining: Int
    @State private var timerActive = false
    @State private var timer: Timer? = nil

    init(time: Int) {
        self._timeRemaining = State(initialValue: time)
        startTimer()
    }

    var body: some View {
        VStack {
            Text((timeString(time: timeRemaining)))
            .padding(.bottom)
        }
        .onAppear {
            startTimer()
        }
    }

    func startTimer() {
        if timerActive {
            timer?.invalidate()
            timer = nil
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.invalidate()
                    self.timer = nil
                    self.timerActive = false
                }
            }
        }
        timerActive.toggle()
    }

    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

@available(iOS 13.0.0, *)
struct TimerView: View {
    let time: Int
    var body: some View {
        CountdownTimerView(time: time)
    }
}

@available(iOS 15.0.0, *)
struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(
            title: "¿Sigues ahí?",
            message: "Continua con tu pago \n ¡La sesión está a punto de cerrarse!",
            primaryButtonLabel: "Continuar pago",
            primaryButtonAction: {},
            primaryButtonColor: ThemeManager().selectedTheme.colors.primary,
            icon: Image(systemName: "clock.fill"),
            iconColor: ThemeManager().selectedTheme.colors.tertiary,
            imageSrc: "https://khenshin-web.s3.amazonaws.com/img/ufo.svg",
            countDown: 60)
        .environmentObject(ThemeManager())
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

@available(iOS 13.0.0, *)
struct CountdownTimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(time: 60)
    }
}

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
        VStack (spacing: Dimens.Spacing.large) {
            
            if let icon = icon {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: Dimens.Frame.slightlyLarger, height: Dimens.Frame.slightlyLarger)
                    .foregroundColor(iconColor)
                    .padding(.top)
            }
            if let title = title{
                Text(title)
                    .font(themeManager.selectedTheme.fonts.font(style: .bold, size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.top)
                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
            }
            if let message = message {
                Text(message)
                    .font(themeManager.selectedTheme.fonts.font(style: .semiBold, size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(themeManager.selectedTheme.colors.onSurface)
                    .padding()
            }
            if let imageSrc = imageSrc {
                Spacer()
                AsyncImage(url: URL(string:imageSrc)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: Dimens.Frame.extremelyLarge, height: Dimens.Frame.extremelyLarge)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                
                Spacer()
            }
            if let timer = countDown {
                TimerView(time: timer).padding(.top)
            }
            
            HStack(spacing: Dimens.Spacing.extraMedium) {
                Button(action: {
                    self.primaryButtonAction()
                }, label: {
                    Text(primaryButtonLabel)
                        .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 18))                       .foregroundColor(themeManager.selectedTheme.colors.onPrimary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(themeManager.selectedTheme.colors.primary )
                        .cornerRadius(12)
                })
                if let secondaryButtonLabel = secondaryButtonLabel {
                    Button(action: {
                        self.secondaryButtonAction?()
                    }, label: {
                        Text(secondaryButtonLabel)
                            .font(themeManager.selectedTheme.fonts.font(style: .medium, size: 18))                            .foregroundColor(themeManager.selectedTheme.colors.onSecondary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(themeManager.selectedTheme.colors.secondary)
                            .cornerRadius(Dimens.CornerRadius.medium)
                            .overlay(
                                RoundedRectangle(cornerRadius: Dimens.CornerRadius.medium)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    })
                }
            }
        }
        .padding()
        .background(themeManager.selectedTheme.colors.background)
        .cornerRadius(Dimens.CornerRadius.large)
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
            imageSrc: "https://s3.amazonaws.com/static.khipu.com/icon/ufo.png",
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

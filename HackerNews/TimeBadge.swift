import SwiftUI

struct TimeBadge: View {
    
    let time: String
    
    var body: some View {
        Text(time)
            .font(.caption)
            .fontWeight(.bold)
            .padding(8)
            .foregroundColor(.white)
            .background(Color.orange)
            .cornerRadius(6)
    }
    
}

struct TimeBadge_Previews: PreviewProvider {
    
    static var previews: some View {
        TimeBadge(time: "3 minutes ago")
    }
    
}

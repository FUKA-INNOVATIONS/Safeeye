//
//  CurtainTCComponent.swift
//  Safeye
//
//  Created by dfallow on 9.4.2022.
//

import SwiftUI

struct CurtainTCComponent: View {
    var trustedContact: ProfileModel
    var translationManager = TranslationService.shared

    
    var body: some View {
        HStack {
            AvatarComponent(size: 50)
            Spacer()
            Text(trustedContact.fullName)
            Spacer()
            BasicButtonComponent(label: translationManager.focusBtn) {
                
            }
            .modifier(TCItemModifier())
        }
        
    }
}

//struct CurtainTCComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        CurtainTCComponent()
//    }
//}

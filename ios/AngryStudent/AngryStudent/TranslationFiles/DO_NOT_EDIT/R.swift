// THIS FILE IS GENERATED BY TOOL, PLEASE DO NOT EDIT!

import Foundation

struct R {

    enum string : String {
        /// Room %1$@
        case common_room_name
        /// CREATE
        case create_event_create_btn
        /// Description
        case create_event_description_lbl
        /// Select icon
        case create_event_icon_lbl
        /// Name
        case create_event_name_lbl
        /// My event
        case create_event_name_placeholder
        /// Create event - %1$@
        case create_event_title
        /// Other events
        case events_list_other
        /// Owning
        case events_list_owning
        /// Events
        case events_list_tab_bar
        /// Events
        case events_list_title
        /// Friends
        case friends_tab_bar
        /// Friends
        case friends_title
        /// MiNI - 1st floor
        case main_map_first_floor
        /// MiNI - parter
        case main_map_parter
        /// MiNI - 2nd floor
        case main_map_second_floor
        /// Map
        case main_map_tab_bar
        /// test jest ok
        case test
        /// integer %d, napis %@
        case test_parameters1
        /// napis %2$d, integer %1$@
        case test_parameters2
    }

    enum plurals : String {
        case test_plurals

        subscript(quantity: Int) -> String {
            return String.localizedStringWithFormat(NSLocalizedString(self.rawValue, comment: ""), quantity)
        }
    }

}


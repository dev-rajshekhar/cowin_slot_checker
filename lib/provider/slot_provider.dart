// import 'package:cowin_slot_checker/repo/state_repo.dart';
// import 'package:flutter/material.dart';
// import 'package:cowin_slot_checker/model/slots_response.dart';
// import 'package:cowin_slot_checker/network_module/api_response.dart';

// class SlotsProvider extends ChangeNotifier {
//   StateRepo _stateRepo;
//   ApiResponse<SlotsResponse> _slots;

//   ApiResponse<SlotsResponse> get slots => _slots;

//   SlotsProvider() {
//     _stateRepo = StateRepo();
//   }

//   Future fetchSlots(Map<String, String> param) async {
//     _slots = ApiResponse.loading('loading... ');
//     notifyListeners();
//     try {
//       SlotsResponse album = await _stateRepo.fetchAllSlotsByDistrict(param);
//       _slots = ApiResponse.completed(album);
//       notifyListeners();
//     } catch (e) {
//       _slots = ApiResponse.error(e.toString());
//       notifyListeners();
//     }
//   }

//   Future fetchSlotsByPin(Map<String, String> param) async {
//     _slots = ApiResponse.loading('loading... ');
//     notifyListeners();
//     try {
//       SlotsResponse album = await _stateRepo.fetchAllSlotsByPin(param);
//       _slots = ApiResponse.completed(album);
//       notifyListeners();
//     } catch (e) {
//       _slots = ApiResponse.error(e.toString());
//       notifyListeners();
//     }
//   }
// }

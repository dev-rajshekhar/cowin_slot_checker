import 'package:cowin_slot_checker/constants/api_constant.dart';
import 'package:cowin_slot_checker/model/district_response.dart';
import 'package:cowin_slot_checker/model/slots_response.dart';
import 'package:cowin_slot_checker/model/state_response.dart';
import 'package:cowin_slot_checker/network_module/http_client.dart';

class StateRepo {
  Future<StateResponse> fetchAlbumDetails() async {
    final response = await HttpClient.instance.fetchData(ApiConstant.GET_STATE);
    return StateResponse.fromJson(response);
  }

  Future<DistrictResponse> fetchAllDistricts(String stateId) async {
    final response = await HttpClient.instance
        .fetchData(ApiConstant.GET_DISTRICTS + "/$stateId");
    return DistrictResponse.fromJson(response);
  }

  Future<SlotsResponse> fetchAllSlotsByDistrict(
      Map<String, String> param) async {
    final response = await HttpClient.instance
        .fetchData(ApiConstant.GET_SLOTS_BY_DISTRICTS, params: param);

    return SlotsResponse.fromJson(response);
  }

  Future<SlotsResponse> fetchAllSlotsByPin() async {
    final response =
        await HttpClient.instance.fetchData(ApiConstant.GET_DISTRICTS);

    return SlotsResponse.fromJson(response);
  }
}

class DistrictResponse {
  List<Districts> districts;
  int ttl;

  DistrictResponse({this.districts, this.ttl});

  DistrictResponse.fromJson(Map<String, dynamic> json) {
    if (json['districts'] != null) {
      districts = [];
      json['districts'].forEach((v) {
        districts.add(new Districts.fromJson(v));
      });
    }
    ttl = json['ttl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.districts != null) {
      data['districts'] = this.districts.map((v) => v.toJson()).toList();
    }
    data['ttl'] = this.ttl;
    return data;
  }
}

class Districts {
  int stateId;
  int districtId;
  String districtName;
  String districtNameL;

  Districts(
      {this.stateId, this.districtId, this.districtName, this.districtNameL});

  Districts.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    districtId = json['district_id'];
    districtName = json['district_name'];
    districtNameL = json['district_name_l'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['district_id'] = this.districtId;
    data['district_name'] = this.districtName;
    data['district_name_l'] = this.districtNameL;
    return data;
  }
}

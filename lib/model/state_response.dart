class StateResponse {
  List<States> states;
  int ttl;

  StateResponse({this.states, this.ttl});

  StateResponse.fromJson(Map<String, dynamic> json) {
    if (json['states'] != null) {
      states = [];
      json['states'].forEach((v) {
        states.add(new States.fromJson(v));
      });
    }
    ttl = json['ttl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.states != null) {
      data['states'] = this.states.map((v) => v.toJson()).toList();
    }
    data['ttl'] = this.ttl;
    return data;
  }
}

class States {
  int stateId;
  String stateName;

  States({this.stateId, this.stateName});

  States.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    stateName = json['state_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    return data;
  }
}

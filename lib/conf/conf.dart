import 'dart:convert';
import 'dart:io';

class Conf {
  String resettiProfile = "";
  String resettiPath = "";
  String benchPath = "";
  String multimcPath = "";
  String path = "";
  int benchCount = 0;
  List<dynamic> instances = [];
  List<dynamic> instanceDirs = [];
  Conf(String path) {
    this.path = path;
    if (File("$path/conf.json").existsSync()) {
      String contents = File("$path/conf.json").readAsStringSync();
      var conf = json.decode(contents);
      resettiProfile = conf['resetti_profile'];
      resettiPath = conf['resetti_path'];
      multimcPath = conf['multimc_path'];
      instances = conf['instances'];
      benchPath = conf['bench_path'];
      benchCount = conf['bench_count'];
      instanceDirs = conf['instance_dirs'];
    } else {
      resettiProfile = "";
      resettiPath = "None";
      multimcPath = "None";
      benchPath = "None";
      benchCount = 2000;
      instances = [];
      String defaultConf = '''
          {
              "resetti_profile": "$resettiProfile",
              "resetti_path": "$resettiPath",
              "bench_path": "$benchPath",
              "bench_count": $benchCount,
              "multimc_path": "$multimcPath",
              "instances": [],
              "instance_dirs": []
          }
          ''';
      Process.runSync('mkdir', ['-p', path]);
      Process.runSync('touch', ['$path/conf.json']);
      File('$path/conf.json').writeAsStringSync(defaultConf);
    }
  }

  void write(String key, dynamic value) {
    String contents = File('$path/conf.json').readAsStringSync();
    var conf = json.decode(contents);
    conf[key] = value;
    String newConf = json.encode(conf);
    File('$path/conf.json').writeAsStringSync(newConf);
  }

  void update() {
    String contents = File('$path/conf.json').readAsStringSync();
    var conf = json.decode(contents);
    instances = conf['instances'];
    instanceDirs = conf['instance_dirs'];
    resettiPath = conf['resetti_path'];
    resettiProfile = conf['resetti_profile'];
    multimcPath = conf['multimc_path'];
    benchPath = conf['bench_path'];
    benchCount = conf['bench_count'];
    String newConf = json.encode(conf);
    File("$path/conf.json").writeAsStringSync(newConf);
  }
}

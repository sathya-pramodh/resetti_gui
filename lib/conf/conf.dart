import 'dart:convert';
import 'dart:io';

class Conf {
  String resettiProfile = "";
  String resettiPath = "";
  String resettiArgs = "";
  String benchPath = "";
  String benchArgs = "";
  String multimcPath = "";
  String path = "";
  int benchCount = 0;
  List<dynamic> instances = [];
  List<dynamic> instanceDirs = [];
  Conf(this.path) {
    if (File("$path/conf.json").existsSync()) {
      String contents = File("$path/conf.json").readAsStringSync();
      var conf = json.decode(contents);
      resettiProfile = conf['resetti_profile'];
      resettiPath = conf['resetti_path'];
      resettiArgs = conf['resetti_args'];
      multimcPath = conf['multimc_path'];
      instances = conf['instances'];
      benchPath = conf['bench_path'];
      benchCount = conf['bench_count'];
      instanceDirs = conf['instance_dirs'];
      benchArgs = conf['bench_args'];
    } else {
      String defaultConf = '''
          {
              "resetti_profile": "$resettiProfile",
              "resetti_path": "$resettiPath",
              "resetti_args": "$resettiArgs",
              "bench_path": "$benchPath",
              "bench_count": $benchCount,
              "bench_args": "$benchArgs",
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
    resettiArgs = conf['resetti_args'];
    resettiProfile = conf['resetti_profile'];
    multimcPath = conf['multimc_path'];
    benchPath = conf['bench_path'];
    benchCount = conf['bench_count'];
    benchArgs = conf['bench_args'];
    String newConf = json.encode(conf);
    File("$path/conf.json").writeAsStringSync(newConf);
  }
}

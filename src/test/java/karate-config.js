function fn () {
    var envFile = read('classpath:data/env_data.json');
    var env = karate.env;
    karate.log('Karate Environment: ', env);
    karate.set('coreUserName', karate.properties['userName']);
    karate.set('corePass', karate.properties['pass']);
    karate.set('dbName', karate.properties['dbName']);

    if(!env) {
        env = 'uat'; //default env
    }
    var config = envFile[env];
    karate.configure('headers', { Accept: 'application/json' });
    // karate.log(config);

    // Set svc as services folder
    karate.set('svc', 'classpath:services/')
    karate.set('connectDB', 'classpath:rakkar/common/ConnectDB.feature@')

    // Check and create a data_{{env}}.json if not exist
    var dataFile = 'src/test/java/data/data_'+env+'.json';
    karate.set('dataEnv', dataFile);
    var myClass = Java.type('util.FileUtils');
    karate.set('fileUtils', myClass);

    if (!myClass.isFileExist(dataFile)) {
        karate.log('Data file does not exist: ', dataFile);
        karate.callSingle('classpath:rakkar/createData/GetData.feature', config);
        karate.callSingle('classpath:rakkar/createData/WriteDataFile.feature');
        java.lang.Thread.sleep(5000);
    } else {
        karate.log('Data file exist: ', dataFile);
        myClass.DataListMap = karate.read('classpath:data/data_'+env+'.json');
    }
    karate.set('dataSet', myClass.DataListMap); 

    var dataToEncrypt = config.requesterInfo.requesterPasscode;
    // karate.log(dataToEncrypt);
    var iv = config.requesterInfo.id.replaceAll('-','').slice(0, 16);
    var requesterPasscode = karate.exec(`node aes.js encrypt ${dataToEncrypt} MIIBCgKCAQEAniN5htNE5JBVkA5M3Tfi ${iv}`);
    karate.set('requesterPasscode', requesterPasscode);

    return config;
}

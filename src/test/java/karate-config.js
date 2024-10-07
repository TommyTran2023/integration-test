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

    // Set svc as services folder
    karate.set('svc', 'classpath:services/')
    karate.set('connectDB', 'classpath:rakkar/common/ConnectDB.feature@')

    // Check and create a data_{{env}}.json if not exist
    var dataFile = 'src/test/java/data/data_'+env+'.json';
    karate.set('dataEnv', dataFile);
    var fileUtils = Java.type('util.FileUtils');
    karate.set('fileUtils', fileUtils);

    if (!fileUtils.isFileExist(dataFile)) {
        karate.log('Data file does not exist: ', dataFile);
        karate.callSingle('classpath:rakkar/createData/GetData.feature', config);
        karate.callSingle('classpath:rakkar/createData/WriteDataFile.feature');
        java.lang.Thread.sleep(5000);
    } else {
        karate.log('Data file exist: ', dataFile);
        fileUtils.DataListMap = karate.read('classpath:data/data_'+env+'.json');
    }
    karate.set('dataSet', fileUtils.DataListMap); 
    
    // Load secret
    var secret = karate.read("file:" + karate.properties['secret']);
    karate.set('privateKey', secret);

    // Set encrypted passcode
    var requestPass = config.requesterInfo.requesterPasscode;
    var approverPass = config.approverInfo.approverPasscode;
    
    var requestIv = config.requesterInfo.userId.replaceAll('-','').slice(0, 16);
    var approverIv = config.approverInfo.userId.replaceAll('-','').slice(0, 16);

    var requesterPasscode = karate.exec(`node aes.js encrypt ${requestPass} ${secret.secret} ${requestIv}`);
    var approverPasscode = karate.exec(`node aes.js encrypt ${approverPass} ${secret.secret} ${approverIv}`);

    karate.set('requesterPasscode', requesterPasscode);
    karate.set('approverPasscode', approverPasscode);


    return config;
}

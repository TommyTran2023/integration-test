function fn () {
    var envFile = read('classpath:data/env_data.json');
    var env = karate.env;
    karate.log('Karate Environment: ', env);
    if(!env){
        env = 'uat'; //default env
    }
    var config = {
                  baseURL: envFile.uat.baseUrl,
                  requesterUsername: envFile.uat.requesterUsername,
                  approvalUsername: envFile.uat.approvalUsername,
                  adminUsername: envFile.uat.adminUsername
              };
    if (env == 'qa'){
        config.baseURL = envFile.qa.baseUrl;
        config.requesterUsername = envFile.qa.requesterUsername;
        config.approvalUsername = envFile.qa.approvalUsername;
        config.adminUsername = envFile.qa.adminUsername;
    }
    karate.configure('headers', { Accept: 'application/json' });
    return config;
}
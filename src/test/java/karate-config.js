function fn () {
    var envFile = read('classpath:data/env_data.json');
    var env = karate.env;
    karate.log('Karate Environment: ', env);
    if(!env){
        env = 'uat'; //default env
    }
    var config = envFile[env];
    karate.configure('headers', { Accept: 'application/json' });
    karate.log(config);
    return config;
}
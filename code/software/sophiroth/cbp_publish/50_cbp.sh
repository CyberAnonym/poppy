v_ServiceName=`echo $v_JobName|awk -F "_" '{print $NF}'`
f_dynamicVariable(){
case $v_ServiceName in
        message)
        v_JarName=message-template.jar
        ;;
        configcenter)
        v_JarName=configserver.jar
        ;;
        zuul)
        v_JarName=com.shenmintech.zuul-0.0.1-SNAPSHOT.jar
        ;;
        food)
        v_JarName=food-template.jar
        ;;
        kc)
        v_JarName=kc-template.jar
        ;;
        mc)
        v_JarName=mc-template.jar
        ;;
        authority)
        v_JarName=com.shenmintech.authority-0.0.1-SNAPSHOT.jar
        ;;
        filesystem)
        v_JarName=com.shenmintech.filesystem-0.0.1-SNAPSHOT.jar
        ;;
        dynamic)
        v_JarName=com.shenmintech.dynamic-0.0.1-SNAPSHOT.jar
        ;;
        eureka)
        v_JarName=com.shenmintech.eureka.server-0.0.1-SNAPSHOT.jar
        ;;
        test)
        v_JarName=com.shenmintech.test-0.0.1-SNAPSHOT.jar
        ;;
        schedule)
        v_JarName=com.shenmintech.schedule-0.0.1-SNAPSHOT.jar
        ;;
esac
}
f_dynamicVariable


v_user=alvin
v_destIP=50.alv.pub
v_mainDIR=/data/sprintcloud_sm
v_localDIR=/opt/jenkins/workspace
v_port=7272
v_ServiceName=`echo $v_JobName|awk -F "_" '{print $NF}'`
v_TmpJar=/tmp/$v_JarName

ssh -p $v_port $v_user@$v_destIP "mkdir -p $v_mainDIR/$v_ServiceName"
scp -P$v_port $v_localDIR/$v_JobName/target/$v_JarName $v_user@$v_destIP:$v_TmpJar

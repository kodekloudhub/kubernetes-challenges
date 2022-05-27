#### To set the user credentials
```
kubectl config set-credentials martin --client-key=/root/martin.key --client-certificate=/root/martin.crt
```

#### To create a context 'developer' 
```
kubectl config set-context developer --cluster=kubernetes --user=martin
```

#### To set the context
```
kubectl config use-context developer
```

#### To create a role from the command line utility
```
kubectl create role developer-role --resource=pods,svc,pvc --verb="*" -n development
```

#### To create a rolebinding from the command line utility
```
kubectl create rolebinding developer-rolebinding --role=developer-role --user=martin -n development
```


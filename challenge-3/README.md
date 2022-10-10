# Challenge 3

Deploy the given architecture to `vote` namespace.  Find the lab [here](https://kodekloud.com/topic/kubernetes-challenge-3/)

As ever, the order you create the resources is significant, and largely governed by the direction of the arrows in the diagram. There are a lot of inter-dependencies in this one, and things will break if deployed in the wrong order. Since all the applications are going to depend on their data sources, we do those first, followed by the services that front the data sources, then the rest.

Note that some of the deployments may take up to a minute to start fully and reach running state.

You should study the manifests provided in the repo carefully and understand how they provide what the question asks.

1.  <details>
    <summary>vote (namespace)</summary>

    </br>Create a new namespace: name = 'vote'

    ```bash
    kubectl create namespace vote
    ```

    </details>

1.  <details>
    <summary>db-deployment</summary>

    </br>Create new deployment. name: 'db-deployment'

    Apply the [manifest](./db-deployment.yml)

    </details>

1.  <details>
    <summary>db-service</summary>

    </br>Create new service: 'db'

    Apply the [manifest](./db-service.yml)

    </details>

1.  <details>
    <summary>redis-deployment</summary>

    </br>Create new deployment, name: 'redis-deployment'

    Apply the [manifest](./redis-deployment.yml)

    </details>

1.  <details>
    <summary>redis-service</summary>

    </br>New Service, name = 'redis'

    Apply the [manifest](./redis-service.yml)

    </details>

1.  <details>
    <summary>worker</summary>

    </br>Create new deployment. name: 'worker'

    Apply the [manifest](./worker.yml)

    </details>

1.  <details>
    <summary>vote-deployment</summary>

    </br>Create a deployment: name = 'vote-deployment'

    Apply the [manifest](./vote-deployment.yml)

    </details>

1.  <details>
    <summary>vote-service</summary>

    </br>Create a new service: name = vote-service

    Apply the [manifest](./vote-service.yml)

    </details>

1.  <details>
    <summary>result-deployment</summary>

    </br>Create a new service: name = result-deployment

    Apply the [manifest](./result-deployment.yml)

    </details>

1.  <details>
    <summary>result-service</summary>

    </br>Create a new service: name = result-service

    Apply the [manifest](./result-service.yml)

    </details>

# Automate the lab in a single script!

As DevOps engineers, we love everything to be automated!

What we can do here is to clone this repo down to the lab to get all the YAML manifest solutions, then apply them in the correct order. When the script completes, you can press the `Check` button and the lab will be complete!

Since there is a strong dependency between all the deployments, i.e. worker will fail if its data sources aren't ready, we use a shell function to wait for a pod to be running given the name of its deployment.

You should study the manifests provided in the repo carefully and understand how they provide what the question asks.

<details>
<summary>Automation Script</summary>

Paste this entire script to the lab terminal, sit back and enjoy!

```bash
{
wait_deployment() {
    deployment=$1

    echo "Waiting up to 120s for $deployment deployment to be available..."
    kubectl wait -n vote deployment $deployment --for condition=Available=True --timeout=120s

    if [ $? -ne 0 ]
    then
        echo "The deployment did not rollout correctly. Please reload the lab and try again."
        echo "If the issue persists, please report it in Slack in kubernetes-challenges channel"
        echo "https://kodekloud.slack.com/archives/C02LS58EGQ4"
        echo "Press CTRL-C to exit"
        read x
    fi
}

git clone https://github.com/kodekloudhub/kubernetes-challenges.git

kubectl create namespace vote

kubectl apply -f kubernetes-challenges/challenge-3/db-deployment.yml

wait_deployment db-deployment

kubectl apply -f kubernetes-challenges/challenge-3/db-service.yml

kubectl apply -f kubernetes-challenges/challenge-3/redis-deployment.yml

wait_deployment redis-deployment

kubectl apply -f kubernetes-challenges/challenge-3/redis-service.yml

kubectl apply -f kubernetes-challenges/challenge-3/worker.yml

wait_deployment worker

kubectl apply -f kubernetes-challenges/challenge-3/result-deployment.yml

wait_deployment result-deployment

kubectl apply -f kubernetes-challenges/challenge-3/result-service.yml

kubectl apply -f kubernetes-challenges/challenge-3/vote-deployment.yml

wait_deployment vote-deployment

kubectl apply -f kubernetes-challenges/challenge-3/vote-service.yml

echo -e "\nAutomation complete. Press the Check button.\n"
}
```

</details>
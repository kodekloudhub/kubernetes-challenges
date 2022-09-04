# Challenge 1

Deploy the given architecture diagram for implementing a `Jekyll SSG`. Find the lab [here](https://kodekloud.com/topic/kubernetes-challenge-1/).


As ever, the order you create the resources is significant, and governed by the direction of the arrows in the diagram.

For this challenge, all the namespaced resources are to be created in the existing namespace `development`. When writing YAML manifests, you must include `namespace: development` in the `metadata` section

Solve in the following order:

All are solved by creating a YAML manifest for each resource as directed by the details as you select each icon, with the exception of 7 and 8 which are done with `kubectl config`. Expand solutions below by clicking on the arrowhead icons.

You should study the manifests provided in the repo carefully and understand how they provide what the question asks.

1. jekyll-pv - Nothing to do here. The PV is pre-created.
1.  <details>
    <summary>jekyll-pvc</summary>

    Apply the [manifest](./jekyll-pvc.yaml)

    </details>

1.  <details>
    <summary>jekyll</summary>

    Apply the [manifest](./jekyll-pod.yaml)

    The pod will take at least 30 seconds to initialize.

    </details>

1.  <details>
    <summary>jekyll-node-service</summary>

    Apply the [manifest](./jekyll-node-service.yaml)

    </details>

1.  <details>
    <summary>developer-role</summary>

    Apply the [manifest](./developer-role.yaml)

    </details>

1.  <details>
    <summary>developer-rolebinding</summary>

    Apply the [manifest](./developer-rolebinding.yaml)

    </details>

1.  <details>
    <summary>kube-config</summary>

    ```bash
    kubectl config set-credentials martin --client-certificate ./martin.crt --client-key ./martin.key
    kubectl config set-context developer --cluster kubernetes --user martin
    ```

    </details>

1.  <details>
    <summary>martin</summary>

    ```bash
    kubectl config use-context developer
    ```

    </details>

# Automate the lab in a single script!

As DevOps engineers, we love everything to be automated!

What we can do here is to clone this repo down to the lab to get all the YAML manifest solutions, then apply them in the correct order. The script also waits for the Jekyll pod to be fully started before progressing, thus when the script completes, you can press the `Check` button and the lab will be complete!

<details>
<summary>Automation Script</summary>

Paste this entire script to the lab terminal, sit back and enjoy!

```bash
{
    # Clone this repo to get the manifests
    git clone --depth 1 https://github.com/kodekloudhub/kubernetes-challenges.git

    ### PVC
    kubectl apply -f kubernetes-challenges/challenge-1/jekyll-pvc.yaml

    ### POD
    kubectl apply -f kubernetes-challenges/challenge-1/jekyll-pod.yaml

    # Wait for pod to be running
    echo "Waiting for Jekyll pod to be running. If it remains pending for more than 2 minutes, there may be an issue. Press CTRL-C and check the pod."

    phase="Pending"
    while [ "$phase" = "Pending" ]
    do
        sleep 2
        phase=$(kubectl get pod -n development jekyll -o jsonpath='{.status.phase}')
        echo "Pod status: $phase"
    done

    if [ "$phase" = "Running" ]
    then
        ### Service
        kubectl apply -f kubernetes-challenges/challenge-1/jekyll-node-service.yaml

        ### Role
        kubectl apply -f kubernetes-challenges/challenge-1/developer-role.yaml

        ## RoleBinding
        kubectl apply -f kubernetes-challenges/challenge-1/developer-rolebinding.yaml

        ## Martin

        kubectl config set-credentials martin --client-certificate ./martin.crt --client-key ./martin.key
        kubectl config set-context developer --cluster kubernetes --user martin

        ## kube-config

        kubectl config use-context developer

        echo -e "\n\nAutomation complete! Press the Check button.\n"
    else
        echo "The pod did not start correctly. Please reload the lab and try again."
        echo "If the issue persists, please report it in Slack in kubernetes-challenges channel"
        echo "https://kodekloud.slack.com/archives/C02LS58EGQ4"
        cd ~
    fi
}

```

</details>







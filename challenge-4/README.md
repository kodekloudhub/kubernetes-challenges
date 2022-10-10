# Challenge 4

Build a highly available Redis Cluster based on the given architecture diagram. Find the lab [here](https://kodekloud.com/topic/kubernetes-challenge-4/).

As ever, the order you create the resources is significant, and largely governed by the direction of the arrows in the diagram.

You should study the manifests provided in the repo carefully and understand how they provide what the question asks.


1.  <details>
    <summary>redis01 thru redis06 - create directories</summary>

    </br>Using a shell for loop, we can create all of these at once.

    1.  <details>
        <summary>Determine the name of the worker node</summary>

        ```bash
        kubectl get nodes
        ```

        </details>

    1.  <details>
        <summary>ssh to the worker node</summary>

        ```bash
        ssh node01
        ```
        </details>

    1.  <details>
        <summary>Create the required directories</summary>

        ```bash
        for i in $(seq 1 6) ; do mkdir "/redis0$i" ; done
        ```

        Verify

        ```bash
        ls -ld /redis*
        ```

        Now exit ther worker node with `CTRL-D` or `exit`

        </details>
    </details>

1.  <details>
    <summary>redis01 thru redis06 - create persistent volumes</summary>

    You could create a manifest for each persistent volume individually, but that's repetetive and time consuming, so let's instead use the power of Linux for loops, [heredocs](https://linuxize.com/post/bash-heredoc/) and variable substitution!

    The manifest will be generated once for each value 1 thru 6 and each one piped into `kubectl` which will apply it.

    ```bash
    for i in $(seq 1 6)
    do
    cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: redis0$i
    spec:
      capacity:
        storage: 1Gi
      volumeMode: Filesystem
      accessModes:
        - ReadWriteOnce
      hostPath:
        path: /redis0$i
    EOF
    done
    ```

    Or, you could apply the [manifest](./pv-cluster.yaml) provided which demonstrates the use of `list` when applying multiple resources, however it is a lot of repetition!

    </details>

1.  <details>
    <summary>redis-cluster-service</summary>

    </br>Because the redis cluster is a StatefulSet, it is necessay for a service to exist first, as the StatefulSet manifest refers to it by name.

    Apply the [manifest](./redis-cluster-service.yaml)

1.  <details>
    <summary>redis-cluster</summary>

    </br>Apply the [manifest](./redis-statefulset.yaml)

    </details>

1.  <details>
    <summary>redis-cluster-config</summary>

    </br>Now we boot the redis cluster. We have to execute a command at the first replica in the StatefulSet, i.e. `redis-cluster-0`. The command to run is provided in the question, however what it does is to get the IPs of all the cluster member pods using jsonpath and provides it as arguments to the cluster initialization tool.

    It will ask you if you want to proceeed. Type `yes`

    ```bash
    kubectl exec -it redis-cluster-0 -- redis-cli --cluster create --cluster-replicas 1 \
        $(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 {end}')
    ```

    </detail>

# Automate the lab in a single script!

As DevOps engineers, we love everything to be automated!

What we can do here is to clone this repo down to the lab to get all the YAML manifest solutions, then apply them in the correct order. When the script completes, you can press the `Check` button and the lab will be complete!


<details>
<summary>Automation Script</summary>

Paste this entire script to the lab terminal, sit back and enjoy!

```bash
{
  ### Clone this repo to get the manifests
  git clone --depth 1 https://github.com/kodekloudhub/kubernetes-challenges.git

  ### Create PV directories on node01
  # See https://www.cyberciti.biz/faq/unix-linux-execute-command-using-ssh/
  ssh node01 'for i in $(seq 1 6) ; do mkdir "/redis0$i" ; done'

  ### Create PVs
  for i in $(seq 1 6)
  do
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis0$i
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /redis0$i
EOF
  done

  ### Create service
  kubectl apply -f kubernetes-challenges/challenge-4/redis-cluster-service.yaml

  ### Create redis-cluster
  kubectl apply -f kubernetes-challenges/challenge-4/redis-statefulset.yaml

  # It takes about a minute for all pods to be running
  echo "Waiting up to 120s for all pods in statefulset to start"
  sleep 15 # First pod needs to appear before following wait will work
  kubectl wait --for jsonpath='{.status.readyReplicas}'=6 statefulset/redis-cluster --timeout 105s

  if [ $? -ne 0 ]
  then
      echo "The statefulset did not start correctly. Please reload the lab and try again."
      echo "If the issue persists, please report it in Slack in kubernetes-challenges channel"
      echo "https://kodekloud.slack.com/archives/C02LS58EGQ4"
      cd ~
      echo "Press CTRL-C to exit"
      read x
  fi

  ### Cluster config.
  # Here we have to automatically answer the question, so we pipe "yes" into the command
  echo "yes" | kubectl exec -it redis-cluster-0 -- redis-cli --cluster create --cluster-replicas 1 \
      $(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 {end}')

  echo -e "\nAutomation complete. Press the Check button.\n"
}
```
</details>
# Challenge 2

Please note that the first two parts of this challenge are more CKA focused.

This 2-Node Kubernetes cluster is broken! Troubleshoot, fix the cluster issues and then deploy the objects according to the given architecture diagram to unlock our `Image Gallery`!!  Find the lab [here](https://kodekloud.com/topic/kubernetes-challenge-2/)

As ever, the order you create the resources is significant, and largely governed by the direction of the arrows in the diagram.

You should study the manifests provided in the repo carefully and understand how they provide what the question asks.

1.  <details>
    <summary>controlplane</summary>

    </br>Fix the controlplane node. This has three subtasks. The order to do them is atucally the *reverse* order in which they are listed!

    1.  <details>
        <summary>kubeconfig = <code>/root/.kube/config</code>, User = <code>kubernetes-admin</code> Cluster: Server Port = <code>6443</code></summary>

        </br>Before we can execute any `kubectl` commands, we must fix the kubeconfig. The server port is incorrect and should be `6443`. Edit this in `vi` and save.

        ```bash
        vi .kube/config
        ```

        Change the following line to have the correct port `6443`, save and exit vi.

        ```yaml
            server: https://controlplane:6433
        ```
        </details>

    1.  <details>
        <summary>Fix kube-apiserver. Make sure its running and healthy.</summary>

        </br>The file referenced by the `--client-ca-file` argument to the API server doesn't exist. Edit the API server manifest and correct this.

        ```bash
        ls -l /etc/kubernetes/pki/*.crt
        # Notice that the correct certificate is ca.crt
        vi /etc/kubernetes/manifests/kube-apiserver.yaml
        ```

        Change the following line to refer to the correct certificate file, save and exit vi.

        ```yaml
            - --client-ca-file=/etc/kubernetes/pki/ca-authority.crt
        ```

        Now wait for the API server to restart. This may take a minute or so. You can run the following to check if the container has been created. Press `CTRL-C` to escape from the following command.

        ```bash
        watch crictl ps
        ```

        If it still hasn't started, then give it a nudge by restarting the kubelet.

        ```bash
        systemctl restart kubelet
        ```

        ...then run the crictl command again. If you see it starting and stopping, then you've made an error in the manifest that you need to fix.

        You should also be aware of how to [diagnose a crashed API server](https://github.com/kodekloudhub/community-faq/blob/main/docs/diagnose-crashed-apiserver.md).

        </details>

    1.  <details>
        <summary>Master node: coredns deployment has image: <code>registry.k8s.io/coredns/coredns:v1.8.6</code></summary>

        </br>Run the following:

        ```bash
        kubectl get pods -n kube-system
        ```

        You will see that CoreDNS has ImagePull errors, because the container image is incorrect. To fix this, run the following, update the `image:` to that specificed in the question, save and exit

        ```bash
        kubectl edit deployment -n kube-system coredns
        ```

        ---- OR ----

        Edit the image directly

        ```bash
        kubectl set image deployment/coredns -n kube-system \
            coredns=registry.k8s.io/coredns/coredns:v1.8.6
        ```

        Now re-run the `get pods` command above (or use `watch` with it) until the coredns pods have recycled and there are two healthy pods.
        </details>
    </details>

1.  <details>
    <summary>node01</summary>

    </br>node01 is ready and can schedule pods? Run the following:

    ```bash
    kubectl get nodes
    ```

    We can see that `node01` is in state `Ready,SchedulingDisabled`. This usually means that it is cordoned, so...

    ```bash
    kubectl uncordon node01
    ```

    </details>

1.  <details>
    <summary>web</summary>

    </br>Copy all images from the directory '/media' on the controlplane node to '/web' directory on node01. Here we are setting up the content of the directory on `node01` which will ultimately be served as a hostpath persistent volume. It's a straght forward copy with ssh (scp).

    ```bash
    scp /media/* node01:/web
    ```

    </details>

1.  <details>
    <summary>data-pv</summary>

    <br>Create new PersistentVolume = 'data-pv'.</br>Apply the [manifest](./fileserver-pv.yaml) with `kubectl apply -f`

    </details>

1.  <details>
    <summary>data-pvc</summary>

    <br>Create new PersistentVolumeClaim = 'data-pvc'</br>Apply the [manifest](./fileserver-pvc.yaml)

    </details>

1.  <details>
    <summary>gop-file-server</summary>

    <br>Create a pod for file server, name: 'gop-file-server'</br>Apply the [manifest](./fileserver-pod.yaml)

    </details>

1.  <details>
    <summary>gop-fs-service</summary>

    <br>New Service, name: 'gop-fs-service'</br>Apply the [manifest](./fileserver-svc.yaml)

    </details>

# Automate the lab in a single script!

As DevOps engineers, we love everything to be automated!

What we can do here is to clone this repo down to the lab to get all the YAML manifest solutions, then apply them in the correct order. We will also use some Linux trickery to fix the API server. When the script completes, you can press the `Check` button and the lab will be complete!

<details>
<summary>Automation Script</summary>

Paste this entire script to the lab terminal, sit back and enjoy!

```bash
{
    # Clone this repo to get the manifests
    git clone --depth 1 https://github.com/kodekloudhub/kubernetes-challenges.git

    ### Fix API server

    #### kubeconfig
    sed -i 's/6433/6443/' .kube/config

    #### API server
    sed -i 's/ca-authority\.crt/ca.crt/' /etc/kubernetes/manifests/kube-apiserver.yaml
    # Restart the kubelet to ensure the container is started
    systemctl restart kubelet
    # Wait for it to be running. We will get back the container ID when it is
    id=""
    while [ -z "$id" ]
    do
        echo "Waiting for API server to start..."
        sleep 2
        id=$(crictl ps -a --name kube-apiserver --state running --output json | awk -F '"' '/"id":/{print $4}')
    done

    echo "API Server has started (ID = $id). Giving it 10 seconds to initialise..."
    sleep 10

    #### CoreDNS
    kubectl set image deployment/coredns -n kube-system coredns=registry.k8s.io/coredns/coredns:v1.8.6

    ### Fix node01
    kubectl uncordon node01

    ### Web directory
    scp /media/* node01:/web

    ### data-pv
    kubectl apply -f kubernetes-challenges/challenge-2/fileserver-pv.yaml

    ### data-pvc
    kubectl apply -f kubernetes-challenges/challenge-2/fileserver-pvc.yaml

    ### gop-file-server
    kubectl apply -f kubernetes-challenges/challenge-2/fileserver-pod.yaml

    ### gop-fx-service
    kubectl apply -f kubernetes-challenges/challenge-2/fileserver-svc.yaml

    echo -e "\n\nAutomation complete! Press the Check button.\n"
}

```

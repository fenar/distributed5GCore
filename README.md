## Distributed 5GCore over Multiple Sites with Service Interconnect & Single Pane Observability.

This is the repo to company our forthcoming Distributed 5g Core with Service Interconnect & Observability. We are evaluating multiple solution options:<br>

----

(1) Federated Service Mesh <br>

![alt text](https://raw.githubusercontent.com/fenar/distributed5GCore/main/images/distributed5g-arch.png)<br>

Working Sample-Snapshot:

![alt text](https://raw.githubusercontent.com/fenar/distributed5GCore/main/images/FedMeshUPFSnapShot.png)<br>

Note:<br>
> Now that Site2's UPF being available to Site1 to assign a User Equipment (UE) for local breakout, however Site1's NRF shall be configured properly with this new UPF CNF instance so that when asked by AMF/SMF NRF can return the right UPF address for right UEs.<br>
> This setup is NOT special to onprem deployment but can also be used with hyperscalers (ex AWS). <br>


[> Reference Documentation on Federated Mesh](https://docs.openshift.com/container-platform/4.10/service_mesh/v2x/ossm-federation.html)<br>

----

(2) Inter-Cluster L2 Network Coupling (Submariner) with Open Cluster Management <br>

----

(3) Inter-Cluster Application Sticthing (Skupper) with NetObserv Operator<br>  

**AMI Creation using Packer**

**Description** : 

Aim here is to create a pipeline which will be used to continuously create/Update AMI’s Using Hashicorp Packer.

We can make changes to our code which will trigger AWS code pipeline and will build AMI’s as specified.

Also Included are security checks via AWS Code Inspector, which will identify vulnerabilities and provide Hardening.

This Story can be broken up into 3 phases as following:

1. Build Stage - Here we will provide packer.json and buildspec.yml which AWS Code Build will use to create AMI, also AWS Code Inspector agent will be installed within the AMI.
2. Pipeline Stage - Here we will create AWS Code Pipeline to automatically trigger code Build as soon as there is any update in codecommit repository.
3. Inspection Stage - Here we will use AWS Inspector Service to Identify Vulnerabilities within the AMI we have created.

You can find more details to the asset by visiting https://websso.t-systems.com/qbase/pages/viewpage.action?pageId=153976933

**How to use the Asset** :

Please refer to "Utilizing CAT Asset" section from PPT attached in https://websso.t-systems.com/qbase/pages/viewpage.action?pageId=160392576

**Architectural Diagram** :

![Alt Text](Diagram.png)




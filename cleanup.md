---
title: Clean up lab resources
layout: home
nav_order: 90
---

# Clean up lab resources
{: .no_toc }

If you're finished with the resources that you created for these labs, clean up your lab environment by deleting them and the resource group that contains them.

1. Clean up the Azure OpenAI Service instance (optional). 

   If you completed the optional [Lab 5]({% link docs/03_lab_openai/03_openlab_openai_aca.md %}), you created a new Azure OpenAI instance. Use the following command to delete it before you delete any other resources. If you didn't complete Lab 5, you can ignore this step.

     ```bash
     az cognitiveservices account delete -g $RESOURCE_GROUP -n $OPEN_AI_SERVICE_NAME
     ```

1. Delete the resource group that you created for these labs, along with any resources that it contains.

   ```bash
   az group delete --name $RESOURCE_GROUP --yes --no-wait

   az configure --default group=''
   ```

   {: .note }

   >  It can take roughly 30 minutes to delete all these resources. With the option `--no-wait`, you can execute this long-running command without waiting for it to finish.

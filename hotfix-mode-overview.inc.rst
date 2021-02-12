..   This file is part of biogitflow
   
     Copyright Institut Curie 2020-2021
     
     This file is part of the biogitflow documentation.
     
     You can use, modify and/ or redistribute the software under the terms of license (see the LICENSE file for more details).
     
     The software is distributed in the hope that it will be useful, but "AS IS" WITHOUT ANY WARRANTY OF ANY KIND. Users are therefore encouraged to test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data. 
     
     The fact that you are presently reading this means that you have had knowledge of the license and that you accept its terms.



.. _hotfix-overview:

General overview
================

First we provide an overview of the development workflow when a critical bug occurs in the **prod** environment.

.. _step1-hotfix-overview:

|step1|
-------

- The |userd| reads the bug report or writes it in a new |gitlabissue| using the appropriate template.

- The |userd| creates a local branch named **hotfix-id\_commit-user** on the |wks| from the **hotfix** branch. The **id\_commit** is the commit number of the version that has been deployed in the **prod** environment that needs to be fixed, and **user** is the unix login of the developer (e.g. hotfix-aa12bb34-phupe).
  

- The developer develops the corrections.

- The |userd| temporary pushes the code from the local branch  **hotfix-id\_commit-user** on the |repo|.

- The |userd| deploys the code from **hotfix-id\_commit-user** branch either in a personal environment for testing or in the **dev** environment to perform unit, integration, system and regression testing.

- The |userd| checks that the bug has been fixed.
  
- If the testing is successful, it is possible to move to :ref:`step2-hotfix-overview`.

.. _step2-hotfix-overview:

|step2|
-------

- The |userd-ud| creates a new |gitlabissue| with the label |label_validation| using the appropriate template. This |gitlabissue| allows the tracking of all the discussions with the end-users who will validate the new release.

- The end-user can start the acceptance testing of the corrected release:

  - either the end-user validates the corrections,

  - or the end-user does not validate the corrections. Thus, the |userd| goes back to :ref:`step1-hotfix-overview` to implement the corrections on the **hotfix-id\_commit-user** branch until acceptance by the end-user.

- The |userd| has to :ref:`gitlab-merge-request` from the **hotfix-id\_commit-user** branch on the **hotfix** branch. The **Merge request** is assigned to as user who has the **Maintainer** role.

-  The |userm-uvp| reviews and accepts the **Merge Request**.

|step3|
-------

- The |userm-uvp| creates a |gitlabissue| with the label |label_mep| using the appropriate template in order to track the different steps of the installation process. The ID of the |gitlabissue| regarding the validation of the release is also reported for tracking.

- The |userm-uvp| deploys the code from the **hotfix** release branch in the **valid** environment.

- The |userm-uvp| checks that the installation is successful, launches a set of testing, in particular the operational testing.


- Once the validation successful, the |userm-uvp| adds a tag on **hotfix** branch with the new version number.

|step4|
-------

- Once validated by the end-user, the |userm-uvp| deploys the code in the **prod** environment from the **hotfix** branch.

- The |userm-uvp| launches the operational testing dedicated to the  **prod** environment (e.g. foobar).

- Once the deployment is successful, the |userm-uvp| merges the code from the **hotfix** branch on the **master** branch for archiving.

-  The |userm-uvp| brings the content of the **hotfix** branch  into the **release**  branch such that they can be integrated in the future release.

- The |userm-uvp| brings the content of the **hotfix** branch into the **devel** branch such that the corrections can be integrated in the future release. Note that possible conflicts may exist on some pieces of code. They will have to be resolved before merging thus requiring the help from the other developers involved in the modifications.

- If needed, the |userm-uvp| deploys the code from **hotfix** branch in the **dev** environment, such that at this stage of the workflow, the **same commit ID** of the |soft| is deployed  in the **dev**, **valid** and **prod** environment.

- The |userm-uvp| closes the |gitlabissue| |label_validation| and the |gitlabissue| |label_mep| that were previously opened.

..   This file is part of biogitflow
   
     Copyright Institut Curie 2020-2024
     
     This file is part of the biogitflow documentation.
     
     You can use, modify and/ or redistribute the software under the terms of license (see the LICENSE file for more details).
     
     The software is distributed in the hope that it will be useful, but "AS IS" WITHOUT ANY WARRANTY OF ANY KIND. Users are therefore encouraged to test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data. 
     
     The fact that you are presently reading this means that you have had knowledge of the license and that you accept its terms.



.. _nominal-overview:

General overview
================

First we provide an overview of the development workflow in the nominal mode.

.. _step1-nominal-overview:

|step1|
-------

- The |userd| reads the specifications of the new feature to be implemented in the |gitlabissue| or writes them in a new |gitlabissue| using the appropriate template.

- The |userd| creates a local branch named **feature** (it is recommended to give a meaningful name such **feature_star_mapper**) on the |wks|  from the **devel** branch to implement the new expected functionalities, test the code, commit the modifications, merge them and push the code on the |repo| on the **devel** branch.

- The |userd| deploys the code from the **devel** branch either in a personal environment for testing or in the **dev** environment to perform unit, integration, system and regression testing.

- The |userd| checks that the expected functionalities have been correctly implemented.

- If the testing is successful, it is possible to move to :ref:`step2-nominal-overview`.

.. _step2-nominal-overview:

|step2|
-------

- The |userd-ud| creates a new |gitlabissue| with the label |label_validation| using the appropriate template. This |gitlabissue| allows the tracking of all the discussions with the end-users who will validate the new release.

- The end-user can start the acceptance testing of the new release:

  - either, the end-user validates the new release,

  - or the end-user does not validate the new release. Thus, the |userd| goes back to :ref:`step1-nominal-overview` to implement the corrections until acceptance by the end-user.

- The |userm-uvp| implements an operational testing in |gitlabci|.

- The |userm-uvp| tracks the issues related to the new version in a Milestone

|step3|
-------

- The |userm-uvp| brings the content of the **devel** branch into the **release** branch.

- The |userm-uvp| creates a |gitlabissue| with the label |label_mep| using the appropriate template in order to track the different steps of the installation process. The ID of the |gitlabissue| opened for the |label_validation| of the release is also reported for tracking.

- The |userm-uvp| deploys the code from the **release** branch in the **valid** environment.

- The |userm-uvp| checks that the installation is successful.

- The |userm-uvp| implements an operational testing in |gitlabci|.

- Possibly, new corrections must be implemented on the **release** branch before the deployment in production. In this case:
 
  - The |userd| creates a local branch names **release-id\_version-user** from **release** branch. The  **id\_version** is the version number of the new release and the **user** is the unix login of the developer (e.g. release-version-1.2.3-phupe).
  
  - The |userd| develops the corrections.
  
  - The |userd| pushes the code from the local branch **release-id\_version-user** on the |repo|.
  
  - The developer deploys the code from the **release-id\_version-user** branch either in a personal environment for testing or in the **dev** environment to perform unit, integration, system and regression testing.
  
  - Once the code validated, the |userd| has to :ref:`gitlab-merge-request` from the **release-id\_version-user** branch on the **release** branch. The **Merge request** is assigned to as user who has the **Maintainer** role.
  
  - The |userm-uvp| reviews and accepts the **Merge Request**.

- Once all the testing successful, the |userm-uvp| adds a tag on the **release** branch with the new version number.

|step4|
-------

- Once validated by the end-user, the |userm-uvp| deploys the code in the **prod** environment from the **release** branch.

- The |userm-uvp| schedules a periodic operational testing in |gitlabci|.

- Once the deployment is successful, the |userm-uvp| brings the content of the **release** branch into the **main** branch for archiving.

- The |userm-uvp| brings the content of the **release** branch into the **hotfix** branch.
-  If some modifications were committed on the **release** branch, the |userm-uvp| brings the content of the **release** branch into **devel** branch such that the corrections can be integrated in the future release. Note that possible conflicts may exist on some pieces of the code. They will have to be resolved before merging thus requiring the help from the other developers involved in the modifications.

- If needed, the |userm-uvp| deploys the code from **release** branch in the **dev** environment, such that at this stage of the workflow, the **same commit ID** of the |soft| could be deployed  in the **dev**, **valid** and **prod** environment.

- The |userm-uvp| closes the |gitlabissue| |label_validation| and the |gitlabissue| |label_mep| that were previously opened.

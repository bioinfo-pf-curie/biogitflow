..   This file is part of biogitflow
   
     Copyright Institut Curie 2020-2021
     
     This file is part of the biogitflow documentation.
     
     You can use, modify and/ or redistribute the software under the terms of license (see the LICENSE file for more details).
     
     The software is distributed in the hope that it will be useful, but "AS IS" WITHOUT ANY WARRANTY OF ANY KIND. Users are therefore encouraged to test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data. 
     
     The fact that you are presently reading this means that you have had knowledge of the license and that you accept its terms.



.. include:: substitutions.rst

.. _devel-workflow-overview-page:

********************
Development workflow
********************

This section describes the general principles of the development workflow we implemented. The branching model is presented along with the different use cases.

Description of the different steps
==================================

.. _step1-workflow-overview:

|step1|
-------

This step includes several tasks:

-  **write the code** to implement the expected functionalities from the specifications that have been formalized.

-  **perform a set of testing** that consists of several levels:

   -  **unit testing** confirms that a piece of code provides the expected output according to the input parameters. The developer is in charge of this testing.

   -  **integration testing** checks that the interfaces of the different |soft| components are consistent with each other. It ensures that their integration allows the expected functionalities to be performed.
     

   -  **system (or functional) testing** validates that the full |soft| works and fits well the user's needs as they were expressed. A person other than the developer is ideally responsible for carrying out these tests (if the team size allows it).

   -  **regression testing** checks that the correction of bugs or the development of new functionalities did not introduced defects in unchanged areas of the |soft|. New test cases are added whenever a new release is developed. The set of testing is entirely performed for each new release.


.. note::

   For more details about software testing visit the |ISTQB|_.

.. _step2-workflow-overview:

|step2|
-------

Once all the testing from the :ref:`step1-workflow-overview` is successful, the end-user must validate all the functionalities that have been developed in a mirror environment that is used in production.

Different representative use cases must be evaluated on real datasets. For a |soft| that includes several components (as it is generally the case for bioinformatics pipelines), it is necessary to check that no data are lost between the different processing steps. For example:

- if the |soft| annotates a list of genomic variants, then the number of variants used as input must be the same in the output and their genomic coordinates must remain unchanged after the processing.

- if the |soft| is a visualization interface, the integrity of the data that are displayed must be preserved.


If the end-user does not validate the developments, the :ref:`step1-workflow-overview` starts again.

After the final validation by the end-user, an  **operational testing** is set up using the tool |jenkins|_.

.. important::

   The **operational testing** is essential as it checks that the |soft| provides the expected results on a reference dataset (golden dataset) in the production environment.  This testing is performed periodically and is typically run every time that the |soft| is used in the production environment. This ensures the reproducibility of the results.


.. _step3-workflow-overview:

|step3|
--------

This steps checks that the |soft| can be installed in a similar environment that is used in production.

Another set of testing is performed such that bugs can be corrected before installing the |soft| in production.

This step should be realized within a very short period of time. The |soft| is generally deployed in the production environment right after this step.


.. _step4-workflow-overview:

|step4|
--------

During this last step, the new release of the |soft| with the new functionalities is installed in the production environment.

Multiple deployment environments
================================

It is mandatory that the different steps that have been previously described are performed in separated environments for the following reasons:

- ensure that a stable version can be used in production,

- allow the end-users to validate a new release without any impact on both the version used in production or the version under development,

- allow the software developers to add new functionalities and modify the code without any impact on the end-users who are validating a new version and/or using the version currently in production.

Therefore, we use **3 deployment environments** for the |soft|:

-  **dev**: development environment

-  **valid**: validation environment (also called **pre-production**)

-  **prod**: production environment


Each |soft| has 3 environments that are accessible in dedicated folders. For example, the environments of the |soft| `foobar` would be located here:


-  ``/bioinfo/pipelines/foobar/dev``

-  ``/bioinfo/pipelines/foobar/valid``

-  ``/bioinfo/pipelines/foobar/prod``

.. note::

   The deployment environments are not limited to the 3 environments that have been previously described. Indeed, each developer can deploy the |soft| in a **local** workspace to test the new functionalities. The deployment in the **dev** environment generally takes place when a preliminary set of testing has been sucessful.


Version control and branching model
===================================


The management of the different |soft| versions is based on different |git|_ **branches**. Each branch is used depending on the context and the step in the development workflow. The model we use is based on a |repo| that contains 4 branches:


- **devel**: contains the code of the current version under development. Note that the version under development may have not been yet deployed in the **dev** environment. The code remains on that branch while the |soft| has not successfully passed the :ref:`step2-workflow-overview`.

- **release**: contains the code with both candidate and official releases. The **release** branch comes from the **devel** branch. 

- **hotfix**: this branch is a mirror of the **release** branch and is used to patch the code that is in production. If a critical bug occurs in production, this branch is used to fix the issue.

- **master**: this branch is not used for development, it is only used to archive the code from the **release** and **hotfix** branches.
      

Among these four branches, the **release**, **master** and **hotfix** are protected branches. This means that only the developer with the **Maintainer** role in the |gitlaburl|_ repository can push code on the remote repository. Other developers have to :ref:`gitlab-merge-request` to submit their modifications to the **Maintainer**.

The developer will have to create local branches in the |wks| used for development whenever a new feature is implemented, a hotfix is resolved or problem occurred during the :ref:`step3-workflow-overview`. Therefore, the |wks| will contain:


- the branches from the |repo|,

- the local branches created by the developer to implement the new feature. These branches will not be sent onto the |repo|. They are named with the prefix **feature** and any meaningful suffix (e.g *feature_star_mapper*),
  
- the branches that developer will use to :ref:`gitlab-merge-request` on protected branches. These branches will have either the prefix **release** or **hotfix** depending on the context.
  

The workflow across the different branches can be summarized in the graphic below:

   |gitworkflow|


.. warning::

   No development must be initiated on a branch that exists on the |repo|. The developer always creates a local branch with the command ``git checkout -b feature_1`` (or any other more meaningful suffix). The modifications are committed on the local branch. Once validated, the modifications are merged on the branch from which the local branch was created.

Deployment and branching model
==============================

There is **no bijection between the branches and the deployement environments** as a version from a given branch can be deployed in different environments. However, only some combinations are allowed as described in the table below:



+-------------------+------------------------------+------------------------------+------------------------+
|                   | env:dev                      | env:valid                    | env:prod               |
+===================+==============================+==============================+========================+
| branche:devel     | |install_normal|             | |install_prohibited|         | |install_prohibited|   |
+-------------------+------------------------------+------------------------------+------------------------+
| branche:release   | |install_possible|           | |install_normal|             | |install_validated|    |
+-------------------+------------------------------+------------------------------+------------------------+
| branche:hotfix    | |install_possible|           | |install_normal|             | |install_validated|    |
+-------------------+------------------------------+------------------------------+------------------------+
| branche:master    | |install_exceptional|        | |install_exceptional|        | |install_exceptional|  |
+-------------------+------------------------------+------------------------------+------------------------+


-  |install_normal| is the normal case

-  |install_prohibited| is a prohibited case

-  |install_possible| is possible case

-  |install_validated| is the normal case when both the :ref:`step2-workflow-overview` and  the :ref:`step3-workflow-overview` are successful

-  |install_exceptional| is an excpetional use case

Steps of the workflow and deployment environment
------------------------------------------------

During the different steps of the workflow, the deployment of the |soft| is performed in the following environments:


+--------------------------------+-----------------+
|                                | environment     |
+================================+=================+
| :ref:`step1-workflow-overview` | dev             |
+--------------------------------+-----------------+
| :ref:`step2-workflow-overview` | dev             |
+--------------------------------+-----------------+
| :ref:`step3-workflow-overview` | valid           |
+--------------------------------+-----------------+
| :ref:`step4-workflow-overview` | prod            |
+--------------------------------+-----------------+

.. _devel-workflow-overview-roles:

User roles and permissions
==========================

In the gitlab |repo|
--------------------


In the |repo| on |gitlaburl|_, the projects members will be assigned one of the following role:


-  **Developer**: the user can push the developments on the non-protected branches. The letter **D** is used as an abbreviation for this role.

-  **Maintainer**: in addition to the permissions with the **Developer** role, the user can push on the protected branches. The letter **M** is used as an abbreviation for this role.


In the deployment environments
------------------------------

For the deployment, two roles are considered:

-  **UD**: the user can deploy in the **dev** environment.

-  **UVP**: the user can deploy in the  **valid** and **prod** environments.


.. note::

   Whenever necessary, the roles that are required to perform the different actions will be mentioned. For example, **M+UVP** means that the user must have the **Maintainer** role in gitlab and can deploy in both the  **valid** or **prod** environments.


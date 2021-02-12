..   This file is part of biogitflow
   
     Copyright Institut Curie 2020-2021
     
     This file is part of the biogitflow documentation.
     
     You can use, modify and/ or redistribute the software under the terms of license (see the LICENSE file for more details).
     
     The software is distributed in the hope that it will be useful, but "AS IS" WITHOUT ANY WARRANTY OF ANY KIND. Users are therefore encouraged to test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data. 
     
     The fact that you are presently reading this means that you have had knowledge of the license and that you accept its terms.


.. _hotfix-technical:

Technical procedure
===================

.. _step1-hotfix-technical:

|step1|
-------

.. _step1-hotfix-technical-cw:

|step1-cw|
~~~~~~~~~~

- The |userd| reads the bug report or writes it in a new |gitlabissue| using the template :download:`bug_report <data/templates/issue_templates/bug_report.md>`.

- The |userd| sets the |wks| on the **hotfix** branch, gets the last modifications from the |repo| and checks that the right branch is used: 

.. code-block:: bash

   git checkout hotfix
   git status
   git pull
   git submodule update --init --recursive # if your git repo has submodules

- The |userd| gets the commit ID that has been deployed in the **prod** environment. The commit ID is retrieved from the ``version`` file that is available in the folder in which the pipeline has been installed.

.. important::

   It is essential that the commit ID that has been used to deploy the code is tracked in the install folder. For this purpose, the commit ID is stored in the ``version`` file.

- The |userd|  checks that the commit ID stored in the ``version`` file is the same as the commit ID of the **hotfix** branch from the local repository:

.. code-block:: bash

   git branch -vv

- The |userd| creates a local branch named **hotfix-id_commit-user**. The **id_commit** is the commit number of the version that has been deployed in the **prod** environment that needs to be fixed, and **user** is the unix login of the developer (e.g. hotfix-aa12bb34-phupe).

.. code-block:: bash

   git checkout -b hotfix-id_commit-user

- The |userd| implements the corrections, tests the modifications and commits them (see :ref:`step1-hotfix-technical-cw` for the details about the command lines).

-  The |userd| temporarily pushes the new local branch on the |repo|:

.. code-block:: bash

   git push origin hotfix-id_commit-user

- The |userd| deploys the code from the **hotfix-id_commit-user** branch either in a personal environment for testing or in the **dev** environment to perform unit, integration, system and regression testing.

- The |userd| checks that the bug has been corrected.

|step1-ud|
~~~~~~~~~~

The |userd-ud| deploys the |soft| in the **dev** environment from the **hotfix-id_commit-user** branch using the ad-hoc deployment scripts. **The deployment is only based on a commit ID**.


.. danger::

   |dangertag|


|step1-testing|
~~~~~~~~~~~~~~~

-  The |userd| checks that the bug has been fixed.

|step2|
-------

|step2-acceptance|
~~~~~~~~~~~~~~~~~~

- The |userd-ud| creates an |gitlabissue| using the template :download:`validation <data/templates/issue_templates/validation.md>`.

- The title of the |gitlabissue| must indicate the characteristics of the version to be validated.

- The description in the |gitlabissue| lists the new features/modifications that have to be communicated to the end-users.

- At the end of the description, a line such as **fyi: @user1, @user2, @user3** is added such that all the persons involved in the validation process receive a notification.

- The |gitlabissue| is labeled with |label_validation|.

- The |gitlabissue| is assigned to a |userm-uvp|.

- The |userd-ud| or the |userm-uvp| sends an email to all the persons who are involved in the validation process.

- The end-users can start the acceptance testing process:

  - either the end-users validate the new release,

  - or the end-users do not validate the new release. Then, the reason are tracked in the |gitlabissue| |label_validation| that has been created. We go back to :ref:`step1-hotfix-technical`. The |userd| develops the modifications requested by the end-users on a local **hotfix-id\_commit-user** branch. The process is iterated until the validation by the end-users. The same |gitlabissue| is used to track all the information during the validation process until the final validation.


- Once validated by the end-user, the |userd|  creates a :ref:`gitlab-merge-request` from the **hotfix-id_commit-user** branch on **hotfix** branch. The merge request is assigned to a user with the **Maintainer** role.

- The |userm-uvp| reviews and accepts the **Merge Request**.

|step2-changelog|
~~~~~~~~~~~~~~~~~

.. note::

   The CHANGELOG file provides a simple history of the different versions of the |soft|. The version numbers are listed by decreasing order.
   
   - A version number is added in the CHANGELOG using the following naming convention: **version-x.y.z**.
   
   - Comments are added in the CHANGELOG to describe the most relevant functionalities added to the new release.

   The CHANGELOG is divided into 3 sections:
   
   -  ``NEW FEATURES``
   -  ``SIGNIFICANT USER-VISIBLE CHANGES``
   -  ``BUG FIXES``

   Example of CHANGELOG file:
   
   .. literalinclude:: data/CHANGELOG

- The |userm-uvp| updates the **hotfix** branch to get the last modifications from the |repo| and checks that the right branch is used:

.. code-block:: bash

   git checkout hotfix
   git status
   git pull
   git branch -vv


- The |userm-uvp| updates the CHANGELOG.  The version number is incremented using the following naming convention: **version-x.y.z**.

- If needed, the |userm-uvp|  asks the other developers to define what comments should be added in the CHANGELOG and pushes the modifications on the |repo|:

.. code-block:: bash

   git add CHANGELOG
   git commit -m "[DOC] information about the version-1.2.4 after correction of the bug added in the CHANGELOG"
   git push origin hotfix

.. _step3-hotfix-technical:

|step3|
-------

.. _step3-hotfix-deployvalid:

|step3-deployvalid|
~~~~~~~~~~~~~~~~~~~

The |userm-uvp| deploys the pipeline in the **valid** environment from the **hotfix** branch using the ad-hoc deployment scripts. **The deployment is only based on a commit ID**.

.. danger::

   |dangertag|


|step3-testvalid|
~~~~~~~~~~~~~~~~~

The |userm-uvp| tests the |soft|.

Launch the operational testing in Jenkins
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- The |userm-uvp| launches an analysis to generate the dataset that will be used as a reference.

- In the dedicated project in |jenkins|_ named with the suffix **_VALID**, the |userm-uvp| modifies the parameters of the operational testing (for example, a new reference dataset may be used for this purpose, etc.), the reference dataset will be the dataset that has been validated.

- The |userm-uvp| launches the  operational testing.

- If the operational testing fails (the |soft| does not work or is not reproducible), go back to the :ref:`step3-hotfix-corrections`.

.. _step3-hotfix-corrections:

Development of corrections if needed
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In most of the cases, the deployment in the **valid** environment is very simple and quick. However, it might be necessary to correct some bugs before the deployment in production. In that case:

- The |userd| checkouts and updates the **hotfix** branch from the |wks|:

.. code-block:: bash

   git checkout hotfix
   git status
   git pull
   git branch -vv

- The |userd| creates a local branch named **hotfix-id_version-user** (e.g. hotfix-version-1.2.3-phupe), the hotfix-version is retrieved from the CHANGELOG file) and uses it for the developments:

.. code-block:: bash

   git checkout -b hotfix-id_version-user # change the id_version and user values

- The |userd| implements the corrections, tests the modifications and commits them (see :ref:`step1-hotfix-technical` for the details about the command lines).

- The |userd| temporarily pushes the local branch on the |repo|:

.. code-block:: bash

   git push origin hotfix-id_version-user # change the id_version and user values

- The |userd| deploys the code from the **hotfix-id\_version-user** branch either in a personal environment for testing or in the **dev** environment to perform unit, integration, system and regression testing.

- Once the code validated, the |userd| creates a :ref:`gitlab-merge-request` from the **hotfix-id\_version-user** branch on the **hotfix** branch using the template :download:`merge_request_template.md <data/templates/merge_request_templates/merge_request_template.md>`. The **Merge request** is assigned to a user with the **Maintainer** role.

- The |userm-uvp| reviews and accepts the **Merge Request**.

- The |userm-uvp| updates the **hotfix** branch from the |wks|:

.. code-block:: bash

   git checkout hotfix
   git status
   git pull
   git branch -vv

- The |userm-uvp| go back to :ref:`step3-hotfix-deployvalid`.

|step3-tag|
~~~~~~~~~~~

Once the new release has been validated and the installation in the **valid** environment is successful, the |userm-uvp| adds a **tag** (using the same version number that has been written in the CHANGELOG file) on the current HEAD:

.. code-block:: bash

   tag-version4prod.sh -t version-1.2.3
   git push --tags

.. note::

   The script :download:`tag-version4prod.sh <data/tag-version4prod.sh>` checks that the tag name is consitent with what was mentioned in the CHANGELOG and add the tag.

.. _step4-hotfix-technical:

|step4|
-------

|step4-updatelocal|
~~~~~~~~~~~~~~~~~~~

It is likely that the local repository is not up-to-date anymore especially if a **Merge Request** has been submitted on |gitlaburl|_. The |userm-uvp| updates the |wks|:

.. code-block:: bash

   git checkout hotfix
   git status
   git pull
   git branch -vv

- The |userm-uvp| creates an |gitlabissue| using the template :download:`deploy_in_prod_hotfix <data/templates/issue_templates/deploy_in_prod_hotfix.md>`

  - The |gitlabissue| is labeled with |label_mep|.

  - The |gitlabissue| number that has been used for the validation along with the |gitlabissue| number that describes the bug is added to the current |gitlabissue|.

  - The |userm-uvp| tracks all the steps that are performed for the deployment in the production environment (including link or name of datasets that are used).

  - The |userm-uvp| fills the |gitlabissue| at each step.

.. _step4-hotfix-deployprod:

|step4-deployprod|
~~~~~~~~~~~~~~~~~~

The |userm-uvp| deploys the |soft| in the **prod** environment from the **hotfix** branch using the ad-hoc deployment scripts. **The deployement is only based on a commit ID**. The last commit ID from the **release** branch must be deployed.

.. danger::

   |dangertag|


Launch the operational testing in Jenkins
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- The |userm-uvp| launches an analysis to generate the dataset that will be used as a reference.

- In the dedicated project in |jenkins|_, the |userm-uvp| modifies the parameters of the operational testing (for example, a new reference dataset may be used for this purpose, etc.), the reference dataset will be the dataset that has been validated.

- The |userm-uvp| launches the operational testing.

- If the operational testing fails (the |soft| does not work or is not reproducible), go back to the :ref:`step3-hotfix-corrections`.

Bring the content of  the hotfix branch into the master branch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- At this stage, there is a stable code on the **hotfix** branch that has been tested, validated and successfully installed in the **prod** environment.

- The |userm-uvp| checkouts and updates the **master** branch:

.. code-block:: bash

   git checkout master
   git status # everything must be cleaned
   git pull
   git branch -vv

- The |userm-uvp| brings the content of the **hotfix** into the **master** using the option  ``--no-ff`` to avoid the fast-forward mode. This option will produce a new commit ID with a specific message to describe and track the merge:

.. code-block:: bash

   git merge --no-ff hotfix`` # can be a bit verbose
   git status # must be cleaned
   git branch -vv

- The ``git status`` must absolutely says something like this (otherwise, ask for help before moving forward):

::

  # On branch master
  # Your **branch is ahead of 'origin/master' by** 113 commits.
  # (use "git push" to publish your local commits)
  #
  # nothing to commit, working directory clean
  *# On branch master*


- The |userm-uvp| pushes the modifications on the |repo|:

.. code-block:: bash

   git push origin master

Bring the content of the hotfix branch into the devel branch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- At this stage, there is a stable code on the **hotfix** branch that has been tested, validated and successfully installed in the **prod** environment and merged on the **master** branch.

- The |userm-uvp| checkouts and updates the **devel** branch:

.. code-block:: bash

   git checkout devel
   git status # must be cleaned otherwise, commit or stash your modifications
   git pull
   git branch -vv

- The |userm-uvp| brings the content of the **hotfix** branch into the **devel** branch:

.. code-block:: bash

   git merge --no-ff hotfix # may be a bit verbose
   git status # may say something
   git branch -vv

- If the **devel** branch has been modified in the meantime, git will try to merge the modifications from the **hotfix** branch.

- If some files cannot be merged automatically, they will appear to have **conflicts** in the output of the ``git status``:

::

  # On branch devel
  # You have unmerged paths.
  # (fix conflicts and run "git commit")...
  # (use "git add ..." to mark resolution)
  # both modified:build.xml

- The conflicts have to be resolved manually. In that case, ask the help from the other developers.

- The files with resolved conflicts must be added to the staging area, committed, and the merge must be sent on the |repo|:

.. code-block:: bash

   git push origin devel

Bring the content of the hotfix branch into the release branch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- At this stage, there is a stable code on the **hotfix** branch that has been tested, validated and successfully installed in the **prod** environment and merged with the **master** and the **devel** branches.

- The |userm-uvp| checkouts and update the **release** branch:

.. code-block:: bash

   git checkout release
   git status # must be cleaned otherwise, commit or stash your modifications
   git pull
   git branch -vv

- The |userm-uvp| brings the content of the **hotfix** branch into the **release** branch using the option ``--ff`` to use the fast-forward mode in order to have the exact same commit ID between the **release** branch and the **hotfix** branch. However this might not be always possible if the same pieces of code have been modified at the same time:

.. code-block:: bash

   git merge --ff hotfix # may be verbose
   git status # may say something
   git branch -vv

- If the **release** branch has been modified in the meantime, git will try to merge the modifications from the **hotfix** branch.

- If some files cannot be merged automatically, they will appear to have **conflicts** in the output of the ``git status``:

.. code-block:: bash 

  *# On branch release*
  *#You have unmerged paths.*
  *# (fix conflicts and run "git commit")...*
  *# (use "git add ..." to mark resolution)*
  *## both modified:build.xml*

- The conflicts have to be resolved manually. In that case, ask the help from the other developers.

- The files with resolved conflicts must be added to the staging area, committed, and the merge must be sent on the |repo|:

.. code-block:: bash

   git push origin release

- The |userm-uvp| closes the |gitlabissue| |label_validation| and |gitlabissue| |label_mep| that have been opened.

Back on the devel branch
~~~~~~~~~~~~~~~~~~~~~~~~

For security reason, the |userm-uvp| switches on the **devel** branch to avoid any risk of code modification on the **master** branch:

.. code-block:: bash

   git checkout devel
   git pull
   git branch -vv


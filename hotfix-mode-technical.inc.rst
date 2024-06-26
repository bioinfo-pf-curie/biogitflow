..   This file is part of biogitflow
   
     Copyright Institut Curie 2020-2024
     
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

.. _step1-hotfix-technical-issue:

|step1-issue|
~~~~~~~~~~~~~

- The |userd| reads the bug report or writes it in a new |gitlabissue| using the template :download:`bug_report <data/templates/issue_templates/bug_report.md>`.

.. _step1-hotfix-technical-cw:

|step1-cw|
~~~~~~~~~~


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

The |userd-ud| deploys the |soft| in the **dev** environment from the **hotfix-id_commit-user** branch using |gitlabci| (or ad-hoc deployment scripts using the commit ID to deploy).


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


- Once validated by the end-user, the |userd|:

  - creates a :ref:`gitlab-merge-request` from the **hotfix-id_commit-user** branch on **hotfix** branch,

  - assigns the **Merge request** to a user with the **Maintainer** role.

- The |userm-uvp| reviews and accepts the **Merge Request**.

|step2-changelog|
~~~~~~~~~~~~~~~~~

.. note::

   The CHANGELOG file provides a simple history of the different versions of the |soft|. The version numbers are listed by decreasing order.
   
   - A version number is added in the CHANGELOG using the following naming convention: **version-x.y.z**:

     - The **z** number is incremented for BUG FIXES of modifications which are not visible by the end-user

     - The **x.y** numbers are incremented for major modifications considered as SIGNIFICANT USER-VISIBLE CHANGES
   
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

.. _step2-hotfix-milestone:

|step2-milestone|
~~~~~~~~~~~~~~~~~

As mentioned, a :ref:`step1-nominal-technical-issue` is created whenever a new development is started. As new version encompasses several issues, it is important to track all the issues which have been considered in the new version. Therefore, the |userm-ud|:

- creates a new |gitlabmilestone| with the same name as the new version number (e.g. **version-x.y.z**),

- describes what is the purpose of the new |gitlabmilestone|,

- for each issue included in the new version, sets the name of the |gitlabmilestone| in the dedicated field.

- in the Merge request which has been created to manage the **Hotfix**, sets the name of the |gitlabmilestone| in the dedicated field.

.. note::

   As your developments may depend on other |gitlab| repositories you maintain, you can also create another |gitlabmilestone| in each of them and cross-referenced the milestones in the different repositories. To do so, you can just add in the field **Description** of the **Milestone** the URL of the other **Milestones**.

.. _step3-hotfix-technical:

|step3|
-------

Create an issue to track the production deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- The |userm-uvp| creates an |gitlabissue| using the template :download:`deploy_in_prod_hotfix <data/templates/issue_templates/deploy_in_prod_hotfix.md>`

  - The |gitlabissue| is labeled with |label_mep|.

  - The |gitlabissue| is linked to the  name of the |gitlabmilestone| using the dedicated field.

  - The |gitlabissue| number that has been used for the validation along with the |gitlabissue| number that describes the bug is added to the current |gitlabissue|.

  - The |userm-uvp| tracks all the steps that are performed for the deployment in the production environment (including link or name of datasets that are used).

  - The |userm-uvp| fills the |gitlabissue| at each step.

.. _step3-hotfix-deployvalid:

|step3-deployvalid|
~~~~~~~~~~~~~~~~~~~

The |userm-uvp| deploys the pipeline in the **valid** environment from the **hotfix** branch using |gitlabci| (or ad-hoc deployment scripts using the commit ID to deploy).

.. danger::

   |dangertag|

Launch the operational testing in |gitlabci|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- The |userm-ud| checks that the deployment with |gitlabci| is available for the |gitlab| repository. It requires the file ``.gitlab-ci.yml`` as defined in the template pipeline.

- In the ``.gitlab-ci.yml`` file, the operational testing is implemented through different jobs which launch the pipeline twice during the :ref:`step3-hotfix-deployvalid` and compare the results to ensure they are identical.

- If the operational testing fails (the |soft| does not work or is not reproducible), go back to the :ref:`step1-nominal-technical`.

|step3-testvalid|
~~~~~~~~~~~~~~~~~

The |userm-uvp| tests the |soft|.

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

- In the Merge request, sets the name of the |gitlabmilestone| in the dedicated field.

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


.. _step4-hotfix-deployprod:

|step4-deployprod|
~~~~~~~~~~~~~~~~~~

The |userm-uvp| deploys the |soft| in the **prod** environment from the **hotfix** branch using |gitlabci| (or ad-hoc deployment scripts using the commit ID to deploy).

.. danger::

   |dangertag|

|step4-newrelease|
~~~~~~~~~~~~~~~~~~

The |userm-uvp| closes the milestone (see :ref:`step2-hotfix-milestone`) and issues related to the new version. Then, the |userm-uvp| creates a **New release** in |gitlab|:

- Select the **Tag name** corresponding to the new release

- Fill in the **Release title** with the **version number** followed by free comments containing the keywork **hotfix**

- Select the **Milestone** corresponding to the new release

.. figure:: images/hotfix-gitlab-new-release.png

Schedule the operational testing in |gitlabci|
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- The |userm-ud| checks that the deployment with |gitlabci| is available for the |gitlab| repository. It requires the file ``.gitlab-ci.yml`` as defined in the template pipeline.

- In the ``.gitlab-ci.yml`` file, the operational testing is implemented through different jobs which launch the pipeline twice during the :ref:`step4-hotfix-deployprod` and compare the results to ensure they are identical.

- The |userm-ud| connects to |gitlab| to :ref:`gitlab-ci-optest-page` if it is not yet scheduled.

Bring the content of  the hotfix branch into the main branch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- At this stage, there is a stable code on the **hotfix** branch that has been tested, validated and successfully installed in the **prod** environment.

- The |userm-uvp| checkouts and updates the **main** branch:

.. code-block:: bash

   git checkout main
   git status # everything must be cleaned
   git pull
   git branch -vv

- The |userm-uvp| brings the content of the **hotfix** into the **main** using the option  ``--no-ff`` to avoid the fast-forward mode. This option will produce a new commit ID with a specific message to describe and track the merge:

.. code-block:: bash

   git merge --no-ff hotfix # can be a bit verbose
   git status # must be cleaned
   git branch -vv

- The ``git status`` must absolutely says something like this (otherwise, ask for help before moving forward):

::

  # On branch main
  # Your **branch is ahead of 'origin/main' by** 113 commits.
  # (use "git push" to publish your local commits)
  #
  # nothing to commit, working directory clean
  *# On branch main*


- The |userm-uvp| pushes the modifications on the |repo|:

.. code-block:: bash

   git push origin main

Bring the content of the hotfix branch into the release branch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- At this stage, there is a stable code on the **hotfix** branch that has been tested, validated and successfully installed in the **prod** environment and merged with the **main** and the **devel** branches.

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

- The |userm-uvp| closes:

  - all the GitLab issues which have been opened including the |label_validation|, the |label_mep|, and all issues related to the new version
 
  - the milestone (see :ref:`step2-hotfix-milestone`).

Bring the content of the hotfix branch into the devel branch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- At this stage, there is a stable code on the **hotfix** branch that has been tested, validated and successfully installed in the **prod** environment and merged on the **main** branch.

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


Back on the devel branch
~~~~~~~~~~~~~~~~~~~~~~~~

For security reason, the |userm-uvp| switches on the **devel** branch to avoid any risk of code modification on the **main** branch:

.. code-block:: bash

   git checkout devel
   git pull
   git branch -vv


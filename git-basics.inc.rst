..   This file is part of biogitflow
   
     Copyright Institut Curie 2020-2021
     
     This file is part of the biogitflow documentation.
     
     You can use, modify and/ or redistribute the software under the terms of license (see the LICENSE file for more details).
     
     The software is distributed in the hope that it will be useful, but "AS IS" WITHOUT ANY WARRANTY OF ANY KIND. Users are therefore encouraged to test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data. 
     
     The fact that you are presently reading this means that you have had knowledge of the license and that you accept its terms.


.. _git-basics:

Git basics
==========

This section describes some basics about |git|_ usage.


|git|_ considers two levels:

1. The |repo|

2. The |wks| specific to each developer that is located on the developer's computer

Remote repository
-----------------

The remote repository is accessible at |gitlaburl|_.

Local workspace
---------------

First, the developers has to clone a project from the |repo|:

``git clone`` |gitprojecturl|_

It may ask you for your login and password but this can be avoided by `Adding an SSH key to your GitLab account <https://docs.gitlab.com/ce/ssh/#adding-an-ssh-key-to-your-gitlab-account>`_.


Organisation
~~~~~~~~~~~~

The |wks| is divided into three areas:

1. the **working tree** is the tree with all the files that are visible with the standard ``ls`` command. This is where the developer will modify the code.

2. the **staging area** or **index** is where git stores the list of files that will be sent with the next  ``git commit`` command.

3. the **commit area** contains the history of the ``commit`` (some of them maybe available only locally) from the current ``HEAD``.

The command ``git add`` transfers a file from the **working tree** to the **staging area**.

.. tip::

   All the files that are not supposed to be versionned can be listed in the ``.gitignore`` file.

The command ``git commit -m "[MODIF] new algorithm added (Issue #10)"`` transfers the files from the **staging area** to the **commit area**. So far, all the modified files are only present on the |wks|. We will see in what follows how to push them on the remote repository.


Commands to cancel some actions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to cancel the actions that have been performed in the |wks|, the command ``git reset`` is used with the following options:

1. ``--soft`` # deletes the files from the commit area

2. ``--mixed`` # deletes the files from the staging are (default)

3. ``--hard`` # reinitialize the |wks|

.. note::

   The the ``--mixed`` option includes the ``--soft`` option, and the ``--hard`` option includes the ``--mixed`` option.


.. danger::

   The ``--hard`` option can be very dangerous as you can permanentely lose all your modifications from your |wks|.

Example of reset commands:

-  ``git reset --soft HEAD^`` cancels the last commit

-  ``git reset --soft`` is the inverse of  ``git commit`` (while the commit has not been pushed on the remote repository)

-  ``git reset --mixed HEAD^`` cancels the last (like ``--soft``) and delete the files from the staging area

-  ``git reset --mixed`` is the inverse of ``git add``

-  A typical use case of the command ``git reset --mixed`` is to delete a file that has been added by error in the staging area: ``git reset --mixed my-file-not-to-be-committed``

-  ``git reset --hard HEAD^`` resets all the files from the |wks| to the version before the current ``HEAD`` (some modifications might be lost)


.. note::

   ``HEAD`` is the last commit of the |wks|

-  ``HEAD~5`` is the 5th commit before ``HEAD``

-  ``HEAD^`` is equivalent to ``HEAD~1``



Interaction between the |wks| and the remote repository
-----------------------------------------------------------------

To get the last modifications from the remote repository into your |wks|: ``git pull``

To send your modification from your |wks| into the remote repository: ``git push``

Create tags
-----------

-  list the tags

   ``git tag``

-  add a tag on the last commit (``HEAD``) in the |wks|:

   ``git tag version-1.0.0 -m "[TAG] version-1.0.0``

-  list the information about a tag:

   ``git show version-1.0.0``

-  send the tags into the remote repository:

   ``git push --tags``

-  delete a tag from the |wks|:

   ``git tag -d version-1.0.0``

-  delete a tag from the remote repository:

   ``git push origin :version-1.0.0``

-  add a tag on a previous commit:

   ``git tag version-1.0.0 -m "[TAG] version-1.0.0" hash_du_commit``

Configuration
-------------

-  Identity:

   ``git config --global user.name "<name>"``

   ``git config --global user.email <email>``

-  Default editor:

   ``git config --global core.editor vim`` (or any editor you prefer)

-  List the aliases:

   ``git config -l``

-  Add an alias :

   ``git config <scope> alias.<alias> <commande git>``

   -  ex : ``git config --global alias.co checkout``

   -  ex : ``git config --global alias.last 'log -1 HEAD'``

   -  The following scopes are available:

      ``--global``

      ``--system``

      ``--local``

Useful commands
---------------

-  Initialize a git repository from a existing folder on your computer:

   ``cd <localdir>``

   ``git init (creates the .git folder)``

   ``git add <files>``

   ``git commit -m "message"``

   ``git remote add origin <url>``

   ``git push -u origin master``

-  Information about the files in the |wks|:

   ``git status``

-  Difference between the |wks| and the master branch of the remote repository:

   ``git diff origin/master``

-  Difference between two commits for a file on the same branch:

      ``git diff HEAD^ <file>``

      Add as many `^` as you want to step back (``HEAD^^^``)

-  Difference between two specific commits:

   ``git diff <commit_1> <commit_2> <file>``

-  Information about the last commit in the commit area:

   ``git log``

   ``git log --oneline``

-  Delete a branch from the |wks|:

   ``git branch -d mybranch``

-  Create a local branch named **foo** from the master branch of the remote repository:

   ``git checkout -b foo origin/master``

-  Create a local branch named **bar** that is not supposed to be pushed into the remote repository from the current branch:

   ``git checkout -b bar``

-  Information about the branches that are available in the |wks|:

   ``git branch -vv``
  

- Send a local branch named **foo** in the |wks| into a branch named **bar** in the remote repository:

   ``git push origin foo:bar``

- Delete the branch **bar** from the remote repository:
  
  ``git push origin :bar``

- The syntax is generally ``git push origin localname:remote``. When we want to remove something, just leave the localname empty

- Delete files that are not versioned in the |wks| (beware, you can lose data):

   ``git clean -n`` # dry-run mode

   ``git clean -df``

-  Information about the URL of the remote repository:

   ``git remote -v``

-  Modify the URL of the remote repository:

   ``git remove set-url origin ssh://git@gitlab.com/project.git``

-  Visualize the commit history in an interface:

   ``gitk``

Temporary shelf some modifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Imagine that you modified some files but the modifications are not yet completed to be committed. In the meantime, you have to correct some bug on the **hotfix** branch. The command ``stash`` allows you to store your modifications. Otherwise, you will not be able to checkout the **hotfix** branch.


``git stash`` stashes the current modifications

``git stash list``  lists the existing stashes

``git stash show my_stash_id`` details information about a stash

``git stash apply my_stash_id`` restores the modifications from a stash

``git stash drop my_stash_id`` deletes a stash

Rollback
~~~~~~~~

Imagine that some modifications have been pushed on the remote repository but they should not have been pushed. Therefore, we have to restore the repository at its previous state:

-  go back to the last valid commit with the common ancestor:

   ``git reset --hard 5a15e6c26300bb74cf95fab4b33b6a7288d67524``

-  apply the valid commit between the latest commit and the common ancestor:

   ``git cherry-pick 752bbfcf7d5c6f3998a1a9679e02b1ef015b301f``

   ``git cherry-pick 7446bd2f13b05476d81649ada5c9955ca82d8cb9``

-  push the modifications to the remote repository:

   ``git push -f origin devel``

However, the ``git pull`` will not erase the commits that have been deleted from the remote repository if they are still present in the |wks|:

``git pull``

``git status``

If the ``git status`` outputs a message like *Your branch is ahead of 'origin/devel' by X commit*, it means that the commits are still present on your |wks|. Dot not push anything but:

-  either delete the **devel** branch and recreate it from the remote repository:

   ``git checkout -b revert_backup``

   ``git branch -d devel``

   ``git checkout -b devel origin/devel``

- or force the deletion of unnecessary commits:

   ``git reset --hard origin/devel``

Git and Gitlab
--------------

|gitlaburl|_ is a graphical interface that allows the managements of the projects inside the remote repository.

Track the Issue in the commit message
-------------------------------------

|gitlaburl|_ offers a functionality to report Issues. The ID of an Issue can be added in a commit message for better tracking of the modifications:


``git -m "[BUG] bug correction (Issue #10)"``

This way, the information regarding the commit is tracked directly in the Issue.

Annexes
-------

For more information visit `<https://www.atlassian.com/git>`_

..   This file is part of biogitflow
   
     Copyright Institut Curie 2020-2021
     
     This file is part of the biogitflow documentation.
     
     You can use, modify and/ or redistribute the software under the terms of license (see the LICENSE file for more details).
     
     The software is distributed in the hope that it will be useful, but "AS IS" WITHOUT ANY WARRANTY OF ANY KIND. Users are therefore encouraged to test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data. 
     
     The fact that you are presently reading this means that you have had knowledge of the license and that you accept its terms.


.. _git-advanced:

Git advanced
============

Merge 2 branches from different repositories
--------------------------------------------

How to retrieve code from the source_repo_branch of the source_repo project onto the target_repo_branch of the target_repo:

``git clone htpps://gitlab.com/source_repo``

``git clone https://gitlab.com/target_repo``

``cd target_repo``

``git checkout target_repo_branch``

``git remote add source_repo ../source_repo``

``git fetch source_repo``

``git checkout -b merge-source-target``

``git merge source_repo/branche_source_repo``

At this stage, resolve possible conflicts and commit and then:

``git checkout target_repo_branch``

``git merge merge-source-target``

``git remote rm source_repo``

Add a submodule in a repository
-------------------------------

If you want to create a submodule, you can edit and modify the variables in the file :download:`createSubmodule.bash <data/createSubmodule.bash>` and follow the procedure.

Generate some statistics about the repository
---------------------------------------------

Number of commits by user:

``git shortlog -s -n --since "JUN 30 2018"``

..   This file is part of biogitflow
   
     Copyright Institut Curie 2020-2024
     
     This file is part of the biogitflow documentation.
     
     You can use, modify and/ or redistribute the software under the terms of license (see the LICENSE file for more details).
     
     The software is distributed in the hope that it will be useful, but "AS IS" WITHOUT ANY WARRANTY OF ANY KIND. Users are therefore encouraged to test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data. 
     
     The fact that you are presently reading this means that you have had knowledge of the license and that you accept its terms.


.. include:: substitutions.rst

.. _git-page:

************
Git tutorial
************


.. include:: git-basics.inc.rst
.. include:: git-advanced.inc.rst


.. _git-commit-convention:

Naming convention for the commit messages
=========================================

A prefix among the following is added in the commit message: 

-  **[MODIF]**: modify features or add new ones

-  **[BUGFIX]**: bug correction

-  **[MERGE]**: merge branches

-  **[DOC]**: add/modify documentations

-  **[TAG]**: add a tag

-  **[ADD]**: add new files

-  **[DEL]**: delete files

In the commit message, the number of the Issue related to the modifications is tracked as follows: "[MODIF] Add star mapper (Issue #11)".

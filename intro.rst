..   This file is part of biogitflow
   
     Copyright Institut Curie 2020
     
     This file is part of the biogitflow documentation.
     
     You can use, modify and/ or redistribute the software under the terms of license (see the LICENSE file for more details).
     
     The software is distributed in the hope that it will be useful, but "AS IS" WITHOUT ANY WARRANTY OF ANY KIND. Users are therefore encouraged to test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data. 
     
     The fact that you are presently reading this means that you have had knowledge of the license and that you accept its terms.


.. include:: substitutions.rst

.. _intro-page:

************
Introduction
************

This documentation describes guidelines for the development workflow of a |soft| from software development to deployment in production. The guidelines capitalizes on the |gitflow|_ model.

We assume that the reader is familiar with |git|_ and |gitlab|_. However, we provide a brief :ref:`git-page` and :ref:`gitlab-page`.


The documentation consists of three main sections:


1.  The section :ref:`devel-workflow-overview-page` first describes the general principles of the development workflow we implemented. The branching model is presented along with the different use cases.

2. The section :ref:`nominal-page` then describes the first use case to develop a new release of the |soft|:
 
    - The :ref:`nominal-overview` introduces the different steps of the use case,
    - The :ref:`nominal-technical` details all the actions and command lines step-by-step,
    - The :ref:`nominal-synopsis` summarizes the technical actions.

3. The section :ref:`hotfix-page` then describes the second use case to correct a critical bug that has occurred in the production environment:
 
    - The :ref:`hotfix-overview` introduces the different steps of the use case,
    - The :ref:`hotfix-technical` details all the actions and command lines step-by-step,
    - The :ref:`hotfix-synopsis` summarizes the technical actions.


Prerequisite
============

All the protocols require that you have set up a |gitlab|_ repository as explained in the section :ref:`gitlab-new-project`.

Useful resources
================

Useful resources for `biogitflow` are available here:

- |biogitflowdoc|_
- |biogitflowtemplate|_
- |biogitflowdocsource|_

Cite us
=======

|biogitflowcitation|_


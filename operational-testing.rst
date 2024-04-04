..   This file is part of biogitflow
   
     Copyright Institut Curie 2020-2021
     
     This file is part of the biogitflow documentation.
     
     You can use, modify and/ or redistribute the software under the terms of license (see the LICENSE file for more details).
     
     The software is distributed in the hope that it will be useful, but "AS IS" WITHOUT ANY WARRANTY OF ANY KIND. Users are therefore encouraged to test the software's suitability as regards their requirements in conditions enabling the security of their systems and/or data. 
     
     The fact that you are presently reading this means that you have had knowledge of the license and that you accept its terms.


.. |step-gitlab-ci-optest| image:: images/gitlab-ci-optest-schedule.png

.. include:: substitutions.rst

.. _gitlab-ci-optest-page:

Schedule an operational testing periodically in |gitlabci|
==========================================================

This section describes how to configure an operational testing with |gitlab|.

The ``.gitlab-ci.yml`` makes it possible to run operational testing to check the reproducibility of the pipeline. To do so, it is needed to configure a *CI/CD Schedules* using the **main** branch:

|step-gitlab-ci-optest|

It triggers a child pipeline that will also check that `optest/optest.sh` script works.



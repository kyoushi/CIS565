===========================================
Robot Framework with Playwright - CIS565
===========================================

`Robot Framework`_ is a generic open source test automation framework.
In addition to introducing Robot Framework test data syntax, this demo
integrates the `Browser Library` powered by `Playwright`.
Playwright is a framework for Web Testing and Automation.
Our project shows how to execute test cases, how generated reports and logs
look like, and how to extend the framework with custom test libraries like `Requests` and `Database`.

.. contents:: **Contents:**
   :depth: 1
   :local:

Demo package
========================

To get the demo webApp `cypress-realworld-app` clone https://github.com/cypress-io/cypress-realworld-app/tree/v1.0.18
and follow the README file instructions.

__ `running demo`_

Demo application
================

The demo application is a webApp Built with React, XState, Express, lowdb, Material-UI 
and TypeScript. `cypress-realworld-app` is a Github project that demo cypress E2E automation.
We will use `cypress-realworld-app` to automate E2E testcases using the `Robot Framework`

Test cases
==========

The demo contains three different test case files illustrating three different
approaches for creating test cases with Robot Framework. Click file names below
to see the latest versions online.



As you can see, creating test cases with Robot Framework is very easy.
See `Robot Framework User Guide`_ for details about the test data syntax.

Test library
============
Browser
Requests
Database

Generated results
=================

After `running tests`_, you will get report and log in HTML format. Example
files are also visible online in case you are not interested in running
the demo yourself. Notice that one of the test has failed on purpose to
show how failures look like.

- `report.html`_
- `log.html`_

Running demo
============

Preconditions
-------------

A precondition for running the tests is having `Robot Framework`_ installed.
It is most commonly used on Python_ but it works also with Jython_ (JVM)
and IronPython_ (.NET). Robot Framework `installation instructions`_
cover installation procedure in detail. People already familiar with
installing Python packages and having `pip`_ package manager installed, can
simply run the following command::
    pip install -r requirements.txt

    or

    pip install robotframework
    
    Install node.js e.g. from https://nodejs.org/en/download/
    Update pip pip install -U pip to ensure latest version is used
    Install robotframework-browser from the commandline: pip install robotframework-browser
    Install the node dependencies: 
    run rfbrowser init (on Windows)
    Run `rfbrowser init` (on Mac OS X)
    
    pip install robotframework-requests

Robot Framework 3.0 and newer support Python 3 in addition to Python 2. Also
this demo project is nowadays Python 3 compatible.

Running single tests
-------------

Test cases are executed with the ``robot`` command::

    robot test_name.robot
    or
    python -m robot -d Results test_name.robot

Running test suites
-------------

Test cases are executed with the ``robot`` command::

    robot -d ResultsUI --pythonpath . ui_tests
    robot -d ResultsAI --pythonpath . api_tests
    or
    python -m robot -d ResultsUI --pythonpath . ui_tests

.. note:: If you are using Robot Framework 2.9 or earlier, you need to
          use Python interpreter specific command ``pybot``, ``jybot`` or
          ``ipybot`` instead.

To execute all test case files in a directory recursively, just give the
directory as an argument. You can also give multiple files or directories in
one go and use various command line options supported by Robot Framework.
The results `available online`__ were created using the following command::

    robot --name Robot --loglevel DEBUG keyword_driven.robot data_driven.robot gherkin.robot

Run ``robot --help`` for more information about the command line usage and see
`Robot Framework User Guide`_ for more details about test execution in general.

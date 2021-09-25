# Acceptance

The Acceptance/Functional/Operational_Validation tests folder should only contain the following tests:

* Tests that impact the environment. For example, after creating a folder executed by the code. The server apps still work as expected.

* Tests user experience. Such as, users able to access the folder or not?

* Tests the desired outcome of your script.

# Integration

The Integration tests folder should only contain the following tests:

* Concentrates on the code's outcome. Such as if the code should create a folder. To make sure it was created after the code was executed.

* If it outputs an object, that it contains the right properties.

* If a PS1XML file formats exists for the object that it works as expected.

* Slower than Unit test because you might have to wait for connections to be established or for something to sync.

* Might have environment dependencies

* Tests a particular chunk of code by compiling your entire project and run the whole thing.

# Unit

The Unit tests folder should only contain the following tests:

* Tests the code itself. That the code is for example following the right workflow based on parameters. In other words, your logic works.

* The environment is not tested in this section.

* Specific to the language, in this case specific to PowerShell.

* Should be fast because they do not worry if things have been created, connections been established. They just test the logic.

* Tests a particular chunk of code all by itself, feeding it various inputs and checking its outputs, in a standalone fashion
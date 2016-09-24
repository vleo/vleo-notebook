QThread HOWTO
-------------

This example shows the recommended way of using QThread as an interface for convenient creation of concurrent tasks in a Qt application.
Object oriented threading means that worker functionality is encapsulated in a QObject subclass. Many cooperating worker objects can be
created in this way, with inter-object communication taking place using Qt signals and slots. 

A simple QThread subclass is created that
has just one re-implemented method - run(). Run calls exec() and that's it. To move the worker object affinity to that thread, moveToThread(QThread*) 
is called and the thread is started with start().

The worker object can then send and receive signals from the GUI or from other worker objects. 

The main point to note is that the QThread is created without a parent and moveToThread is NOT called in the constructor of the QThread itself - why would
you want to move a thread to itself?

In this way, a truly object oriented threading paradigm is realised, with the obvious advantages of keeping a simple threading interface and a clean and 
convenient way of inter-thread communication.


Running the Demo Application
----------------------------

To run the demo, build the client and server applications. Start the server and either select a new port or use the default. Once the server is started, you may receive a message on some OS's about unblocking the port. Click on "OK" or whatever it happens to say.

The client can now be started. Click on File->Configuration and select the data block size and the interval at which you want blocks of data to be sent. This is a push client which periodically uploads packets to the server. 

Once you've set the configuration, you can click Test->Create Clients. This opens 6 separate client windows by default. You can increase or decrease this in the configuration.

Next, check the "auto upload" button if you want packets to be sent continuously. Now you can either connect the clients individually or use Test->Connect All from the menu.
Once they are connected, you should see connection messages appear on the server output window. To start sending data, either click "Start" on a client or use the Test->Start All menu option.

The test can be left running indefinitely as a good benchmark of QTcpSocket and to demonstrate concurrency in the client and server.

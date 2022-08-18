# Nova Salesforce Logging Framework

## Overview

Another logging framework! I wanted a fast, no frills logger to store durable logs for future viewing without require an active debug trace. The main point is to be incredibly simpe to use, without all of the bloat of some of the more popular logging frameworks.   

**Deploy to Salesforce Org:**
[![Deploy](https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png)](https://githubsfdeploy.herokuapp.com/?owner=seesharpist&repo=Nova-Salesforce-Logger&ref=main)

## Features: ##
 - **Single-line API** for logging events within Salesforce
 - Leverages Salesforce's **Platform Event** architecture for real-real teim event monitoring and robust integrations 
 - Uses out-of-the-box Apex **LoggingLevel** enum values
 - Included batch/scheduled class delete log records as defined by your own retention policy
 - Customizable, single-page Logging Dashboard  


## Usage

To create a new durable log record, call a single method for the required log type needed from **Logger.cls**. Pass in the Class name you are logging from and a message you'd like to log. Here is an example for creating an 'INFO' level log:

```java
Logger.info('MyTestClass', 'I would tell you a UDP joke, but you might not get it.');
```
Logging an **exception** is no exception. Just call from the catch of a `try/catch` block. Exceptions will additionally log the exact line number the exception was raised from and the entire stack trace, making it easy to pinpoint issues.

```java
try {
  Integer uhoh = 3/0;
}
catch(Exception e) {
  Logger.exception('ErrorMcErrorface', e);
}
```
**Note:** All logging calls will log to console AND generate a log entry event EXCEPT '.debug', which only logs to console.

Most **LoggingLevel** values are supported.
* `debug()`
* `info()`
* `warn()`
* `error()`
* `exception()`

## Deleting Logs
Two Apex classes are provided out-of-the-box to handle automatically deleting old logs

 - 'LogEntryCleanupBatch' - this batch Apex class will delete any Log_Entry__c records older than a specified number of days defined inside an Application Configuration mdt record (Log_Retention_Duration). Defaults to thirty (30) days.

 - 'LogEntryCleanupSchedulable' - this schedulable Apex class can be schedule to run 'LogEntryCleanupBatch' on a custom basis, usually daily.


## Future State!

Several quality of life and performance features are in the works, including:

### Overloads for Logging Methods (Currently WIP)

- Adding overloads that allow bulk publishing of log entries
- Tie ins to sObject records
- Logging Database.SaveResult lists

### Bulk Publishing
Currently, 'Logger' only publishes one entry at a time. Soon, whole lists will be able to be published to improve efficientcy and stay below governor limits

### Related Log Lists for Records (WIP)
The ability to tie logs directly to object records will speed up debugging of issues with specific records and allow for logging of relevant life cycle events

### Flow/Process Builder Logger API
Being able to log from Flows and Processes will give Admins the ability to properly log and diagnose issues without using a single line of code

### Support for Remaining LoggingLevels
 - FINE, FINER, FINEST, etc

### Permission Sets and Groups

### Real-time Event Logging Monitor
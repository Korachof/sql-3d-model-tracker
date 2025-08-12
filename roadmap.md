# Project Roadmap – SQL 3D Model Tracker

## Phase 1: Core Schema & Functionality

- [x] Scaffold folder and file structure
- [x] Define core tables and views
- [x] Finalize naming conventions and file headers

### [x] Implement stored procedures for model and print tracking

- [x] Add procedure for models
- [x] Add procedure for printers
- [x] Add procedure for tags
- [x] Add procedure for model print records
- [x] Junction procedure for adding tags to models
- [x] Read procedure for models
- [x] Read procedure for getting tags assigned to specific models
- [x] Read procedure for printers
- [x] Read procedure for tags
- [x] Read procedure for model print logs
- [x] Read procedure for getting print logs associated with a specific model
- [x] Read procedure for getting print logs associated with a specific printer
- [x] Read procedure for getting models by tag
- [x] Read procedure to get model details (model info, associated tags, past print logs involving that model)
- [x] Update procedure for models
- [x] Update procedure for printers
- [x] Update procedure for tags
- [x] Update procedure for print logs
- [x] Delete procedure for models
- [x] Delete procedure for tags
- [x] Delete procedure for printers
- [x] Delete procedure for print logs
- [x] Delete procedure to remove tags from models

### [x] Implement test queries for stored procedures and tables

- [x] Test AddModel
- [x] Test AddPrinter
- [x] Test AddTag
- [x] Test AssignTagToModel
- [x] Test GetModels
- [x] Test GetTagsForModel
- [x] Test RecordModelPrint
- [x] Test GetPrinters
- [x] Test GetTags
- [x] Test GetPrintLogs
- [x] Test GetPrintLogsForModel
- [x] Test for GetPrintLogsforPrinter
- [x] Test GetModelsByTag
- [x] Test GetModelDetails
- [x] Test UpdateModel
- [x] Test UpdatePrinter
- [x] Test UpdateTag
- [x] Test UpdatePrintLog
- [x] Test DeleteModel
- [x] Test DeleteTag
- [x] Test DeletePrinter
- [x] Test DeletePrintLog
- [x] Test RemoveTagFromModel

- [x] Include tag parsing and assignment during import
  - Completed from the Database side, need logic for client-side
- [x] Document procedure inputs and output formats
  - Detailed header blocks complete for each procedure

## Phase 2: Usability & Query Enhancements

### [ ] Add sorting and pagination helpers

- #### Models Table

  - [x] Add optional parameters for Sortby, SortDirection, PageNumber, and PageSize
  - [x] Update Models ORDER BY clause with a case statement to alter sorting
  - [x] Add pagination and filtering to Models via dynamic querying
  - [x] Create a test script for the newly enhanced feature, including mocking a lot more data to test for filter purposes

- #### Tags Table

  - [x] Add optional parameters for Sortby, SortDirection, PageNumber, and PageSize
  - [x] Update Tags ORDER BY clause with a case statement to alter sorting
  - [x] Add pagination and filtering to Tags newly enhanced feature, including mocking a lot more data to test for filter purposes
  - [] Create a test script for the newly enhanced feature, including mocking a lot more data to test for filter purposes

- #### Printers Table

  - [x] Add optional parameters for Sortby, SortDirection, PageNumber, and PageSize
  - [x] Update Printers ORDER BY clause with a case statement to alter sorting
  - [x] Add pagination and filtering to Printers newly enhanced feature, including mocking a lot more data to test for filter purposes
  - [x] Create a test script for the newly enhanced feature, including mocking a lot more data to test for filter purposes

- #### PrintLogs Table

  - [x] Add optional parameters for Sortby, SortDirection, PageNumber, and PageSize
  - [x] Update PrintLogs ORDER BY clause with a case statement to alter sorting
  - [x] Add pagination and filtering to PrintLogs newly enhanced feature, including mocking a lot more data to test for filter purposes
  - [x] Create a test script for the newly enhanced feature, including mocking a lot more data to test for filter purposes

- #### Models by Tag Table

  - [x] Add optional parameters for Sortby, SortDirection, PageNumber, and PageSize
  - [x] Update ModelsbyTag ORDER BY clause with a case statement to alter sorting
  - [x] Add pagination and filtering to ModelsByTag newly enhanced feature, including mocking a lot more data to test for filter purposes
  - [x] Create a test script for the newly enhanced feature, including mocking a lot more data to test for filter purposes

- #### Tags for Model Table

  - [x] Add optional parameters for Sortby, SortDirection, PageNumber, and PageSize
  - [x] Update TagsForModel ORDER BY clause with a case statement to alter sorting
  - [x] Add pagination and filtering to TagsForModel newly enhanced feature, including mocking a lot more data to test for filter purposes
  - [x] Create a test script for the newly enhanced feature, including mocking a lot more data to test for filter purposes

- #### Print Logs for Model Table

  - [x] Add optional parameters for Sortby, SortDirection, PageNumber, and PageSize
  - [x] Update PrintLogsForModel ORDER BY clause with a case statement to alter sorting
  - [x] Add pagination and filtering to PrintLogsForModel newly enhanced feature, including mocking a lot more data to test for filter purposes
  - [x] Create a test script for the newly enhanced feature, including mocking a lot more data to test for filter purposes

- #### Print Logs for Printer Table

  - [] Add optional parameters for Sortby, SortDirection, PageNumber, and PageSize
  - [] Update PrintLogsForPrinter ORDER BY clause with a case statement to alter sorting
  - [] Add pagination and filtering to PrintLogsForPrinter newly enhanced feature, including mocking a lot more data to test for filter purposes
  - [] Create a test script for the newly enhanced feature, including mocking a lot more data to test for filter purposes

- #### Model Details Table

  - [] Add optional parameters for Sortby, SortDirection, PageNumber, and PageSize
  - [] Update ModelDetails ORDER BY clause with a case statement to alter sorting
  - [] Add pagination and filtering to ModelDetails newly enhanced feature, including mocking a lot more data to test for filter purposes
  - [] Create a test script for the newly enhanced feature, including mocking a lot more data to test for filter purposes

- #### Additional Features To Add
- [ ] Create additional views (e.g. print stats, tag filters)
- [ ] Implement licensing filter logic
- [ ] Add indexing strategy and performance checks
- [ ] Fill out testing suites

## Stretch Goals

- [ ] Track user or print location metadata
- [ ] Build lightweight UI or admin dashboard
- [ ] Build Thingiverse importer logic
- [ ] Export recent prints to JSON or CSV
- [ ] Hook in other sources (e.g. Printables, Cults3D)
- [ ] Integrate thumbnail imports for a visually rich UI

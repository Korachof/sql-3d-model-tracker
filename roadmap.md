# Project Roadmap – SQL 3D Model Tracker

## Phase 1: Core Schema & Functionality

- [x] Scaffold folder and file structure
- [x] Define core tables and views
- [x] Finalize naming conventions and file headers

### [ ] Implement stored procedures for model and print tracking

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
- [ ] Read procedure for getting print logs associated with a specific printer
- [ ] Read procedure for getting models by tag
- [ ] Read procedure to get model details (model info, associated tags, past print logs involving that model)
- [ ] Update procedure for models
- [ ] Update procedure for printers
- [ ] Update procedure for tags
- [ ] Update procedure for print logs
- [ ] Delete procedure for models
- [ ] Delete procedure for tags
- [ ] Delete procedure for printers
- [ ] Delete procedure for print logs
- [ ] Delete procedure to remove tags from models

### [ ] Implement test queries for stored procedures and tables

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
- [ ] Test for GetPrintLogsforPrinter
- [ ] Test GetModelsByTag
- [ ] Test GetModelDetails
- [ ] Test UpdateModel
- [ ] Test UpdatePrinter
- [ ] Test UpdateTag
- [ ] Test UpdatePrintLog
- [ ] Test DeleteModel
- [ ] Test DeleteTag
- [ ] Test DeletePrinter
- [ ] Test DeletePrintLog
- [ ] Test RemoveTagFromModel

- [ ] Build Thingiverse importer logic
- [ ] Include tag parsing and assignment during import
- [ ] Document procedure inputs and output formats

## Phase 2: Usability & Query Enhancements

- [ ] Create additional views (e.g. print stats, tag filters)
- [ ] Add sorting and pagination helpers
- [ ] Implement licensing filter logic
- [ ] Add indexing strategy and performance checks

## Stretch Goals

- [ ] Track user or print location metadata
- [ ] Build lightweight UI or admin dashboard
- [ ] Export recent prints to JSON or CSV
- [ ] Hook in other sources (e.g. Printables, Cults3D)
- [ ] Integrate thumbnail imports for a visually rich UI

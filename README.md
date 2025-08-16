# 3D Model Print Tracker

A comprehensive SQL Server-powered database for tracking 3D printable models. This project provides a robust back-end API for managing a collection of models, printers, and print logs, complete with advanced filtering, sorting, and pagination.

## Table of Contents

- [Features](#features)
- [Database Schema](#database-schema)
- [Stored Procedure API](#stored-procedure-api)
- [Testing and Database Scripts](#testing-and-database-management-scripts)
- [Setup and Installation](#setup--installation)

## Features

Model & Metadata Storage: Store detailed information for each 3D model, including name, source URL, license type, and description.

Printer Management: Keep a catalog of your 3D printers, including brand, model, and printing technology (e.g., Filament, Resin).

Tagging System: Organize your collection with a flexible tagging system, allowing for many-to-many relationships between models and tags.

Detailed Print Logging: Record every print job with key details like the model and printer used, start/end times, material, and status.

Robust Database API: A complete set of stored procedures provides full CRUD (Create, Read, Update, Delete) functionality.

Advanced Querying: Procedures for retrieving lists of data include powerful and secure options for dynamic sorting, filtering, and pagination.

Data Integrity: The schema is designed with unique constraints and foreign keys with cascading deletes to ensure data remains clean and consistent.

Analytical Views: Pre-built database views provide summarized statistics for printer performance, tag usage, and more.

## Database Schema

The database is designed with a normalized structure to ensure data integrity and prevent redundancy. The core tables are:

**dbo.Models**: Stores the primary information for each 3D model.

**dbo.Tags**: A list of all unique tags.

**dbo.Printers**: A list of all unique 3D printers.

**dbo.PrintLog**: Records each individual print event.

**dbo.ModelTags**: A junction table creating the many-to-many relationship between models and tags.

## Stored Procedure API

The primary way to interact with the database is through the following stored procedures:

### Add Procedures

**dbo.AddModel**: Adds a new model or returns the ID of an existing one based on SourceURL.

**dbo.AddPrinter**: Adds a new printer or returns the ID of an existing one.

**dbo.AddTag**: Adds a new tag or returns the ID of an existing one.

**dbo.AssignTagToModel**: Links a tag to a model.

**dbo.RecordModelPrint**: Logs a new print event.

### Get (Read) Procedures

**dbo.GetModels**: Retrieves a paginated and sorted list of all models, with optional filtering by license.

**dbo.GetPrinters**: Retrieves a paginated and sorted list of all printers.

**dbo.GetTags**: Retrieves a paginated and sorted list of all tags.

**dbo.GetPrintLogs**: Retrieves a paginated and sorted list of all print logs.

**dbo.GetModelDetails**: A powerful procedure that returns three result sets for a single model: its core details, its assigned tags, and its full print history.

**dbo.GetPrintLogsForModel**: Retrieves a paginated and sorted list of print logs for a specific model.

**dbo.GetPrintLogsForPrinter**: Retrieves a paginated and sorted list of print logs for a specific printer.

**dbo.GetModelsByTag**: Retrieves a paginated list of all models assigned to a specific tag.

**dbo.GetTagsForModel**: Retrieves a paginated list of all tags assigned to a specific model.

### Update (Edit) Procedures

**dbo.UpdateModel**: Updates the details for an existing model.

**dbo.UpdatePrinter**: Updates the details for an existing printer.

**dbo.UpdateTag**: Updates the name for an existing tag.

**dbo.UpdatePrintLog**: Updates the details for an existing print log entry.

### Delete Procedures

**dbo.DeleteModel**: Deletes a model and its associated data from the database.
Associated ModelTags and PrintLog entries are removed automatically by the ON DELETE CASCADE constraint.

**dbo.DeletePrinter**: Deletes a printer from the database. Associated PrintLog
entries are removed automatically by the ON DELETE CASCADE constraint.

**dbo.DeleteTag**: Deletes a tag from the database. Associated ModelTags entries are removed automatically by the ON DELETE CASCADE constraint.

**dbo.DeletePrintLog**: Deletes a single print log entry from the database.

**dbo.RemoveTagFromModel**: Removes a specific tag assignment from a model by deleting the corresponding record in the dbo.ModelTags junction table.

### View Procedures

**dbo.vw_MaterialUsageSummary**: Creates a view that summarizes print statistics for each type of material used.

**dbo.vw_ModelPrintSummary**: Creates a view that calculates and summarizes print statistics for each model in the database.

**dbo.vw_PrinterPerformanceSummary**: Creates a view that calculates and summarizes performance metrics for each printer in the database.

**dbo.vw_Recent3DPrints**: Creates a view that shows the 10 most recent print logs.

**dbo.vw_TagUsageSummary**: Creates a view that summarizes tag usage by counting how many models are associated with each tag.

## Testing and Database Management Scripts

### Add Test Scripts

**TestAddModel**: Tests AddModel by deleting the table data, and then creating model testing data. Tests for verification, as well as NULL and NOT NULL data.

**TestAddPrinter**: Tests AddPrinter by deleting the table data, and then creating printer testing data. Tests for verification, as well as NULL and NOT NULL data.

**TestAddTag**: Tests AddTag by deleting the table data, and then creating tag testing data. Tests for verification, as well as NULL and NOT NULL data.

**TestAssignTagToModel**: Tests AssignTagToModel by deleting the table data, and then creating model and tag testing data before assigning tags to models for testing. Tests for verification, as well as NULL and NOT NULL data.

**TestRecordModelPrint**: Tests RecordModelPrint by deleting the table data, and then creating model and printing testing data before creating test print log entries. Tests for verification, as well as NULL and NOT NULL data.

### Get (Read) Test Scripts

**TestGetModels**: Tests GetModels by deleting the table data, and then creating model testing data. Tests for verification, filtering, sorting, and pagination.

**TestGetPrinters**: Tests GetPrinters by deleting the table data, and then creating printers testing data. Tests for verification, filtering, sorting, and pagination.

**TestGetTags**: Tests GetTags by deleting the table data, and then creating tag testing data. Tests for verification, filtering, sorting, and pagination.

**TestGetPrintLogs**: Tests GetPrintLogs by deleting the table data, and then creating model and printing testing data before creating print log entries for testing. Tests for filtering, sorting, and pagination.

**TestGetModelDetails**: Tests GetModelDetails by deleting the table data, and then creating model, printer, and tag testing data before using AssignTagToModel and AddPrintLog to create relationships. Tests for filtering, sorting, and pagination for all three created tables.

**TestGetPrintLogsForModel**: Tests GetPrintLogsForModel by deleting the table data, and then creating model and printer testing data before creating print log entries for testing. Tests for filtering, sorting, and pagination.

**TestGetPrintLogsForPrinter**: Tests GetPrintLogsForPrinter by deleting the table data, and then creating model and printer testing data before creating print log entries for testing. Tests for filtering, sorting, and pagination.

**TestGetModelsByTag**: Tests GetModelsByTag by deleting the table data, and then creating model and tag testing data before using AssignTagToModel to create a tag/model relationship for testing. Tests for filtering, sorting, and pagination.

**TestGetTagsForModel**: Tests GetTagsForModel by deleting the table data, and then creating model and tag testing data before using AssignTagToModel to create a tag/model relationship for testing. Tests for filtering, sorting, and pagination.

### Update (Edit) Test Scripts

**TestUpdateModel**: Tests UpdateModel by deleting the table data, and then creating model testing data. Tests for verification and NULL and NOT NULL data.

**TestUpdatePrinter**: Tests UpdatePrinter by deleting the table data, and then creating printer testing data. Tests for verification and NULL and NOT NULL data.

**TestUpdatePrintLog**: Tests UpdatePrintLog by deleting the table data, and then creating model and printer testing data before using RecordModelPrint to create print log entries for testing. Tests for verification and NULL and NOT NULL data.

**TestUpdateTag**: Tests UpdateTag by deleting the table data, and then creating model and tag testing data. Tests for verification and NULL and NOT NULL data.

### Delete Test Scripts

**TestDeleteModel**: Tests DeleteModel by deleting the table data, and then creating model, printer, and tag testing data. Uses AssignTagToModel and RecordModelPrint to test that child tables also get removed when a model is removed.

**TestDeletePrinter**: Tests DeletePrinter by deleting the table data, and then creating model and printer testing data. Uses RecordModelPrint to test that child tables also get removed when a printer is removed.

**TestDeleteTag**: Tests DeleteTag by deleting the table data, and then creating model and tag testing data. Uses AssignTagToModel to test that child tables also get removed when a tag is removed.

**TestDeletePrintLog**: Tests DeletePrintLog by deleting the table data, and then creating model and printer testing data. Uses RecordModelPrint to test that the print log entry is removed successfully.

**TestRemoveTagFromModel**: Tests RemoveTagFromModel by deleting the table data, and then creating model and tag testing data. Uses AssignTagToModel to test that the child table is removed successfully.

### View Test Scripts

**TestViewMaterialUsageSummary**: Tests vw_MaterialUsageSummary by deleting the table data, and then creating model and printer testing data before using RecordModelPrint to create testing print logs. Tests that the material data is accurately shown in the table.

**TestViewModelPrintSummary**: Tests vw_ViewModelPrintSummary by deleting the table data, and then creating model and printer testing data before using RecordModelPrint to create testing print logs. Tests that the model print data is accurately shown in the table.

**TestViewPrinterPerformanceSummary**: Tests vw_PrinterPerformanceSummary by deleting the table data, and then creating model and printer testing data before using RecordModelPrint to create testing print logs. Tests that the printer success and fail data is accurately shown in the table.

**TestViewRecent3DPrints**: Tests vw_Recent3DPrints by deleting the table data, and then creating model and printer testing data before using RecordModelPrint to create testing print logs. Tests that the last 10 prints are accurately shown in the table.

**TestViewTagUsageSummary**: Tests vw_TagUsageSummary by deleting the table data, and then creating model and tag testing data before using AssignTagToModel to create testing data. Tests that the tag usage data is accurately shown in the table.

### Optional Scripts

**ResetDemoData**: Wipes all data from the database and seeds it with a curated set of sample data for demonstration purposes. _Only used in the Demo version for resetting a demo client-side application_

**ResetTables**: Wipes all data from the database tables. _Only used by developers in the event where all data needs to be wiped from the tables while maintaining the table structure_

**ResetDatabase**: Wipes all data from the database and recreates the database without the tables. _Only used by Developers in the event that the database needs to be wiped without re-creating the tables_

## Setup & Installation

### 1. Build the Deployment Script

First, download the project file and all of its contents from GitHub [here](https://github.com/Korachof/sql-3d-model-tracker). Click on Code (green button), and Download Zip.

Unzip all files in the place of your choosing.

Next, you need to generate the deployment script. Choose the appropriate build script for your target environment:

#### For a Demo Environment (includes ResetDemoData procedure):

In Windows File Explorer, double-click the build-demo.bat file located in the project's root directory.

This will generate a new file named Deploy-Demo.sql, also located in the root directory.

#### For a Production Environment (secure, no reset procedure):

In Windows File Explorer, double-click the build-prod.bat file located in the project's root directory.

This will generate a new file named Deploy-Prod.sql, also located in the root directory.

### 2. Execute the Deployment Script

Once the deployment script has been generated, you can run it to create the database.

Ensure you have an instance of SQL Server (2012 or newer) running. You can find instructions for installing the newest version [here](https://www.microsoft.com/en-us/sql-server/sql-server-downloads).

Connect to your server using a tool like SQL Server Management Studio (SSMS). For SSMS, you can find instructions on downloading the latest version [here](https://learn.microsoft.com/en-us/ssms/install/install).

After you've installed SQL Server and your environment, go through the steps to creating a new database, and connect. Your initial connection should be to the master database.

Open the generated deployment script (Deploy-Demo.sql or Deploy-Prod.sql). In SSMS, go to File -> Open -> File... -> find the sql-3d-model-tracker folder in your computer -> deployment script (either Deploy-Demo.sql or Deploy-Prod.sql, depending on your use-case). Click Open.

Execute the entire script. Make sure you are connected to Master. Click the "Execute" button with the green arrow.

This single step will create the ThreeDModelsTrackerDB database with the correct collation, build all necessary tables, and create all the views and stored procedures.

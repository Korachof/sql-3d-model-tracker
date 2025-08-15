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

### Update (edit) Procedures

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

### Test Scripts

### Optional Scripts

## Setup & Installation

To create and set up the database, follow these steps:

Ensure you have an instance of SQL Server (2012 or newer) running.

Connect to the server using a tool like SQL Server Management Studio (SSMS).

Execute the CreateTables.sql script. This will create the ThreeDModelsTrackerDB database with the correct collation and build all necessary tables.

Execute all of the individual stored procedure and view files from the procedures/ and views/ folders.

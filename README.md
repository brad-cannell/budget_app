
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Notes for My Personal Budget App

Created: 2023-01-01  
Updated: 2023-01-03

<!-- badges: start -->
<!-- badges: end -->

This private repository is for my personal budget app. This is really
experimental at this point.

# Instructions

1.  Use NOTES for notes, but not for tasks. *Why* or *how*, but *not
    what*. For now, I’m making this a **private** repository. Because
    it’s a private repository, GitHub won’t allow me to create a wiki.
    For now, I will use README like a wiki.

2.  Create and manage tasks in the [GitHub project](). That way they are
    tracked, versioned, easy to find, easy to share, and hard to lose
    over time.

# Useful links

- [Link to GitHub
  repository](https://github.com/brad-cannell/budget_app)
- [Link to GitHub
  project](https://github.com/orgs/brad-cannell/projects/15/views/1)
- [Link to Google
  Sheet](https://docs.google.com/spreadsheets/d/1WwseDMbA9OTkwhb51wMKgJfVlayhp-j65tf7MYfwhZ4/edit#gid=1109763561)

# Project overview

I’m trying to create a Shiny application that I can use to track and pay
bills. Ideally, this application will replace the [Google Sheet that I’m
currently
using](https://docs.google.com/spreadsheets/d/1WwseDMbA9OTkwhb51wMKgJfVlayhp-j65tf7MYfwhZ4/edit#gid=1109763561).

## Why go to the trouble of doing this?

1.  For the experience. I still haven’t built many Shiny applications.
    This feels like a good way for me to get experience in a low-stakes
    environment.

2.  Potential advantages of this method over the spreadsheets I’ve been
    using.

    - Data storage is separated from data entry/management. This makes
      errors less likely to occur.

    - Dashboards. I should be able to more easily create dashboards with
      R that allow me to get more actionable information out of my
      budget.

    - Tracking over time. It should be easier to track my budget over
      time (i.e., across years) with this method than with separate
      yearly workbooks.

# Design and formatting

## Databse vs CSV data tables

Eventually, I may want to use SQLite or something for data storage.
However, there will be a little bit of a learning curve for me to go
that route. For now, I will start by building the app with flat files.
Later, I may decided to move the data over to a database of some sort.

## Table Types

1.  Object tables: Each record of this type of table holds information
    that relates to a real-world object.

2.  Transaction tables: Each record of a transaction table holds
    information about an event.

3.  Join tables: When many-to-many relationships exist, a join table
    sits in the middle of the two tables. A join table generally hos
    only three fields: a unique field to identify each record, a
    reference to one side of the association, and a reference to the
    other side of an association.

## Normalization

1.  First normal form (1NF): Each cell of a table must contain only a
    single value, and the table must not contain repeating groups of
    data (e.g., columns named title1, title2, title3)

2.  Second normal form (2NF): Data not directly dependent on the table’s
    primary key is moved into another table. All the data in a row that
    isn’t an integral part of the entity is moved to a different table.
    For example, a customer and a book may be an integral part of an
    order, but a customer name and a book title are not. While the
    customer may change names, the customer can’t change the pk\_
    Customer because we created it and we control it. Similarly, the
    publisher may change the book’s title but not the pk\_ book. The
    primary keys are reliable pointers to the objects they identify,
    regardless of what other information may change.

- Also, values that repeat in multiple records is an indicator that the
  data is not yet in second normal form (e.g., orders and orders
  details). Some data, like foreign keys, are meant to repeat. Other
  data, like dates and quantities, repeat naturally and aren’t
  indicative of a problem.

3.  Third normal form (3NF) requires removing all fields that can be
    derived from data contained in other fields in the table or other
    tables in the database.

## Naming rules

Rules for consistently naming different database/app components.

### Tables

1.  They should be descriptive
2.  Snake case

Examples:

1.  `payees`
2.  `payee_details`

### Key fields

1.  Assign a primary key field to every table using the form
    `pk_table_name`.

2.  Assign foreign keys as needed using the form `fk_table_name`.

### Other fields:

1.  They should have descriptive names
2.  Start with the table name
3.  Use snake case
4.  Group similar fields with a common key word (e.g., address\_)

Examples: 1. `payee_address_street` 2. `payee_address_city` 3.
`payee_details_date_account_open` 4. `payee_details_date_account_close`

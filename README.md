
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Notes for My Personal Budget App

Created: 2023-01-01  
Updated: 2023-01-01

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

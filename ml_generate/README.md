# ML_GENERATE Function
Example of using ML_GENERATE to have BigQuery sql statements call Google PaLM models to summarize content and detect sentiment.

## Description
This repository contains some scripts to setup the table to use for the example as well as populate it with data. This was created by following this [tutorial](https://cloud.google.com/bigquery/docs/generate-text-tutorial).

### Setup
1. Create a [dataset](https://cloud.google.com/bigquery/docs/generate-text-tutorial#create_a_dataset) called `llm_demo` (or something else, but make sure to change it in the scripts)
2. Create an [external connection](https://cloud.google.com/bigquery/docs/generate-text-tutorial#create_a_connection) to enable integration with Vertex AI
  * This requires **BigQuery administrator role**. 
  * Use connection type for Vertex AI
3. Give the BigQuery service account [permissions](https://cloud.google.com/bigquery/docs/generate-text-tutorial#grant-permissions) to use Vertex endpoints

### Running the scripts
1. Follow instructions in the script `setup_scripts` to create the table and model
2. Follow the script `data_scripts` to import the data into the table
3. Follow the instructions in `sample_queries` to run the sql statements to see how **ML_GENERATE** works
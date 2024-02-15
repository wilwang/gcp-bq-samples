
-- Drop the table if you need to re-create
DROP TABLE llm_demo.doc_summaries;

-- Create a table to store the data
CREATE TABLE llm_demo.doc_summaries (
  docid STRING DEFAULT GENERATE_UUID(),
  fulltext STRING,
  summary STRING,
  bullet_points STRING,
  sentiment STRING
);

-- Create the model. Make sure to put in your PROJECT_ID
CREATE MODEL `[PROJECT_ID].llm_demo.textbison32`
REMOTE WITH CONNECTION `[PROJECT_ID].us.vertex_connection`
OPTIONS(ENDPOINT = 'text-bison-32k');

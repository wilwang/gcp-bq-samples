-- summarize into bullet points. make sure to replace [PROJECT_ID] with your actual project id
SELECT
  ml_generate_text_result.predictions[0].content AS bullet_points,
  docid 
FROM
  ML.GENERATE_TEXT(
    MODEL `[PROJECT_ID].llm_demo.textbison32`,
    (SELECT CONCAT('Summarize the following text into main bullet points:',fulltext)AS prompt,
        docid
      FROM `[PROJECT_ID].llm_demo.doc_summaries`),
    STRUCT (0.1 AS temperature, 8192 AS max_output_tokens, 0.1 AS top_p, 10 as top_k)
  );

-- summarize into snippet
SELECT
  ml_generate_text_result.predictions[0].content AS summ,
  docid 
FROM
  ML.GENERATE_TEXT(
    MODEL `[PROJECT_ID].llm_demo.textbison32`,
    (SELECT CONCAT('Summarize the following text:', fulltext)AS prompt,
        docid
      FROM `[PROJECT_ID].llm_demo.doc_summaries`),
    STRUCT (0.1 AS temperature, 8192 AS max_output_tokens, 0.1 AS top_p, 10 as top_k)
  );

-- detect sentiment of the text
SELECT
  ml_generate_text_result.predictions[0].content AS sentiment,
  docid 
FROM
  ML.GENERATE_TEXT(
    MODEL `[PROJECT_ID].llm_demo.textbison32`,
    (SELECT CONCAT('Categorize the sentiment of the following text with the categories: yay, boo, ok:', fulltext)AS prompt,
        docid
      FROM `[PROJECT_ID].llm_demo.doc_summaries`),
    STRUCT (0.1 AS temperature, 8192 AS max_output_tokens, 0.1 AS top_p, 10 as top_k)
  );



-- update the fields in the table with the results of the model
UPDATE `[PROJECT_ID].llm_demo.doc_summaries` targ
SET 
  targ.sentiment = JSON_VALUE(sub.sentiment),
  targ.summary = JSON_VALUE(sub.summ),
  targ.bullet_points = JSON_VALUE(sub.bullet_points)
FROM (
  SELECT main.docid, bp.bullet_points, sent.sentiment, s.summ
    FROM `[PROJECT_ID].llm_demo.doc_summaries` main
    INNER JOIN 
    (
      -- summarize into bullet points
      SELECT
        ml_generate_text_result.predictions[0].content AS bullet_points,
        docid 
      FROM
        ML.GENERATE_TEXT(
          MODEL `[PROJECT_ID].llm_demo.textbison32`,
          (SELECT CONCAT('Summarize the following text into main bullet points:',fulltext)AS prompt,
              docid
            FROM `[PROJECT_ID].llm_demo.doc_summaries`),
          STRUCT (0.1 AS temperature, 8192 AS max_output_tokens, 0.1 AS top_p, 10 as top_k)
        )
    ) AS bp ON bp.docid = main.docid
    INNER JOIN 
    (
      -- summarize into snippet
      SELECT
        ml_generate_text_result.predictions[0].content AS summ,
        docid 
      FROM
        ML.GENERATE_TEXT(
          MODEL `[PROJECT_ID].llm_demo.textbison32`,
          (SELECT CONCAT('Summarize the following text:', fulltext)AS prompt,
              docid
            FROM `[PROJECT_ID].llm_demo.doc_summaries`),
          STRUCT (0.1 AS temperature, 8192 AS max_output_tokens, 0.1 AS top_p, 10 as top_k)
        )
    ) AS s ON s.docid = main.docid
    INNER JOIN 
    (
      -- detect sentiment of the text
      SELECT
        ml_generate_text_result.predictions[0].content AS sentiment,
        docid 
      FROM
        ML.GENERATE_TEXT(
          MODEL `[PROJECT_ID].llm_demo.textbison32`,
          (SELECT CONCAT('Categorize the sentiment of the following text with the categories: yay, boo, ok:', fulltext)AS prompt,
              docid
            FROM `[PROJECT_ID].llm_demo.doc_summaries`),
          STRUCT (0.1 AS temperature, 1000 AS max_output_tokens, 0.1 AS top_p, 10 as top_k)
        )
    ) AS sent ON sent.docid = main.docid
  ) AS sub
 WHERE sub.docid = targ.docid

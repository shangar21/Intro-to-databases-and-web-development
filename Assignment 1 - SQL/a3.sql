CREATE TABLE IF NOT EXISTS Syllabus(
id INTEGER NOT NULL PRIMARY KEY, 
topic TEXT NOT NULL, 
wed_pre_lec TEXT NOT NULL, 
wed_pre_lec_labels TEXT NOT NULL,
thurs_pre_lec TEXT NOT NULL, 
thurs_pre_lec_labels TEXT NOT NULL, 
wed_lec TEXT NOT NULL, 
wed_lec_labels TEXT NOT NULL, 
thurs_lec TEXT NOT NULL,
thurs_lec_labels TEXT NOT NULL);

INSERT INTO Syllabus VALUES(
2,
'Balanced Trees',
'None',
'None',
'Refresh Your Understanding Of BST, https://www.youtube.com/watch?v=mtvbVLK5xDQ',
'Refresh Your Understanding of BST, BST Visualization',
'https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w1/worksheet2_2021.pdf, https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w1/complexity_part2.pdf, https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w1/complexity_part2.pdf, https://utoronto.zoom.us/rec/play/cPkKVMthfBjSNh8C9arS5iU0ZBNtkUX8etKMklUCM8aPpiVtnl2_Y5YR_cWddFB2vlWa0jkGSEqWNEhk.hNVzvFkr8380FGns',
'Worksheet, Worksheet Annotated, Slides, Zoom Recording',
'https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w2/avl_worksheet.pdf, https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w2/avl_worksheet_inclass.pdf, https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w2/balancedtrees.pdf, https://utoronto.zoom.us/rec/play/YJYxBNbdKY8lIY98qjI_jHY5ZC73gSUeFCtAKmy6xJF6GEtw_VWFTFGr_guqhthaDEoRhYogPHBbR3fa.c5lUGL0uWjqS5aUX',
'Worksheet, Worksheet Annotated, Slides, Zoom Recording');


CREATE TABLE IF NOT EXISTS Labs(
id INTEGER NOT NULL PRIMARY KEY,
topic TEXT NOT NULL,
handout TEXT NOT NULL, 
handout_label TEXT NOT NULL,
solutions TEXT NOT NULL,
solutions_label TEXT NOT NULL);


INSERT INTO Labs VALUES(
1,
'No Tutorial',
'None',
'None',
'None',
'None');

INSERT INTO Labs Values(
2,
'Worst Case Complexity',
'https://mathlab.utsc.utoronto.ca/bretscher/b63/tutorials/w2.pdf',
'Handout',
'https://mathlab.utsc.utoronto.ca/bretscher/b63/tutorials/w2_soln.pdf',
'Solution');

INSERT INTO Syllabus Values(
2,
'Balanced Trees',
'None',
'None',
'Refresh Your Understanding Of BST, https://www.youtube.com/watch?v=mtvbVLK5xDQ',
'Refresh Your Understanding of BST, BST Visualization',
'https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w1/worksheet2_2021.pdf, https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w1/complexity_part2.pdf, https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w1/complexity_part2.pdf, https://utoronto.zoom.us/rec/play/cPkKVMthfBjSNh8C9arS5iU0ZBNtkUX8etKMklUCM8aPpiVtnl2_Y5YR_cWddFB2vlWa0jkGSEqWNEhk.hNVzvFkr8380FGns'
'Worksheet, Worksheet Annotated, Slides, Zoom Recording',
'https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w2/avl_worksheet.pdf, https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w2/avl_worksheet_inclass.pdf, https://mathlab.utsc.utoronto.ca/bretscher/b63/lectures/w2/balancedtrees.pdf, https://utoronto.zoom.us/rec/play/YJYxBNbdKY8lIY98qjI_jHY5ZC73gSUeFCtAKmy6xJF6GEtw_VWFTFGr_guqhthaDEoRhYogPHBbR3fa.c5lUGL0uWjqS5aUX',
'Worksheet, Worksheet Annotated, Slides, Zoom Recording');


CREATE TABLE IF NOT EXISTS AssignmentGrades(
aid INTEGER NOT NULL,
username INTEGER NOT NULL,
grade REAL NOT NULL,
weight REAL NOT NULL,
PRIMARY KEY (aid, username),
FOREIGN KEY(aid) REFERENCES Assignments(id));

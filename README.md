# SmartphoneHumanActivity

This code will "get and clean" the HAR UCI dataset of human activity using smartphone gyroscope data.  Some basic analysis is also performed.  
The Code first downloads and unzips the file and reads in the tables (x_train.txt, subject_train.txt, y_train.txt, x_test.txt, subject_test.txt, and y_test.txt), and first column binds the training tables together, then the test tables, and then r binds these merged tables into one table.  

Next the features data (found in "features.txt" of the original dataset) as the column names.

specific features are filtered out, and activity labels are added to the "id" and "names"

features are edited for easier human readability

Data is is "tidied up" using TidyR and dplyR



# Automated-Essay-Grading


## Abstract
Essays today are an important part of student evaluation. Nowadays , essays are being widely used to gauge students in various undergraduate/graduate level examinations. Evaluation and grading of essays comes as a major problem with human evaluation being slow , tedious , time taking thus making use of automated system imperative. In this paper, we will understand the essays and their evaluation criteria used for manual evaluation and attempts to  develop similar algorithmic systems. We explore features and techniques to identify and differentiate essays and application of models based on machine-learning algorithms to grade these essays. We have used pre-trained neural network models in SpaCy to improve featurization. We have also used zipf’s law (a statistical formula based on discrete power law probability distribution) allowing us to compare differences between calculated scores of different essays and mirror the results with the law.Future scope involves improving relevance of feedback given to students and application of neural networks to make more accurate predictions.

## Introduction
The educational path of students involves assessments to evaluate their knowledge , essays being one of them. Essays allow students to express ideas and opinions hence are better suited over straight true/false questions. They help test the knowledge and the higher-order-thinking skills of students. Hence they are widely used means of assessing students , used by universities for enrollments. As manually grading the essay is costly , tedious and time consuming , it becomes imperative to use automated systems to make the evaluation efficient and allow faster and easier grading of the essays.
Automated Essay Grading is a process of evaluating and grading essays using computer programs. [1]. These systems are used in many high stake assessments like GRE (Graduate Record Examination) , TOEFL (Test of English as a Foreign Language) , GMAT (Graduate Management Admission Test).These systems follow a supervised approach and build a model yielding quality of holistic grading comparable to that of humans. These systems learn the grading model based on a dataset of graded essays by humans. The dataset may have resolved scores (aggregate of essay scoring done by multiple people) or scores from individual human graders. These systems make use of certain properties of essays (called features) in order to estimate essay quality. In the grading process , these features are extracted and scores assigned according to manifestation of these features.                                                                                                                              Many kinds of features have been proposed for essay grading.[2]. They depend on degree of dependency to task , weakly dependent tend to be topic independent like length , connection , style while strongly dependent tend to follow the specific essay like the important words related to a topic. Association needs to be established between features and scoring values to estimate correct manifestation of these.
Here , we aim to create a system that grades the essays consistent with methods and orientations of humans and achieve an efficient system of grading the essay replacing the humans thus leading to more efficient work. 

## RELATED WORK
Automated Essay Grading has been rigorously studied from 1966 with Ellis page work on PEG and many more researchers from then have worked in the reduction of flaws in the essay grading models.
 In [3]. the researcher worked upon the edx Mooc courses and compared the holistic and rubric grading as compared to the instructor, this research gave credibility to the automated grading systems as the results showed that the difference between the holistic, rubric systems and the Instructor is minimal , while in [4]. feature engineering was given emphasis on as they used  PyEnchant spell checker with Linear regression model along with k-fold cross validation.
 In[5]. the researcher works with the SALDO lexicon for spell checking in Swedish language and also use a featurising metric OVIX lexical diversity measure along with Linear Discriminant Classifier and the results were effective as they got a good correlation as only 28 essays that comprises of 1.6% differ more than one step from the teacher’s grade although this work was done for the Swedish language the featurization can be used in the English language. 
The [6]. work came up with the classification of the features into strongly dependent and weakly dependent groups. Weakly Task dependent group contains length feature, occurrence of features, syntax , style , cohesion , error , readability , corpus similarity and task similarity while the strongly dependent features include the Set dependent features and Part of speech(POS). The task shows very low performance due to the much smaller amount of available training data, we get a mixed picture instead. It seems that even within a task, the full feature set overfits on specific words used in the training data. The kappa values are much lower for the English essays as was expected. 
The [7]. proposes a new way to automate the essay grading system using the neural networks. Learning vector Quantization is the method they used  along with a feedback module. Now this paper also generalizes the fact that the feedback is necessary especially for the students who speak English as a foreign language. 
[8]. Uses a special word net feature like language fluency and they are trying to relate the word to the domain. Teachers don’t necessarily have all the domain knowledge and this feature can come in handy when the domain specific essays are to be evaluated. This current approach tries to model the language features like language fluency, grammatical correctness, domain information content of the essays, and put an effort to fit the best polynomial in the feature space using linear regression with polynomial basis functions.
 
### DATA AND EVALUATION
In this section we have discussed the detailed description of the datasets , tools and packages, preprocessing , featurization , feature selection and models used for the assessment of the essays in the dataset. The dataset used has almost 12976 essays with the average word length of 150-550 words per response. The basic architecture of the Automated Essay Grading model is shown in the Figure 1. 
First the essays is collected from the online platform and then the essay  goes through basic cleaning then the essay is used for feature extraction from the corrected essay which is tokenized and then this essay will be lemmatized and and then feature selection is done to reduce the dimension of the data following it will be vectorised , then this the essay will be split into training and testing  and then the model is trained through machine learning algorithms and then we can pass essays through the system for the assessment of the essays. Further description is stated in subsections.

                      
![Alt text](https://github.com/NishantSushmakar/Automated-Essay-Grading/blob/main/Architecutre.png?raw=true 'Figure 1. Architecture of Automated essay Grading System')
    



           


### Dataset 
We have taken the datasets from Hewlett foundation Competition in Kaggle . The dataset is divided into 8 sets , each having its own marking criteria , essay characteristics and qualities.
Below , table 1 describes the different sets.



![Alt text](https://github.com/NishantSushmakar/Automated-Essay-Grading/blob/main/Description%20of%20set.png?raw=true "Table 1. Description of Sets")        
                               


                                              
         		

Different sets have different criteria followed for marking the essays
1.	Set 1 - Essays are marked on providing elaboration and specific details , having strong organization and on fluency and transitional language.
2.	Set 2 - Essays are marked for ideas and their unifying theme , structuring and flow into beginning , middle , end. Essays are also evaluated for vocabulary , writing techniques and presentation of perspectives to the audience.
3.	Set 3 - Essays are marked for their ability to convey meaning based on demands , understanding of given questions and clarification beyond the literal.
4.	Set 4 - Essays are marked for addressing the demands of the question , use of ideas/conclusions based on implication of question , ability to connect support to conclusion based on assertion made about the question.
5.	Set 5 -  Essays are marked for their clarity , completeness and accuracy of mood description created by the author.
6.	Set 6 -  Essays are marked for their accuracy of description for the specific topic from the excerpt (based on which they are written) stating all points/information related and mentioned in the excerpt. Emphasis is on including relevant and specific information.
7.	Set 7 - Essays are marked for the story (as asked) on the topic given. Ideas and their cohesion with the topic is seen emphasizing all relevant details and specifics.
8.	Set 8 -  Essays are marked for clarity , focus and control. Emphasis is on main ideas that stand out. Also supporting resources are seen for credibility. Essay is viewed for explanation , inter-connections and insights and suitability of content for the audience.

### Software Tools and Packages
We chose to implement our model in Python 3 since there exist diverse set of open source libraries. We have used Natural Language Toolkit (NLTK) and SpaCy for most NLP tasks along with a language_check tool for the grammatical mistakes.Other Libraries such as sklearn,numpy, pandas,matplotlib,plotly,seaborne has been used for various tasks.

### Preprocessing
Essay grading requires to assess the error done by the students and to get the desired results the essays cannot be preprocessed on a lot of factors to maintain the originality of the essay , so only few steps are being taken into account for processing in the following order:
1.	Lowercase: All of the words are changed to lowercase so that during part of speech tagging the model doesn’t change the meaning on different instances.
2.	Special Characters are removed : Every special character except the ‘@’ symbol is removed from the essay as it is of no use in the essay assessment and featurization.
3.	Removal of Stopwords: This processing step is used while correcting the essay as you can read in the next section after correcting the essay grammar then this step is used to identify and remove stopwords.
4.	Lemmatization: The essay after correcting the errors and removal of stopwords is lemmatized to remove the inflectional endings and return the base or dictionary form of a word.

### Feature Extraction
We used mainly Spacy , language check and NLTK for the feature extraction. The essay grammatical errors were identified through the use of language check tool and the corrected essay was made as a feature of the dataset and then the following features were extracted from the corrected essay:
1.	Grammatical errors: language check tool helps to identify the grammatical errors in the essay and then labels each error in a list.
2.	Sentence : The corrected essay was tokenized to split the essay into a list of sentences using SpaCy sentence tokenizer.
3.	Part of Speech : SpaCy is very efficient for such extraction ,it was used in place of NLTK as its pre-trained neural models help to efficiently identify the parts of speech for the corrected essays and to label them.
4.	Named Entity Recognized: Essays  prior to be used for the model had already been annotated by hiding the names of Entities using Stanford NLP and therefore converted them into several such  entities identified by NER are: "PERSON", "ORGANIZATION", "LOCATION", "DATE", "TIME", "MONEY", "PERCENT" which start with a ‘@’ . Spacy was used for their identification .
5.	TF-IDF: The corrected essays after the extraction of the prior stated features was then after lemmatizing with the help of Spacy was then vectorised with the help of sklearn library. It considers the importance of the word in the corpus and increases as the number of times that word occurs in the document.
6.	Similarity Scores : The essays which were graded with  higher marks in each set were compared with every other essay of the same set and the similarity score was generated  by the help of SpaCy .

Several other features were extracted from these features such as  token count , unique token count , not in stopword count (‘nostop_count’) , sentence count , named entity recognised count , comma , exclamation , quotation , ‘organisation’, ‘Caps’ , ‘location’, ‘money’, ‘time’, ‘date’,  ‘percent’ , ‘noun’ , adjective (‘adj’) , pronoun (‘pron’), verb, conjunction (‘cconj’) , adverb (‘adv’) ,  Determiner (‘det’) , numeral (‘num’) , particle (‘part’) , interjection(‘intj’) counts.   

### Feature Selection 
After the extraction of the features from the essay the dimensionality of the model was reduced by the help of SelectKBest using Chi square method for each set of essay for  which the result is stated in table 2.


![Alt text](https://github.com/NishantSushmakar/Automated-Essay-Grading/blob/main/best_feature_kbest.png?raw=true "Table 2. 10 Best Features for each set using SelectKBest method")



 

To check the correlation of features within themselves such that the model prevents collinearity then visualization was used as stated in fig 2.

![Alt text](https://github.com/NishantSushmakar/Automated-Essay-Grading/blob/main/Coorelation%20of%20features.png?raw=true "Fig 2. Correlation of Features")



Highly correlated features were removed by assessing the Fig 2.

#### Models 
We have experimented with four machine learning models i.e. Linear Support Vector Classification , Linear Regression , Random Forest Regressor and Elastic Net . Linear Support Vector derives a linear decision curve and does not accept a kernel whereas the simplest algorithm is the Linear Regression which uses stochastic gradient descent to find out the best fitting line for the model but it does not avoid overfitting as the dataset is tabulated with features Random forest regression can be very useful. To cure the problem of overfitting, Elastic Net can be used as it adds both types of regularization to Linear regression and  the model can be very much useful.

## References 

1. M. A. Hearst, "The debate on automated essay grading," in IEEE Intelligent Systems and their Applications, vol. 15, no. 5, pp. 22-37, Sept.-Oct. 2000, doi: 10.1109/5254.889104.
2. Valenti, S., Neri, F. & Cucchiarelli, A. (2003). An Overview of Current Research on Automated Essay Grading. Journal of Information Technology Education: Research, 2(1), 319-330. Informing Science Institute. Retrieved August 31, 2020 from https://www.learntechlib.org/p/111481/.
3. Reilly, E. D., Stafford, R. E., Williams, K. M., & Corliss, S. B. (2014). Evaluating the validity and applicability of automated essay scoring in two massive open online courses. International Review of Research in Open and Distance Learning, 15(5), 83–98. https://doi.org/10.19173/irrodl.v15i5.1857
4. Automated Essay Grading Using Machine Learning Manvi Mahana, Mishel Johns, Ashwin Apte CS229 Machine Learning
5. Östling, R., Smolentzov, A., Tyrefors Hinnerich, B., & Höglin, E. (2013). Automated Essay Scoring for Swedish. In Proceedings of the Eighth Workshop on Innovative Use of NLP for Building Educational Applications (pp. 42–47). Atlanta, Georgia: Association for Computational Linguistics. Retrieved from http://www.diva-portal.org/smash/record.jsf?pid=diva2:625983
6. Zesch, T., Wojatzki, M., & Scholten-Akoun, D. (2015). Task-Independent Features for Automated Essay Grading (pp. 224–232). Association for Computational Linguistics (ACL). https://doi.org/10.3115/v1/w15-0626
7. Lvq, B., & Techniques, N. L. P. (2016). A Hybrid Scheme for Automated Essay Grading, 65–70.
8. Ramalingam, V. V., Pandian, A., Chetry, P., & Nigam, H. (2018). Automated Essay Grading using Machine Learning Algorithm. In Journal of Physics: Conference Series (Vol. 1000). Institute of Physics Publishing. https://doi.org/10.1088/1742-6596/1000/1/012030
9. Page, E. B. (2003). Project Essay Grade: PEG. In M. D. Shermis & J. Burstein (Eds.), Automated essay scoring: A cross-disciplinary perspective (p. 43–54). Lawrence Erlbaum Associates Publishers. 
10. Shermis, M. D., Koch, C. M., Page, E. B., Keith, T. Z., & Harrington, S. (2002). Trait Ratings for Automated Essay Grading. Educational and Psychological Measurement, 62(1), 5–18. https://doi.org/10.1177/001316440206200101 
11. Williams, Robert. 2001. Automated essay grading: an evaluation of four conceptual models, in Kulski, Martijntje and Herrman, Allan (ed), New horizons in university teaching and learning: Responding to change, pp 173-184. Perth Australia: Centre for Educational Advancement, Curtin University.
12. S.W. Freedman, “Student Characteristics and Essay Test Writing Performance,” Research in the Teaching of English, Vol. 17, 1983. 
13. M. Russell and W. Haney, “Testing Writing on Computers: An Experiment Comparing Student Performance in Tests Conducted via Computer and via Paper-and-Pencil,” Education Policy Analysis Archives, Vol. 5, No. 3, May/June, 1997; http://epaa.asu.edu/ epaa/v5n3.html (current Nov. 2000). 
14. R.E. Bennett and I.I. Bejar, “Validity and Automated Scoring: It’s Not Only the Scoring,” Educational Measurement: Issues and Practice, Vol. 17, No. 4, 1998. pp. 9–17. 
15. P. Foltz, W. Kintsch, and T. Landauer, “The Measurement of Textual Coherence with Latent Semantic Analysis,” Discourse Processes, Vol. 25, 1998, pp. 285–308. 
16. M. Light (Ed.), Proc. Workshop on Reading Comprehension Tests as Evaluation for Computer-Based Language Understanding Systems, Association for Computational Linguistics, New Brunswick, 2000.

## Dataset
https://www.kaggle.com/c/asap-aes


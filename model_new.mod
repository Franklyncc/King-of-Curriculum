param PR;
param CourseNum;　　#10365
param TotalCreditEarned;　#143
param Time{i in 1..11, j in 1..CourseNum, k in 1..6, l in 1..15};
param Teach{i in 1..11, j in 1..CourseNum, k in 1..8};
param Credit{i in 1..11, j in 1..CourseNum};
param CreditUpper{i in 1..8};
param CreditLower{i in 1..8};
param AccuGPA{i in 1..11, j in 1..CourseNum, k in 1..10};　#GPA等第的"累積人數"
param StudentNum{i in 1..11, j in 1..CourseNum};
param LevelGPA{i in 1..10};

var choose{i in 1..11, j in 1..CourseNum, k in 1..8} binary;
var general_education{i in 1..8} binary;
var hope_GPA{i in 1..11, j in 1..CourseNum} ;
var level_PR{i in 1..11, j in 1..CourseNum, k in 1..10} binary;

maximize max_GPA:
	(sum{i in 1..11, j in 1..CourseNum, k in 1..8}(expected_GPA[i,j]*choose[i,j,k]*Credit[i,j]));

subject to credit_lower_bound{k in 1..8}:#每學期最低學分數
	sum{i in 1..11, j in 1..CourseNum}(choose[i,j,k]*Credit[i,j]) >= CreditLower[k];
subject to credit_upper_bound{k in 1..8}:#每學期最高學分數
	sum{i in 1..11, j in 1..CourseNum}(choose[i,j,k]*Credit[i,j]) <= CreditUpper[k];
subject to general_education_restrict{i in 1..8}:#判斷通識該領域有沒有修
 	sum{j in 1..CourseNum, k in 1..8}choose[i,j,k] >= general_education[i];
subject to choose_four_from_six:#通識六選四
	sum{i in 1..4}general_education[i] +sum{i in 7..8}general_education[i]>= 4;
subject to graduate_credit:#畢業學分要求(目前訂死，不然cplex不能跑)
	sum{i in 1..11, j in 1..CourseNum, k in 1..8}(choose[i,j,k]*Credit[i,j]) = totalCreditEarned;
subject to general_education_lower:#通識至少修18
	sum{i in 1..4, j in 1..CourseNum, k in 1..8}
    (choose[i,j,k]*Credit[i,j])+sum{i in 7..8, j in 1..CourseNum, k in 1..8}(choose[i,j,k]*Credit[i,j]) >=18;
subject to departmentOptional_lower:#系內選修至少12
	sum{j in 1..8, k in 1..8}(choose[9,j,k]*Credit[9,j])+sum{j in 30..34, k in 1..8}(choose[9,j,k]*Credit[9,j])>=12;
subject to lesson_time{k in 1..8, m in 1..6, l in 1..15}:#上課不衝堂
	sum{i in 1..11, j in 1..CourseNum}Time[i,j,m,l]*choose[i,j,k] <= 1;

subject to out_department:#系外選修學分要到(加上國文、體育)
	sum{j in 1..CourseNum, k in 1..8}choose[10,j,k]*Credit[10,j] >= 28;

subject to firstSemesterObligatory{j in 3..5}: choose[11,j,1] = 1;#每學期必修
subject to secondSemesterObligatory{j in 15..17}: choose[11,j,2] = 1;
subject to thirdSemesterObligatory{j in 6..10}: choose[11,j,3] = 1;
subject to fourthSemesterObligatory{j in 18..22}: choose[11,j,4] = 1;
subject to fifthSemesterObligatory{j in 11..12}: choose[11,j,5] = 1;
subject to sixthSemesterObligatory: choose[11,23,6] = 1;

subject to firstSemesterCalculusTwoChooseOne: choose[11,1,1]+choose[11,2,1] >= 1;#微積分選一個班
subject to secondSemesterCalculusTwoChooseOne: choose[11,13,2]+choose[11,14,2] >= 1;

subject to PEobligatory1:#健康體適能要修
	sum{j in 1..77, k in 1..8}(choose[10,j,k]) >= 1;
subject to FreshmenChinese1:#大一國文
	sum{j in 390..401}choose[10,j,1] =1;
subject to FreshmenChinese2:
	sum{j in 5623..5634}choose[10,j,2] =1;
subject to PEoptional:#專項運動學群要修3個
	sum{j in 80..214, k in 1..8}choose[10,j,k]+sum{j in 5242..5445, k in 1..8}choose[10,j,k] >= 3;

subject to lesson_open{i in 1..11, j in 1..CourseNum, k in 1..8}:#那個學期有開課
	choose[i,j,k] <= Teach[i,j,k];
subject to one_time{i in 1..11, j in 1..CourseNum}:#一個課只能修一次
	sum{k in 1..8}choose[i,j,k] <= 1;
subject to financialManagementChooseOne:#財務管理多選一
	sum{j in 11..16, k in 1..8}choose[9,j,k]+sum{j in 23..27, k in 1..8}choose[9,j,k] <= 1;
subject to marketingManagementChooseOne:#行銷管理多選一
	sum{j in 19..22, k in 1..8}choose[9,j,k] <= 1;
subject to strategyManagementChooseOne:#策略管理多選一
	sum{j in 17..18, k in 1..8}choose[9,j,k] <= 1;
subject to choose_two_from_five:#五選二必修
	sum{j in 10..28, k in 1..8}choose[9,j,k] >= 2;
subject to choose_one_from_two:#二選一必修
	sum{k in 1..8}(choose[9,9,k]+choose[9,28,k]) >= 1;
subject to PR_level_distance{i in 1..11, j in 1..CourseNum, k in 1..10}:#算PR前置步驟
	(999*(1-level_PR[i,j,k])+(PR/100))*100.0 >= (100.0*AccuGPA[i,j,k]/StudentNum[i,j]);
subject to calculate_GPA{i in 1..11, j in 1..CourseNum}:
	expected_GPA[i,j] = sum{k in 1..10}level_PR[i,j,k]*LevelGPA[k];

subject to nonnegative{i in 1..11, j in 1..CourseNum}:
	expected_GPA[i,j]>=0;

# subject to integerRelaxation10{i in 1..11, j in 1..CourseNum, k in 1..8}:choose[i,j,k]>=0;
# subject to integerRelaxation11{i in 1..11, j in 1..CourseNum, k in 1..8}:choose[i,j,k]<=1;
# subject to integerRelaxation20{i in 1..8}:general_education[i]>=0;
# subject to integerRelaxation21{i in 1..8}:general_education[i]<=1;
# subject to integerRelaxation30{i in 1..11, j in 1..CourseNum, k in 1..10}:level_PR[i,j,k]>=0;
# subject to integerRelaxation31{i in 1..11, j in 1..CourseNum, k in 1..10}:level_PR[i,j,k]<=1;

#pseudo ampl 如下
# Param 個人PR值
# Param 課程上課時間 [ 1~8通識, 9:系內選修, 10:系外選修, 11:必修 ][ 課程獨立ID : 各類別最大課程數N ][  星期 ][ 時段 ]   (binary)
# Param 課程是否有開 [ 1~8通識, 9:系內選修, 10:系外選修, 11:必修 ][ 課程獨立ID : 各類別最大課程數N ][ 1~8學期 ] (binary)
# Param 課程學分數 [ 1~8通識, 9:系內選修, 10:系外選修, 11:必修 ][ 課程獨立ID : 各類別最大課程數N ]
# Param 每學期學分上限[ 1~8學期 ]
# Param 每學期學分下限[ 1~8學期 ]
# Param 課程GPA各級距累積人數 [ 1~8通識, 9:系內選修, 10:系外選修, 11:必修 ][ 課程獨立ID : 各類別最大課程數N ][GPA的10個級距]
# Param 歷史修課人數 [ 1~8通識, 9:系內選修, 10:系外選修, 11:必修 ][ 課程獨立ID : 各類別最大課程數N ]
# Param 級距對應累積GPA [GPA的10個級距]   # 每格代表的是此級距與上個級距之GPA差。比如說 A的對應GPA就是第1~9格全部加起來
# Var 課程是否被選 [ 1~8通識, 9:系內選修, 10:系外選修, 11:必修 ][ 課程獨立ID : 各類別最大課程數N ][ 1~8學期 ]
# Var 某類別通識有沒有被選 [ 1~8通識 ] binary;
# Var GPA期望值 [ 1~8通識, 9:系內選修, 10:系外選修, 11:必修 ][ 課程獨立ID: 各類別最大課程數N ];
# Var PR有到級距 [ 1~8通識, 9:系內選修, 10:系外選修, 11:必修 ][ 課程獨立ID : 各類別最大課程數N ][GPA的10個級距] (binary);


# max sum{i from 1 to 11, j from 1 to N} GPA期望值[i][j] * 課程是否被選[i][j]
# 每學期學分要到下限for k from 1 to 8 : sum{ i from 1 to 11, j from 1 to N}  課程是否被選[i][j][k]* 課程學分數[i][j] >= 每學期學分下限[k];
# 每學期學分要不超上限for k from 1 to 8 : sum{ i from 1 to 11, j from 1 to N}  課程是否被選[i][j][k]* 課程學分數[i][j] <= 每學期學分上限[k];
# 各類別通識有沒有被選for i from 1 to 8 : sum{ j from 1 to N, k from 1 to 8}  課程是否被選[i][j][k] >= 某類別通識有沒有被選[i];
# 通識8選4 : sum{i from 1 to 8} 某類別通識有沒有被選[i] >= 4;
# 通識畢業學分要到: sum{ i from 1 to 8, j from 1 to N, k from 1 to 8}  課程是否被選[i][j][k]*課程學分數[i][j] >= 18;
# 上課時間限制 for  k from 1 to 8, m from 1 to 6, l from 1 to 15: sum i from 1 to 11, j from 1 to N 課程上課時間[i][j][m][l] * 課程是否被選[i][j][k] <= 1;
# 系外選修要到 : sum{  j from 1 to N, k from 1 to 8}  課程是否被選[10][j][k]*課程學分數[10][j] >= 不知道多少;
# 必修都要修 :  # 手動把 必修課在甚麼時候被修設定好。EX:  "課程是否被選[11][2][2] = 1"表示 2號必修課在一下被選完了
# 課要有開 for i from 1 to 11, j from 1 to N, k from 1 to 8: 課程是否被選[i][j][k] <= 課程是否有開[i][j][k]
# 同個課只能修一次 for i from 1 to 11, j from 1 to N : sum{k from 1 to 8} 課程是否被選[i][j][k] <= 1;
# 選修學分要到(5選二)  : sum {j from 1 to 5, k from 1 to 8} 課程是否被選[9][j][k] >= 2;
# 選修學分要到(二選一)  : sum {j from 6 to 7, k from 1 to 8} 課程是否被選[9][j][k] >= 1;
# # 以下是算GPA期望值
# PR有到的級距 for i from 1 to 11, j from 1 to N, k from 1 to 10 : Mega*(1 -  PR有到級距[i][j][k]) + 個人PR >= 課程GPA各級距累積人數[i][j][k] / 歷史修課人數[i][j]
# 課程GPA期望值 for i from 1 to 11, j from 1 to N : GPA期望值  = sum{k from 1 to 10} PR有到級距[i][j][k]

param PR;
param Time{i in 1..11, j in 1..10382, k in 1..6, l in 1..15};
param Teach{i in 1..11, j in 1..10382, k in 1..8};
param Credit{i in 1..11, j in 1..10382};
param CreditUpper{i in 1..8};
param CreditLower{i in 1..8};
param AccuGPA{i in 1..11, j in 1..10382, k in 1..10};
param StudentNum{i in 1..11, j in 1..10382};
param LevelGPA{i in 1..10};

var choose{i in 1..11, j in 1..10382, k in 1..8};
var general_education{i in 1..8};
var hope_GPA{i in 1..11, j in 1..10382};
var level_PR{i in 1..11, j in 1..10382, k in 1..10};

maximize max_GPA:
	(sum{i in 1..11, j in 1..10382, k in 1..8}(hope_GPA[i,j]*choose[i,j,k]));
	#/ (sum{i in 1..11, j in 1..10382, k in 1..8}(choose[i,j,k]*Credit[i,j]));

subject to credit_lower_bound{k in 1..8}:
	sum{i in 1..11, j in 1..10382}(choose[i,j,k]*Credit[i,j]) >= CreditLower[k];
subject to credit_upper_bound{k in 1..8}:
	sum{i in 1..11, j in 1..10382}(choose[i,j,k]*Credit[i,j]) <= CreditUpper[k];
subject to general_education_restrict{i in 1..8}:
	sum{j in 1..10382, k in 1..8}choose[i,j,k] >= general_education[i];
subject to choose_four_from_six:
	sum{i in 1..4}general_education[i] +sum{i in 7..8}general_education[i]>= 4;
subject to graduate_credit:
	sum{i in 1..8, j in 1..10382, k in 1..8}(choose[i,j,k]*Credit[i,j]) >= 139;
# subject to lesson_time{k in 1..8, m in 1..6, l in 1..15}:
# 	sum{i in 1..11, j in 1..10382}Time[i,j,m,l]*choose[i,j,k] <= 1;

subject to out_department:
	sum{j in 1..10382, k in 1..8}choose[10,j,k]*Credit[10,j] >= 18;

subject to firstSemesterObligatory{j in 3..5}: choose[11,j,1] = 1;
subject to secondSemesterObligatory{j in 15..17}: choose[11,j,2] = 1;
subject to thirdSemesterObligatory{j in 6..10}: choose[11,j,3] = 1;
subject to fourthSemesterObligatory{j in 18..22}: choose[11,j,4] = 1;
subject to fifthSemesterObligatory{j in 11..12}: choose[11,j,5] = 1;
subject to sixthSemesterObligatory: choose[11,23,6] = 1;

subject to firstSemesterCalculusTwoChooseOne: choose[11,1,1]+choose[11,2,1] >= 1;
subject to secondSemesterCalculusTwoChooseOne: choose[11,13,2]+choose[11,14,2] >= 1;

subject to lesson_open{i in 1..11, j in 1..10382, k in 1..8}:
	choose[i,j,k] <= Teach[i,j,k];
subject to one_time{i in 1..11, j in 1..10382}:
	sum{k in 1..8}choose[i,j,k] <= 1;
subject to financialManagementChooseOne:
	sum{j in 11..16, k in 1..8}choose[9,j,k]+sum{j in 23..27, k in 1..8}choose[9,j,k] <= 1;
subject to marketingManagementChooseOne:
	sum{j in 19..22, k in 1..8}choose[9,j,k] <= 1;
subject to strategyManagementChooseOne:
	sum{j in 17..18, k in 1..8}choose[9,j,k] <= 1;
subject to choose_two_from_five:
	sum{j in 10..28, k in 1..8}choose[9,j,k] >= 2;
subject to choose_one_from_two:
	sum{k in 1..8}(choose[9,9,k]+choose[9,28,k]) >= 1;
subject to PR_level_distance{i in 1..11, j in 1..10382, k in 1..10}:
	99999999*(1-level_PR[i,j,k])+PR/100 >= AccuGPA[i,j,k]/StudentNum[i,j];
subject to calculate_GPA{i in 1..11, j in 1..10382}:
	hope_GPA[i,j] = sum{k in 1..10}level_PR[i,j,k]*LevelGPA[k];

subject to nonnegative{i in 1..11, j in 1..10382}:
	hope_GPA[i,j]>=0;

subject to integerRelaxation10{i in 1..11, j in 1..10382, k in 1..8}:choose[i,j,k]>=0;
subject to integerRelaxation11{i in 1..11, j in 1..10382, k in 1..8}:choose[i,j,k]<=1;
subject to integerRelaxation20{i in 1..8}:general_education[i]>=0;
subject to integerRelaxation21{i in 1..8}:general_education[i]<=1;
subject to integerRelaxation30{i in 1..11, j in 1..10382, k in 1..10}:level_PR[i,j,k]>=0;
subject to integerRelaxation31{i in 1..11, j in 1..10382, k in 1..10}:level_PR[i,j,k]<=1;
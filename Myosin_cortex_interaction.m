%CLEAR THE WORKSPACE

clear all
clc

%ARRAYS OF PARAMETERS

str = ["cell 1 Bleb 1", "cell 1 Bleb 2", "cell 1 Bleb 3", "cell 1 Bleb 4"...
   "cell 2 Bleb A1", "cell 2 Bleb B1", "cell 2 Bleb C1", "cell 2 Bleb C2"...
  "cell 2 Bleb D1", "cell 2 Bleb D2", "cell 2 Bleb E1", "cell 3 Bleb B1"...
  "cell 3 Bleb B2", "cell 3 Bleb B3", "cell 3 Bleb B4", "cell 4 Bleb B1", ...
  "cell 4 Bleb B2", "cell 5 Bleb B1", "cell 6 Bleb B1", "cell 7 Bleb B1", "cell 8 Bleb B1", ...
  "cell 10 Bleb B1", "cell 10 Bleb B2", "cell 12 Bleb B1", "cell 15 Bleb B1", ...
  "cell 15 Bleb B2"];

data_sheet = ["cell001B1.xlsx", "cell001B2.xlsx", "cell001B3.xlsx","cell001B4.xlsx", ...
    "cell002BA1.xlsx", "cell002BB1.xlsx", "cell002BC1.xlsx", "cell002BC2.xlsx", ... 
    "cell002BD1.xlsx", "cell002BD2.xlsx", "cell002BE1.xlsx","cell003B1.xlsx", ...
   "cell003B2.xlsx", "cell003B3.xlsx", "cell003B4.xlsx", "cell004B1.xlsx", "cell004B2.xlsx", ...
   "cell005B1.xlsx", "cell006B1.xlsx", "cell007B1.xlsx", "cell008B1.xlsx", "cell0010AB1.xlsx",...
   "cell0010BB2.xlsx", "cell0012B1.xlsx", "cell0015AB1.xlsx", "cell0015AB2.xlsx" ];

frames = [15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15 ,15 ,15, 14 ...
    14, 14, 14, 14, 14, 14, 14];

bleb_start = [2, 3, 4, 12, 9, 3, 3, 2, 8, 7, 11, 4, 5, 6, 9, 10, 11, 4, 6, 6, 6, 10, 8, 7, 12];

bleb_frame1 = [18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 17 ...
    17, 17, 17, 17, 17, 17, 17];

bleb_frame2 = [35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35 ,35 ,35, 33 ...
    33, 33, 33, 33, 33, 33, 33];

frame_rates = [2.05, 2.05, 2.05, 2.05, 2.14, 2.14, ...
    2.14, 2.14, 2.14, 2.14, 2.14, 2.04, 2.04, 2.04, ...
    2.04, 2.03, 2.03, 2.14, 2.14, 2.16, 2.15, 2.16, ...
    2.16, 2.16, 2.16, 2.16];

% ALLOCATE SPACE

counter = zeros(1,max(frames)-min(bleb_start));

mean = zeros(1,max(frames)-min(bleb_start));

solutions = zeros(length(bleb_start), max(frames));

stderror = zeros(1,max(frames)-min(bleb_start));

interpolation = zeros(3*length(bleb_start), max(frames));

wanted_frame_rate = 2.14 * ones(1,15);

index_frame_rates = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];

interpolation_solutions = zeros(length(bleb_start), max(frames));

% MAIN LOOP TO RUN MAX FXN AND SAVE RESULTS IN SOLUTION VECTOR

for i = 1:length(bleb_start)
    
    [solutions(i, :)] = max_fxn(str(i), data_sheet(i), bleb_start(i), frames(i), 0, bleb_frame1(i), bleb_frame2(i));
      
end

solutions;


for i = 1:length(bleb_start)
   
        index_frame_rates = 0:1:frames(i)-1;
        
        frame = frame_rates(i) * ones(1,frames(i));
        
        frame = frame .* index_frame_rates;
        
        [interpolation_solutions(i,:)] = linearspline(frame, solutions(i,1:frames(i)), index_frame_rates.*wanted_frame_rate(1:1:frames(i)));

end

interpolation_solutions;

temp = interpolation_solutions; %set a temp matrix equal to solutions matrix
temp(temp==0)= NaN; %change all zeros in the matrix to NaN

%kruskalwallis(temp);



% CALCULATING STANDARD DEVIATION OF EACH COLUMN

solutions = interpolation_solutions;

[row, columns] = size(solutions);

std_columns = nanstd(temp,[],1); %take the standard deviation of the columns ignoring all NaN entries
std_columns = std_columns(1:columns); %extract all but the NaN columns from matrix


% LOOP TO DETERMINE HOW MANY NON-ZERO ENTRIES IN EACH COLUMN

for i = 1:columns
    
    counter(i) = sum(solutions(:,i)~=0);
    
end


% CALCULATE THE SUM OF EACH COLUMN 

sum_column_elements = sum(solutions);

length(solutions)


% LOOP TO CALCULATE THE AVERAGE OF EACH COLUMN

for i = 1:columns
    
    mean(i) = sum_column_elements(i)/counter(i);
    
end


% LOOP TO CALCULATE THE STANDARD ERROR

for i = 1:columns
    
    stderror(i) = std_columns(i)/sqrt(counter(i));
    
end

% PLOT THE MEAN AND STANDARD DEVIATION

errorbar(mean, stderror,'-s','MarkerSize',10,...
    'MarkerEdgeColor','red',"LineWidth",3)
grid on
xticks(0:1:max(frames)-min(bleb_start))
xlim([1 max(frames)-min(bleb_start)])
xlabel('Frame From Bleb Start')
ylabel('Fluoresence (AU)')
title('Mean and Standard Error of Fluoresence (AU) from Time of Bleb Start')